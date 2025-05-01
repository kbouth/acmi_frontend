----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2025 12:22:24 PM
-- Design Name: 
-- Module Name: backend_comm_wrapper - Behavioral
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

entity backend_comm_wrapper is
generic (
  SIM_MODE             : integer := 0
);
port (
  clk                  : in std_logic;
  reset                : in std_logic;
  gtp_refclk_n         : in std_logic;
  gtp_refclk_p         : in std_logic;
  q0_clk0_refclk_out   : out std_logic;   
  gtp_tx_data          : in std_logic_vector(31 downto 0);
  gtp_tx_data_enb      : in std_logic;
  gtp_rx_clk           : out std_logic;
  gtp_rx_data          : out std_logic_vector(31 downto 0);
  RXN_IN               : in std_logic;
  RXP_IN               : in std_logic;
  TXN_OUT              : out std_logic;
  TXP_OUT              : out std_logic
);
end backend_comm_wrapper;

architecture Behavioral of backend_comm_wrapper is

begin

    gtp_trans: entity work.sfp_gtp
    port map(
        sys_clk => clk,
        reset => reset,
        gtp_refclk1_p => gtp_refclk_p,
        gtp_refclk1_n => gtp_refclk_n,
        q0_clk0_refclk_out => q0_clk0_refclk_out,
        gtp_tx_data => gtp_tx_data,
        gtp_tx_data_enb => gtp_tx_data_enb,
        gtp_rx_data => gtp_rx_data,
        rxusrclk2_out => gtp_rx_clk,
        rxn_in => RXN_IN,
        rxp_in => RXP_IN,
        txn_out => TXN_OUT,
        txp_out => TXP_OUT
    );

end Behavioral;
