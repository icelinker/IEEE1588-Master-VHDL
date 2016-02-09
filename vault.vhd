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
				LED_OUT 			: out STD_LOGIC;

				VO_OUT			: out STD_LOGIC;
				RS_OUT			: out STD_LOGIC;
				RW_OUT			: out STD_LOGIC;
				E_OUT				: out STD_LOGIC;
				DB_OUT			: out STD_LOGIC_VECTOR(7 downto 0);
				
				RX_IN 			: in STD_LOGIC;
				PPS_IN 			: in STD_LOGIC;
				RX_TEST_OUT 	: out STD_LOGIC;
				PPS_TEST_OUT 	: out STD_LOGIC);
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
            CLK_IN          : IN  STD_LOGIC;
            RST_IN          : IN  STD_LOGIC; 
            NMEA_EN_IN      : IN  STD_LOGIC;
            NMEA_DATA_IN    : IN  STD_LOGIC_VECTOR(7 downto 0);

            ADDR_IN         : IN  STD_LOGIC_VECTOR(7 downto 0);
            DATA_OUT        : OUT  STD_LOGIC_VECTOR(7 downto 0));
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
					
	VO_OUT <= '0';

	lcd16x2_ctrl_inst : lcd16x2_ctrl
	  generic map (
		 CLK_PERIOD_NS => 10)
	  port map (
		 clk          => clk_100MHz,
		 rst          => '0',
		 lcd_e        => E_OUT,
		 lcd_rs       => RS_OUT,
		 lcd_rw       => RW_OUT,
		 lcd_db       => DB_OUT,
		 line1_buffer  => line1_buffer,
		 line2_buffer  => line2_buffer);
		 
	RX_TEST_OUT <= RX_IN;
	PPS_TEST_OUT <= PPS_IN;

	UART_INST : UART
    GENERIC MAP (
        baud                => 9600,
        clock_frequency     => 100000000
    )
    PORT MAP (  
        clock               => clk_100MHz,
        reset               => '0',
        data_stream_in      => (others => '0'),
        data_stream_in_stb  => '0',
        data_stream_in_ack  => open,
        data_stream_out     => rx_data,
        data_stream_out_stb => rx_ready,
        tx                  => open,
        rx                  => RX_IN
    );

	RX_HANDLER :process(clk_100MHz)
	begin
		if rising_edge(clk_100MHz) then
			rx_ready_prev <= rx_ready;
			if rx_ready_prev = '1' and rx_ready = '0' then
				count <= count + 1;
				if count = '0'&X"0" then
					line1_buffer(127 downto 120) <= rx_data;
				elsif count = '0'&X"1" then
					line1_buffer(119 downto 112) <= rx_data;
				elsif count = '0'&X"2" then
					line1_buffer(111 downto 104) <= rx_data;
				elsif count = '0'&X"3" then
					line1_buffer(103 downto 96) <= rx_data;
				elsif count = '0'&X"4" then
					line1_buffer(95 downto 88) <= rx_data;
				elsif count = '0'&X"5" then
					line1_buffer(87 downto 80) <= rx_data;
				elsif count = '0'&X"6" then
					line1_buffer(79 downto 72) <= rx_data;
				elsif count = '0'&X"7" then
					line1_buffer(71 downto 64) <= rx_data;
				elsif count = '0'&X"8" then
					line1_buffer(63 downto 56) <= rx_data;
				elsif count = '0'&X"9" then
					line1_buffer(55 downto 48) <= rx_data;
				elsif count = '0'&X"A" then
					line1_buffer(47 downto 40) <= rx_data;
				elsif count = '0'&X"B" then
					line1_buffer(39 downto 32) <= rx_data;
				elsif count = '0'&X"C" then
					line1_buffer(31 downto 24) <= rx_data;
				elsif count = '0'&X"D" then
					line1_buffer(23 downto 16) <= rx_data;
				elsif count = '0'&X"E" then
					line1_buffer(15 downto 8) <= rx_data;
				elsif count = '0'&X"F" then
					line1_buffer(7 downto 0) <= rx_data;
				elsif count = '1'&X"0" then
					line2_buffer(127 downto 120) <= rx_data;
				elsif count = '1'&X"1" then
					line2_buffer(119 downto 112) <= rx_data;
				elsif count = '1'&X"2" then
					line2_buffer(111 downto 104) <= rx_data;
				elsif count = '1'&X"3" then
					line2_buffer(103 downto 96) <= rx_data;
				elsif count = '1'&X"4" then
					line2_buffer(95 downto 88) <= rx_data;
				elsif count = '1'&X"5" then
					line2_buffer(87 downto 80) <= rx_data;
				elsif count = '1'&X"6" then
					line2_buffer(79 downto 72) <= rx_data;
				elsif count = '1'&X"7" then
					line2_buffer(71 downto 64) <= rx_data;
				elsif count = '1'&X"8" then
					line2_buffer(63 downto 56) <= rx_data;
				elsif count = '1'&X"9" then
					line2_buffer(55 downto 48) <= rx_data;
				elsif count = '1'&X"A" then
					line2_buffer(47 downto 40) <= rx_data;
				elsif count = '1'&X"B" then
					line2_buffer(39 downto 32) <= rx_data;
				elsif count = '1'&X"C" then
					line2_buffer(31 downto 24) <= rx_data;
				elsif count = '1'&X"D" then
					line2_buffer(23 downto 16) <= rx_data;
				elsif count = '1'&X"E" then
					line2_buffer(15 downto 8) <= rx_data;
				elsif count = '1'&X"F" then
					line2_buffer(7 downto 0) <= rx_data;
				end if;	
			end if;
		end if;
	end process;


end Behavioral;