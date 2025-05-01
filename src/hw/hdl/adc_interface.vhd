----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2025 10:25:32 AM
-- Design Name: 
-- Module Name: adc_interface - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity adc_interface is
generic (
    SIM_MODE            : integer := 0
  );
  Port (
      reset : in std_logic;
      trig  : in std_logic;
      sclk  : out std_logic;
      din   : out std_logic;
      dout  : in std_logic; 
      sync  : out std_logic; 
      adc_clk_p : in std_logic; 
      adc_clk_n : in std_logic; 
      adc_data_p: in std_logic_vector(7 downto 0); 
      adc_data_n: in std_logic_vector(7 downto 0); 
      adc_of_p  : in std_logic; 
      adc_of_n  : in std_logic; 
      adc_data_2s: out std_logic_vector(15 downto 0); 
      adc_data_ob: out std_logic_vector(15 downto 0); 
      adc_clk    : out std_logic; 
      adc_sat    : out std_logic
      
  );
end adc_interface;

architecture Behavioral of adc_interface is
    
    signal adc_data : std_logic_vector(7 downto 0); 
    signal adc_of_sync: std_logic; 
    signal adc_data_gtp: std_logic_vector(15 downto 0); 
    
begin
    
    
    adc_sat <= adc_of_sync; 
    
    adc_overflow: IBUFDS
        port map(
            O => adc_of_sync,
            I => adc_of_p,
            IB => adc_of_n        
        ); 
    
    adc_data_sig: for i in 0 to 7 generate
        adc_gen: IBUFDS
            port map(
                O => adc_data(i),
                I => adc_data_p(i),
                IB => adc_data_n(i)
            );
    end generate; 
    
    adc_clk_200: IBUFDS 
        port map(
            O => adc_clk,
            I => adc_clk_p,
            IB => adc_clk_n
        );
       
    adc_readout: entity work.adc_readout_test
    port map(
    reset => reset,
    sys_clk => adc_clk,
    adc_d1d0 => adc_data(0),
    adc_d3d2 => adc_data(1),
    adc_d5d4 => adc_data(2),
    adc_d7d6 => adc_data(3),
    adc_d9d8 => adc_data(4),
    adc_d11d10 => adc_data(5),
    adc_d13d12 => adc_data(6),
    adc_d15d14 => adc_data(7),
    adc_sdo => dout,
    adc_sdi => din,
    adc_sclk => sclk,
    adc_csb => sync,
    data_in => x"0301",
    adc_data_out => adc_data_ob,
    adc_data_2s => adc_data_2s
    );


end Behavioral;
