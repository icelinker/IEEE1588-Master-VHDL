--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:18:03 05/19/2015
-- Design Name:   
-- Module Name:   /home/craig/Documents/Projects/Git_Repos/private/FPGA_X4/TB_u1588_master.vhd
-- Project Name:  ReducedNIMI_XC6S75
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: u1588_slave
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

library std;
use std.textio.all;
 
ENTITY TB_u1588_master IS
END TB_u1588_master;
 
ARCHITECTURE behavior OF TB_u1588_master IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT u1588_master
    PORT(
         CLK_IN : IN  std_logic;
			CLK_100MHZ_IN	: in STD_LOGIC;
			
			CE_IN			: in STD_LOGIC;
			WE_IN				: in STD_LOGIC;
			ADDR_IN 			: in  STD_LOGIC_VECTOR (7 downto 0);
			DATA_IN 		: in  STD_LOGIC_VECTOR (7 downto 0);
			DATA_OUT 		: out STD_LOGIC_VECTOR (7 downto 0);
			
         ETH_CRS_IN : IN  std_logic;
         ETH_RXD_CLK_IN : IN  std_logic;
         ETH_RXD_ER_IN : IN  std_logic;
         ETH_RXD_DV_IN : IN  std_logic;
         ETH_RXD_IN : IN  std_logic_vector(3 downto 0);
			
			ETH_TXD_CLK_IN	: in std_logic;
			ETH_TXD_EN_OUT	: out std_logic;
			ETH_TXD_OUT		: out std_logic_vector(3 downto 0));
    END COMPONENT;
    

   --Inputs
   signal CLK_IN : std_logic := '0';
	signal CLK_IN_100mhz : std_logic := '0';
   signal ETH_CRS_IN : std_logic := '0';
   signal ETH_RXD_CLK_IN : std_logic := '0';
   signal ETH_RXD_ER_IN : std_logic := '0';
   signal ETH_RXD_DV_IN : std_logic := '0';
   signal ETH_RXD_IN : std_logic_vector(3 downto 0) := (others => '0');
	
	signal ETH_TXD_CLK_IN	: std_logic;
	signal ETH_TXD_EN_OUT	: std_logic;
	signal ETH_TXD_OUT		: std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant CLK_IN_period_115m2 : time := 17.361 ns;
   constant CLK_IN_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: u1588_master PORT MAP (
          CLK_IN => CLK_IN,
			 CLK_100MHZ_IN => CLK_IN_100mhz,
			 CE_IN => '0',
			 WE_IN  => '0',
			 ADDR_IN => X"00",
			 DATA_IN => X"00",
			 DATA_OUT => open,
          ETH_CRS_IN => ETH_CRS_IN,
          ETH_RXD_CLK_IN => ETH_RXD_CLK_IN,
          ETH_RXD_ER_IN => ETH_RXD_ER_IN,
          ETH_RXD_DV_IN => ETH_RXD_DV_IN,
          ETH_RXD_IN => ETH_RXD_IN,
			 
			 ETH_TXD_CLK_IN 	=> ETH_TXD_CLK_IN,
			 ETH_TXD_EN_OUT 	=> ETH_TXD_EN_OUT,
			 ETH_TXD_OUT 		=> ETH_TXD_OUT);

   -- Clock process definitions
   CLK_IN_process :process
   begin
		CLK_IN <= '0';
		wait for CLK_IN_period_115m2/2;
		CLK_IN <= '1';
		wait for CLK_IN_period_115m2/2;
   end process;
	
	CLK_IN_process2 :process
   begin
		ETH_RXD_CLK_IN <= '0';
		ETH_TXD_CLK_IN <= '1';
		wait for CLK_IN_period/2;
		ETH_RXD_CLK_IN <= '1';
		ETH_TXD_CLK_IN <= '0';
		wait for CLK_IN_period/2;
   end process;
	
	CLK_IN_process3 :process
   begin
		CLK_IN_100mhz <= '0';
		wait for 5 ns;
		CLK_IN_100mhz <= '1';
		wait for 5 ns;
   end process;
 
 	CLK_IN_process4 :process
 	FILE TX_FILE : text open WRITE_MODE is "tx_packets_master.output";
 	variable TX_LINE : line;
   begin
		if ETH_TXD_EN_OUT = '1' then
			write(TX_LINE, to_integer(unsigned(ETH_TXD_OUT)));
			writeline(TX_FILE, TX_LINE);
		end if;
		wait for CLK_IN_period;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
	
		wait for CLK_IN_period*8000;
	
      	wait for CLK_IN_period*10;

      	ETH_RXD_DV_IN <= '1';
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"D";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"e";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"4";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"9";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"e";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"d";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"7";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"6";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"4";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"4";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"4";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"7";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"a";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"6";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"4";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"e";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"e";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"9";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"a";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"a";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"6";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"6";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"e";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"f";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"3";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"f";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"3";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"4";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"3";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"9";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"9";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"6";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"4";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"2";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"c";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"2";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"2";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"4";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"9";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"e";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"d";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"f";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"f";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"e";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"f";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"7";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"6";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"4";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"6";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"f";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"7";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"4";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"1";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"f";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"0";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"b";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"3";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"9";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"c";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"e";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";
		wait for CLK_IN_period;

		ETH_RXD_IN <= X"1";		-- Checksum
		wait for CLK_IN_period; 
		ETH_RXD_IN <= X"2"; 	-- Checksum
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"3";		-- Checksum
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"4";		-- Checksum
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"5";		-- Checksum
		wait for CLK_IN_period; 
		ETH_RXD_IN <= X"6"; 	-- Checksum
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"7";		-- Checksum
		wait for CLK_IN_period;
		ETH_RXD_IN <= X"8";		-- Checksum
		wait for CLK_IN_period;

		ETH_RXD_DV_IN <= '0';

    wait;
   end process;

END;
