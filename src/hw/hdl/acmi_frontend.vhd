----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2025 03:55:33 PM
-- Design Name: 
-- Module Name: acmi_frontend - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity acmi_frontend is
  Port (
      sys_clk      : in std_logic; 
      reset        : in std_logic; 
      adc_rxdata   : out std_logic_vector(15 downto 0); 
      gtp_refclk_p : in std_logic; 
      gtp_refclk_n : in std_logic; 
      rxp_in       : in std_logic;
      rxn_in       : in std_logic; 
      txp_out       : out std_logic; 
      txn_out      : out std_logic );
end acmi_frontend;

architecture Behavioral of acmi_frontend is

begin

    adc_transceiver: entity work.adc_gtp_link
        port map(
            sys_clk => sys_clk,
            reset => reset,
            gtp_refclk1_p => gtp_refclk_p,
            gtp_refclk1_n => gtp_refclk_n,
            rxn_in => rxn_in,
            rxp_in => rxp_in,
            txp_out => txp_out,
            txn_out => txn_out      
        );

end Behavioral;
