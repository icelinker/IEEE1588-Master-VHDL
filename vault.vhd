----------------------------------------------------------------------------------
-- Company: 
-- Engineer: CW
-- 
-- Create Date:    21:25:31 10/06/2014 
-- Design Name: 
-- Module Name:    hw_client - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity vault is
    Port ( 	CLK_IN 			: in STD_LOGIC;
			LED_OUT 		: out STD_LOGIC;

			VO_OUT			: out STD_LOGIC;
			RS_OUT			: out STD_LOGIC;
			RW_OUT			: out STD_LOGIC;
			E_OUT			: out STD_LOGIC;
			DB_OUT			: out STD_LOGIC_VECTOR(7 downto 0);
			
			TX_OUT 			: out STD_LOGIC;
			RX_IN 			: in STD_LOGIC;
			PPS_IN 			: in STD_LOGIC;
			RX_TEST_OUT 	: out STD_LOGIC;
			PPS_TEST_OUT 	: out STD_LOGIC;

			TX_DEBUG_OUT 	: out STD_LOGIC;
			RX_DEBUG_IN 	: in STD_LOGIC;

			ETH_CLK_IN		: in std_logic;
			ETH_CRS_IN		: in std_logic;
			ETH_RXD_IN		: in std_logic_vector(1 downto 0);
			ETH_TXD_EN_OUT 	: out std_logic;
			ETH_TXD_OUT 	: out std_logic_vector(1 downto 0));
end vault;

architecture Behavioral of vault is

	COMPONENT clk_mod
		 Port ( 	CLK_100MHz_IN 	: in  STD_LOGIC;
					CLK_66MHz_OUT	: out STD_LOGIC;
					CLK_100Mhz_OUT 	: out  STD_LOGIC);
	END COMPONENT;
	
	COMPONENT sseg
	PORT (	
		CLK    : in STD_LOGIC;
		VAL_IN  	: in STD_LOGIC_VECTOR (15 downto 0);
		SSEG_OUT	: out STD_LOGIC_VECTOR(7 downto 0);
		AN_OUT   : out STD_LOGIC_VECTOR(3 downto 0));
	END COMPONENT;

	COMPONENT led_mod is
    PORT ( CLK_IN 				: in  STD_LOGIC;
           LED_STATE_IN 		: in  STD_LOGIC_VECTOR (2 downto 0);
			  ERROR_CODE_IN		: in	STD_LOGIC_VECTOR (4 downto 0);
			  ERROR_CODE_EN_IN	: in	STD_LOGIC;
           LEDS_OUT 				: out  STD_LOGIC_VECTOR (1 downto 0);
			  CLK_1HZ_OUT			: out STD_LOGIC);
	END COMPONENT;
	
	COMPONENT lcd16x2_ctrl is
	  GENERIC (
		 CLK_PERIOD_NS : positive := 10);
	  PORT (
		 clk          : in  std_logic;
		 rst          : in  std_logic;
		 lcd_v 		  : out std_logic;
		 lcd_e        : out std_logic;
		 lcd_rs       : out std_logic;
		 lcd_rw       : out std_logic;
		 lcd_db       : out std_logic_vector(7 downto 0);
		 line1_buffer : in  std_logic_vector(127 downto 0);  -- 16x8bit
		 line2_buffer : in  std_logic_vector(127 downto 0));
	END COMPONENT;

    COMPONENT uart is
    GENERIC (
        baud                : positive;
        clock_frequency     : positive
    );
    PORT (  
        clock               :   in  std_logic;
        reset               :   in  std_logic;    
        data_stream_in      :   in  std_logic_vector(7 downto 0);
        data_stream_in_stb  :   in  std_logic;
        data_stream_in_ack  :   out std_logic;
        data_stream_out     :   out std_logic_vector(7 downto 0);
        data_stream_out_stb :   out std_logic;
        tx                  :   out std_logic;
        rx                  :   in  std_logic
    );
    END COMPONENT;
	 
    COMPONENT nmea_parser is
    port (  
            CLK_IN          		: IN  STD_LOGIC;
            RST_IN          		: IN  STD_LOGIC;
				
            NMEA_EN_IN      		: IN  STD_LOGIC;
            NMEA_DATA_IN    		: IN  STD_LOGIC_VECTOR(7 downto 0);
				
		 	NMEA_EN_OUT     		: OUT STD_LOGIC;
            NMEA_DATA_OUT   		: OUT STD_LOGIC_VECTOR(7 downto 0);
            NMEA_EN_ACK_IN  		: IN STD_LOGIC;

            NEW_TIMESTAMP_EN_OUT    : OUT STD_LOGIC;
            TIMESTAMP_DATA_OUT      : OUT STD_LOGIC_VECTOR(31 downto 0);

            ADDR_IN         		: IN  STD_LOGIC_VECTOR(7 downto 0);
            DATA_OUT        		: OUT  STD_LOGIC_VECTOR(7 downto 0));
    END COMPONENT;

    COMPONENT nmea_lcd_display_ctrl is
	generic (
    	SECONDS_BETWEEN_DISPLAY_SHIFT 	: positive;
    	CLK_IN_FREQUENCY_MHZ 		 	: positive);
    port (  
            CLK_IN          : IN  STD_LOGIC;
            RST_IN          : IN  STD_LOGIC;

            ADDR_OUT        : OUT  STD_LOGIC_VECTOR(7 downto 0);
            DATA_IN        	: IN STD_LOGIC_VECTOR(7 downto 0);

            LINE1_OUT 		: OUT STD_LOGIC_VECTOR(127 downto 0);
            LINE2_OUT 		: OUT STD_LOGIC_VECTOR(127 downto 0));
    END COMPONENT;

    COMPONENT u1588_master is
	Port ( 	CLK_IN 						: in std_logic;
			CLK_100MHZ_IN				: in std_logic;
			
			PPS_OUT						: out std_logic;
			PPS_IN						: in std_logic;

			IP_ADDR_IN					: in std_logic_vector(31 downto 0);
			MAC_IN						: in std_logic_vector(47 downto 0);
			SOURCE_PORT_ID_IN 			: in std_logic_vector(15 downto 0);
			GRANDMASTER_VARIANCE_IN 	: in std_logic_vector(15 downto 0);
			GRANDMASTER_PRIORITY1_IN 	: in std_logic_vector(7 downto 0);
			GRANDMASTER_PRIORITY2_IN 	: in std_logic_vector(7 downto 0);
			PPS_HOLDOVER_SECONDS_IN 	: in std_logic_vector(7 downto 0);

			NEW_TIMESTAMP_EN_IN    		: in std_logic;
        	TIMESTAMP_DATA_IN 			: in std_logic_vector(31 downto 0);

			ETH_CRS_IN					: in std_logic;
			ETH_RXD_CLK_IN				: in std_logic;
			ETH_RXD_IN					: in std_logic_vector(1 downto 0);

			ETH_TXD_CLK_IN				: in std_logic;
			ETH_TXD_EN_OUT				: out std_logic;
			ETH_TXD_OUT					: out std_logic_vector(1 downto 0);

			DEBUG_ADDR_IN 				: in std_logic_vector(7 downto 0);
			DEBUG_DATA_OUT 				: out std_logic_vector(7 downto 0));
    END COMPONENT;

subtype slv is std_logic_vector;

signal clk_100MHz, clk_1hz, clk_66Mhz : std_logic;

signal char_addr, font_addr	: std_logic_vector(11 downto 0);
signal char_data, font_data	: std_logic_vector(7 downto 0);
signal debug_i				: std_logic_vector(2 downto 0);
signal debug_o				: std_logic_vector(15 downto 0);
signal r, g, b 				: std_logic := '0';
signal octl					: std_logic_vector(7 downto 0);
signal ocrx, ocry 			: std_logic_vector(7 downto 0) := (others => '0');

signal frame_addr 				: std_logic_vector(23 downto 1) := (others => '0');
signal frame_data 				: std_logic_vector(15 downto 0) := (others => '0');
signal frame_rd, frame_rd_cmplt : std_logic := '0';

signal sseg_data 							: std_logic_vector(15 downto 0) := (others => '0');
signal debug_we 							: std_logic := '0';
signal debug_wr_addr 						: unsigned(11 downto 0) := (others => '0');
signal debug_wr_data 						: std_logic_vector(7 downto 0) := (others => '0');
signal buttons, buttons_prev, buttons_edge	: std_logic_vector(5 downto 0) := (others => '0');

signal data_bus, addr_bus 					: std_logic_vector(7 downto 0) := (others => '0');
signal eth_command 							: std_logic_vector(3 downto 0);
signal eth_command_err						: std_logic_vector(7 downto 0);
signal eth_command_en, eth_command_cmplt 	: std_logic;

signal sdi_buf, sdo_buf, sclk_buf, sclk_buf_n, sclk_oddr, cs_buf : std_logic;
signal led : std_logic_vector(1 downto 0);

signal line1_buffer, line2_buffer : std_logic_vector(127 downto 0) := X"63636363636363636363636363636363";

signal rx_ready, rx_ready_prev 	: std_logic;
signal rx_data 					: std_logic_vector(7 downto 0);
signal count 					: unsigned(4 downto 0) := (others => '0');

signal nmea_addr, nmea_data 	: std_logic_vector(7 downto 0);
signal tx_req, tx_ack 			: std_logic;
signal tx_data 					: std_logic_vector(7 downto 0);

signal tx_debug_req, tx_debug_ack, tx_debug_end : std_logic;
signal rx_debug_ready 							: std_logic;
signal rx_debug_addr 							: std_logic_vector(7 downto 0);
signal debug_addr 								: std_logic_vector(15 downto 0);
signal debug_data 								: std_logic_vector(7 downto 0);
signal idle_startup 							: unsigned(15 downto 0) := X"FFFF";

signal timestamp_en 							: std_logic := '0';
signal timestamp 								: std_logic_vector(31 downto 0) := (others => '0');

type DEBUG_ST is (	PRE_IDLE,
					IDLE,
					RD_PREADDR,
					PREADDR_IDLE0,
					PREADDR_IDLE1, 
					PREADDR_IDLE2, 
					RD_ADDR0,
					RD_ADDR1,
					RD_ADDR2,
					RD_ADDR3,
					RD_ADDR4,
					RD_ADDR5,
					RD_ADDR6,
					WR_DATA0);
						
signal debug_state, debug_next_state : DEBUG_ST := PRE_IDLE;

begin
	
	clk_mod_Inst : clk_mod
	PORT MAP ( 	CLK_100MHz_IN 	=> CLK_IN,
				CLK_66MHz_OUT	=> clk_66Mhz,
				CLK_100Mhz_OUT  => clk_100MHz);

--------------------------- UI I/O ------------------------------

	LED_OUT <= led(0);

	led_mod_inst : led_mod
    Port Map ( CLK_IN 				=> clk_66Mhz,
					LED_STATE_IN 		=> "001",
					ERROR_CODE_IN		=> (others => '0'),
					ERROR_CODE_EN_IN	=> '0',
					LEDS_OUT 			=> led,
					CLK_1HZ_OUT			=> clk_1hz);

	lcd16x2_ctrl_inst : lcd16x2_ctrl
	  generic map (
		 CLK_PERIOD_NS => 10)
	  port map (
		 clk          => clk_100MHz,
		 rst          => '0',
		 lcd_v        => VO_OUT,
		 lcd_e        => E_OUT,
		 lcd_rs       => RS_OUT,
		 lcd_rw       => RW_OUT,
		 lcd_db       => DB_OUT,
		 line1_buffer  => line1_buffer,
		 line2_buffer  => line2_buffer);
		 
		 
	RX_TEST_OUT <= RX_IN;
	PPS_TEST_OUT <= PPS_IN;

	GPS_UART_INST: UART
    GENERIC MAP (
        baud                => 9600,
        clock_frequency     => 100000000
    )
    PORT MAP (  
        clock               => clk_100MHz,
        reset               => '0',
        data_stream_in      => tx_data,
        data_stream_in_stb  => tx_req,
        data_stream_in_ack  => tx_ack,
        data_stream_out     => rx_data,
        data_stream_out_stb => rx_ready,
        tx                  => TX_OUT,
        rx                  => RX_IN);
	 
	nmea_parser_inst : nmea_parser
    port map (  
        CLK_IN         			=> clk_100MHz,
        RST_IN          		=> '0',
			
        NMEA_EN_IN      		=> rx_ready,
        NMEA_DATA_IN    		=> rx_data,

		NMEA_EN_OUT     		=> tx_req,
        NMEA_DATA_OUT   		=> tx_data,
        NMEA_EN_ACK_IN  		=> tx_ack,

        NEW_TIMESTAMP_EN_OUT    => timestamp_en,
        TIMESTAMP_DATA_OUT      => timestamp,

        ADDR_IN         		=> nmea_addr,
        DATA_OUT        		=> nmea_data);

    nmea_lcd_display_ctrl_inst : nmea_lcd_display_ctrl
	generic map (
    	SECONDS_BETWEEN_DISPLAY_SHIFT 	=> 4,
    	CLK_IN_FREQUENCY_MHZ 		 	=> 100)
    port map (  
            CLK_IN          => clk_100MHz,
            RST_IN          => '0',

            ADDR_OUT        => nmea_addr,
            DATA_IN        	=> nmea_data,

            LINE1_OUT 		=> line1_buffer,
            LINE2_OUT 		=> line2_buffer);

    u1588_master_Inst: u1588_master
	Port Map (
		CLK_IN 						=> clk_66Mhz,
		CLK_100MHZ_IN 				=> clk_100MHz,
		
		PPS_IN 						=> PPS_IN,
		PPS_OUT 					=> open,
		
		IP_ADDR_IN 					=> X"C0A801F9",
		MAC_IN	 					=> X"040CCD040000",
		SOURCE_PORT_ID_IN 			=> X"0001",
		GRANDMASTER_VARIANCE_IN 	=> X"7060",
		GRANDMASTER_PRIORITY1_IN 	=> X"80",
		GRANDMASTER_PRIORITY2_IN 	=> X"80",
		PPS_HOLDOVER_SECONDS_IN 	=> X"0F",

		NEW_TIMESTAMP_EN_IN    		=> timestamp_en,
        TIMESTAMP_DATA_IN      		=> timestamp,

		ETH_CRS_IN 					=> ETH_CRS_IN,
		ETH_RXD_CLK_IN 				=> ETH_CLK_IN,
		ETH_RXD_IN					=> ETH_RXD_IN,

		ETH_TXD_CLK_IN 				=> ETH_CLK_IN,
		ETH_TXD_EN_OUT 				=> ETH_TXD_EN_OUT,
		ETH_TXD_OUT 				=> ETH_TXD_OUT,

		DEBUG_ADDR_IN 				=> debug_addr(7 downto 0),
		DEBUG_DATA_OUT 				=> debug_data);

------------------------------- READING DATA WITH UART MODULE ------------------------------------

	DEBUG_UART_INST: UART
    GENERIC MAP (
        baud                => 115200,
        clock_frequency     => 100000000
    )
    PORT MAP (
        clock               => clk_100MHz,
        reset               => '0',
        data_stream_in      => debug_data(7 downto 0),
        data_stream_in_stb  => tx_debug_req,
        data_stream_in_ack  => tx_debug_end,
        data_stream_out     => rx_debug_addr,
        data_stream_out_stb => rx_debug_ready,
        tx                  => TX_DEBUG_OUT,
        rx                  => RX_DEBUG_IN);

	NEXT_ST_CLK :process(clk_100MHz)
	begin
		if rising_edge(clk_100MHz) then
			debug_state <= debug_next_state;
		end if;
	end process;

	NEXT_ST_DECODE :process (debug_state, idle_startup, rx_debug_ready, rx_debug_addr, tx_debug_end)
	begin
		debug_next_state <= debug_state;  -- default is to stay in current state
		case (debug_state) is
			when PRE_IDLE =>
				if idle_startup = X"0000" and rx_debug_ready = '0' then 
					debug_next_state <= IDLE;
				end if;
			when IDLE =>
				if rx_debug_ready = '1' then
					debug_next_state <= RD_PREADDR;
				end if;
			when RD_PREADDR =>
				if rx_debug_addr = X"55" then
					debug_next_state <= PREADDR_IDLE0;
				else
					debug_next_state <= PRE_IDLE;
				end if;
			when PREADDR_IDLE0 =>
				if rx_debug_ready = '0' then
					debug_next_state <= PREADDR_IDLE1;
				end if;
			when PREADDR_IDLE1 =>
				if rx_debug_ready = '1' then
					debug_next_state <= PREADDR_IDLE2;
				end if;
			when PREADDR_IDLE2 =>
				if rx_debug_addr = X"5D" then
					debug_next_state <= RD_ADDR0;
				else
					debug_next_state <= PREADDR_IDLE0;
				end if;
			when RD_ADDR0 =>
				if rx_debug_ready = '0' then
					debug_next_state <= RD_ADDR1;
				end if;
			when RD_ADDR1 =>
				if rx_debug_ready = '1' then
					debug_next_state <= RD_ADDR2;
				end if;
			when RD_ADDR2 =>
				if rx_debug_ready = '0' then
					debug_next_state <= RD_ADDR3;
				end if;
			when RD_ADDR3 =>
				if rx_debug_ready = '1' then
					debug_next_state <= RD_ADDR4;
				end if;
			when RD_ADDR4 =>
				if rx_debug_ready = '0' then
					debug_next_state <= RD_ADDR5;
				end if;
			when RD_ADDR5 =>
				if rx_debug_ready = '1' then
					debug_next_state <= RD_ADDR6;
				end if;
			when RD_ADDR6 =>
				if rx_debug_ready = '0' then
					debug_next_state <= WR_DATA0;
				end if;

			when WR_DATA0 =>
				if tx_debug_end = '1' then
					debug_next_state <= PRE_IDLE;
				end if;

		end case;
	end process;

	process(clk_100MHz)
	begin
		if rising_edge(clk_100MHz) then
			if idle_startup /= X"0000" then
				idle_startup <= idle_startup - 1;
			end if;
		end if;
	end process;

	tx_debug_req <= '1' when debug_state = WR_DATA0 else '0';

	process(clk_100MHz)
	begin
		if rising_edge(clk_100MHz) then
			if debug_state = RD_ADDR1 then
				if rx_debug_ready = '1' then
					debug_addr(15 downto 8) <= rx_debug_addr;
				end if;
			end if;
			if debug_state = RD_ADDR3 then
				if rx_debug_ready = '1' then
					debug_addr(7 downto 0) <= rx_debug_addr;
				end if;
			end if;
		end if;
	end process;

end Behavioral;