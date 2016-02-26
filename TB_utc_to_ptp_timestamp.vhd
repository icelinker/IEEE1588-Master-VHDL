--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:56:39 02/22/2016
-- Design Name:   
-- Module Name:   /home/craig/Documents/Projects/Repos/OT_1588_Master/OT_1588_Master/TB_utc_to_ptp_timestamp.vhd
-- Project Name:  vault_numato
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: utc_to_ptp_timestamp
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_utc_to_ptp_timestamp IS
END TB_utc_to_ptp_timestamp;
 
ARCHITECTURE behavior OF TB_utc_to_ptp_timestamp IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT utc_to_ptp_timestamp
    PORT(
         CLK_IN : IN  std_logic;
         RST_IN : IN  std_logic;
         DO_CONV_IN : IN  std_logic;
         CONV_DONE_OUT : OUT  std_logic;
         BCD_UTC_YEAR_IN : IN  std_logic_vector(15 downto 0);
         BCD_UTC_MONTH_IN : IN  std_logic_vector(7 downto 0);
         BCD_UTC_DAY_IN : IN  std_logic_vector(7 downto 0);
         BCD_UTC_HOUR_IN : IN  std_logic_vector(7 downto 0);
			BCD_UTC_MIN_IN : IN  STD_LOGIC_VECTOR(7 downto 0);
         BCD_UTC_SEC_IN : IN  std_logic_vector(7 downto 0);
			UTC_TIMEZONE_HOUR_OFFSET_IN     : IN  STD_LOGIC_VECTOR(7 downto 0);
         UTC_LEAP_SEC_IN : IN  std_logic_vector(7 downto 0);
         TIMESTAMP_OUT : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_IN : std_logic := '0';
   signal RST_IN : std_logic := '0';
   signal DO_CONV_IN : std_logic := '0';
   signal BCD_UTC_YEAR_IN : std_logic_vector(15 downto 0) := X"2016";
   signal BCD_UTC_MONTH_IN : std_logic_vector(7 downto 0) := X"02";
   signal BCD_UTC_DAY_IN : std_logic_vector(7 downto 0) := X"22";
   signal BCD_UTC_HOUR_IN : std_logic_vector(7 downto 0) := X"04";
	signal BCD_UTC_MIN_IN : STD_LOGIC_VECTOR(7 downto 0) := X"10";
   signal BCD_UTC_SEC_IN : std_logic_vector(7 downto 0) := X"44";
   signal UTC_LEAP_SEC_IN : std_logic_vector(7 downto 0) := (others => '0');
	signal UTC_TIMEZONE_HOUR_OFFSET_IN : STD_LOGIC_VECTOR(7 downto 0):= (others => '0');

 	--Outputs
   signal CONV_DONE_OUT : std_logic;
   signal TIMESTAMP_OUT : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_IN_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: utc_to_ptp_timestamp PORT MAP (
          CLK_IN => CLK_IN,
          RST_IN => RST_IN,
          DO_CONV_IN => DO_CONV_IN,
          CONV_DONE_OUT => CONV_DONE_OUT,
          BCD_UTC_YEAR_IN => BCD_UTC_YEAR_IN,
          BCD_UTC_MONTH_IN => BCD_UTC_MONTH_IN,
          BCD_UTC_DAY_IN => BCD_UTC_DAY_IN,
          BCD_UTC_HOUR_IN => BCD_UTC_HOUR_IN,
			 BCD_UTC_MIN_IN => BCD_UTC_MIN_IN,
          BCD_UTC_SEC_IN => BCD_UTC_SEC_IN,
          UTC_LEAP_SEC_IN => UTC_LEAP_SEC_IN,
			 UTC_TIMEZONE_HOUR_OFFSET_IN => UTC_TIMEZONE_HOUR_OFFSET_IN,
          TIMESTAMP_OUT => TIMESTAMP_OUT
        );

   -- Clock process definitions
   CLK_IN_process :process
   begin
		CLK_IN <= '0';
		wait for CLK_IN_period/2;
		CLK_IN <= '1';
		wait for CLK_IN_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_IN_period*10;
		DO_CONV_IN <= '1';
		wait for CLK_IN_period;
		DO_CONV_IN <= '0';
		wait for CLK_IN_period;

      -- insert stimulus here 

      wait;
   end process;

END;
