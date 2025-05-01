----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2025 11:19:46 AM
-- Design Name: 
-- Module Name: adc_readout_test - Behavioral
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity adc_readout_test is
  Port ( 
        reset       : in std_logic; 
        sys_clk     : in std_logic;
        adc_d1d0    : in std_logic;
        adc_d3d2    : in std_logic;
        adc_d5d4    : in std_logic;
        adc_d7d6    : in std_logic;
        adc_d9d8    : in std_logic;
        adc_d11d10  : in std_logic;
        adc_d13d12  : in std_logic;
        adc_d15d14  : in std_logic;
        adc_sdo     : in std_logic;
        adc_sdi     : out std_logic;
        adc_sclk    : out std_logic; 
        adc_csb     : out std_logic;
        data_in     : in std_logic_vector(15 downto 0);
        adc_data_out : out std_logic_vector(15 downto 0);
        adc_data_2s  :out std_logic_vector(15 downto 0)
  );
end adc_readout_test;

architecture Behavioral of adc_readout_test is
    signal rd_data_internal : std_logic_vector(15 downto 0):= (others => '0');
    signal rd_data_internal_1 : std_logic_vector(15 downto 0):= (others => '0');
    signal rd_data_internal_2 : std_logic_vector(15 downto 0):= (others => '0');
    signal data_out_temp        : std_logic_vector(15 downto 0):= (others => '0'); 
    
    signal rd_wr   : std_logic:= '0'; 
    signal data_in_copy : std_logic_vector(15 downto 0); 
    signal adc_sdo_internal : std_logic_vector(7 downto 0):= (others => '0'); 
    signal rd_data_integer :integer := 0; 
    
    constant SPI_CLK_DIV : integer := 25; -- Clock divider for 4 MHz SPI clock from 200 MHz sys clk -- 50% duty cycle

    signal clk_div_count : integer := 0;
    signal spi_clk_int   : std_logic := '0';

    type spi_state is (IDLE, WRITE, READ, DELAY, DONE);
    
    signal present_state      : spi_state := IDLE;
    signal next_state      : spi_state := IDLE;
    signal delay_cnt      : integer := 2; 
    

    signal bit_count      : integer := 15;
    signal shift_register : std_logic_vector(15 downto 0) := (others => '0');
    signal cs_n_int       : std_logic := '1';
    signal sdi_int       : std_logic := '0';
    signal sdo_buffer_temp   : std_logic_vector(15 downto 0) := (others => '0');
    signal sdo_buffer   : std_logic_vector(15 downto 0) := (others => '0');
    
    signal clk_enable     : std_logic := '0';
    signal clk_count      : integer := 0;
    signal rd_data_2s_temp: std_logic_vector(15 downto 0); 
    signal csb_internal   : std_logic:= '1'; 
    signal adc_sclk_int   : std_logic_vector(4 downto 0):= (others => '0'); 
    signal adc_pipeline_cnt : integer := 7; 
    signal clk_count_temp  : integer := 0; 
    signal latency_flag    : std_logic:= '0'; 
    
    
  type   state_type is (IDLE, CLKP1, CLKP2, SETSYNC); 
  signal state            : state_type  := idle; 
begin
    
    --odd elements are read on the positive edge of the clk
    readout_odd: process(sys_clk,reset) begin 
        if(reset = '1') then 
            rd_data_internal(1) <= '0';
            rd_data_internal(3) <= '0';
            rd_data_internal(5) <= '0';
            rd_data_internal(7) <= '0';
            rd_data_internal(9) <= '0';
            rd_data_internal(11) <= '0';
            rd_data_internal(13) <= '0';
            rd_data_internal(15) <= '0';
        elsif(rising_edge(sys_clk)) then 
            rd_data_internal(1) <= adc_d1d0; 
            rd_data_internal(3) <= adc_d3d2;
            rd_data_internal(5) <= adc_d5d4; 
            rd_data_internal(7) <= adc_d7d6; 
            rd_data_internal(9) <= adc_d9d8; 
            rd_data_internal(11) <= adc_d11d10; 
            rd_data_internal(13) <= adc_d13d12; 
            rd_data_internal(15) <= adc_d15d14;   
        end if; 
    end process; 
    
    --even elements are read on the negative edge of the clk
    readout_even: process(sys_clk,reset) begin
        if(reset = '1') then 
            rd_data_internal(0) <= '0';
            rd_data_internal(2) <= '0';
            rd_data_internal(4) <= '0';
            rd_data_internal(6) <= '0';
            rd_data_internal(8) <= '0';
            rd_data_internal(10) <= '0';
            rd_data_internal(12) <= '0';
            rd_data_internal(14) <= '0'; 
        elsif(falling_edge(sys_clk)) then 
            rd_data_internal(0) <= adc_d1d0; 
            rd_data_internal(2) <= adc_d3d2;
            rd_data_internal(4) <= adc_d5d4; 
            rd_data_internal(6) <= adc_d7d6; 
            rd_data_internal(8) <= adc_d9d8; 
            rd_data_internal(10) <= adc_d11d10; 
            rd_data_internal(12) <= adc_d13d12; 
            rd_data_internal(14) <= adc_d15d14;  
          
        end if; 
    end process; 
    
    -- reads the adc output
    rd_output: process(sys_clk,reset) begin 
        if (reset = '1') then 
            latency_flag <= '0'; 
            adc_pipeline_cnt <= 7; 
            adc_data_out <= (others => '0'); 
            adc_data_2s <= (others => '0'); 
        elsif(falling_edge(sys_clk)) then --reads on the falling edge of sys clk  
            if(latency_flag = '0') then -- discards the first 8 readings to sync up the adc data
                if(adc_pipeline_cnt = 0) then 
                  latency_flag <= '1'; --once it reached the 8th reading, set latency flag to 1
                  adc_data_out <= rd_data_internal;  
                  adc_data_2s <= x"8000" xor rd_data_internal;
                else 
                  adc_pipeline_cnt <= adc_pipeline_cnt - 1;
                end if;
            else    --after the first 7 readings, read the adc data normally
                   adc_data_out <= rd_data_internal; --offset binary adc output
                   adc_data_2s <= x"8000" xor rd_data_internal; --2's complement adc output
            end if; 
        end if; 
    end process; 
    
    
--    -- Generates 4 MHz SPI clock
    process(sys_clk, reset)
    begin
        if reset = '1' then
            clk_div_count <= 0;
        else
            if rising_edge(sys_clk) then
                if clk_count = SPI_CLK_DIV - 1 then
                    clk_count_temp <= 0; 
                    clk_enable <= not(clk_enable);
                else
                    clk_count_temp <= clk_count_temp + 1;
                end if;
                clk_count <= clk_count_temp;
            end if; 
        end if;
    end process;
    


    spi_clk: process(sys_clk, reset, present_state) begin -- produces the sclk output going to the ltc2107 spi
        if reset = '1' then 
            adc_sclk <= '0'; 
        else 
            if(rising_edge(sys_clk)) then
                if(csb_internal = '1' or present_state = DONE or present_state = DELAY) then  --stops sending clk pulses when it reaches these conditions
                    adc_sclk <= '0'; 
                else
                    adc_sclk <= clk_enable; 
                end if; 
            end if; 
        end if; 
    end process;  
    
    state_logic: process(clk_enable,reset) begin --updates the present state
       if(reset = '1') then 
            present_state <= IDLE; 
       else
            if(rising_edge(clk_enable)) then 
                present_state <= next_state; 
            end if; 
       end if; 
    end process; 
    
    -- SPI state machine
    fsm: process(clk_enable, reset)
    begin
        if falling_edge(clk_enable) then
            case present_state is
                when IDLE =>
                        adc_sdi <= '0';
                    if(reset = '0') then 
                       shift_register <= data_in;
                       bit_count <= 16;
                       next_state <= DELAY; 
                    else
                            next_state <= IDLE;
                    end if; 
                    
                when DELAY =>
                
                        if delay_cnt = 0 then 
                            delay_cnt <= 2; 
                            if data_in(15) = '0' then 
                            adc_sdi <= shift_register(15); 
                               next_state <= WRITE; 
                            else 
                            adc_sdi <= shift_register(15); 
                                next_state <= READ; 
                            end if;                           
                        else 
                        
                            delay_cnt <= delay_cnt -1;   
                        end if; 

                when WRITE =>
                
                        adc_sdi <= shift_register(bit_count -1);
                        
                        if bit_count = 0 then
                        
                            next_state <= DONE;
                        else
                            bit_count <= bit_count - 1;
                            next_state <= WRITE; 
                        end if;
                   
                when READ =>
                
                        adc_sdi <= shift_register(bit_count-1);
                        
                        
                        if(bit_count -1 <= 7) then 
                                sdo_buffer_temp(bit_count + 7) <= adc_sdo; -- Store read bits in higher byte
                        end if;
                            
                        if bit_count = 0 then
                            next_state <= DONE;
                        else
                            bit_count <= bit_count - 1;
                            next_state <= READ;
                        end if;
                 when DONE =>
                       adc_sdi <= '0'; 
                       sdo_buffer <= sdo_buffer_temp; 
                       if delay_cnt = 0 then 
                            delay_cnt <= 1; 
                            next_state <= IDLE;                           
                        else 
                            delay_cnt <= delay_cnt -1;   
                        end if;   
                         

                when others =>
                    next_state <= IDLE;
            end case;
        end if;
    end process;
   


-------------------------------------------------------------------------------------------------------
    
       --generates the adc_csb signal based on the present state
       csb: process(reset, present_state) begin 
        if(reset = '1') then 
            csb_internal <= '1'; 
        else
                case present_state is
                 when IDLE => csb_internal <= '1'; 
                 when DELAY => csb_internal <= '0';
                 when WRITE => csb_internal <= '0'; 
                 when READ => csb_internal <= '0'; 
                 when DONE => csb_internal <= '1';  
                 when others => csb_internal <= '1'; 
                end case;
        end if; 
    end process; 
    
    adc_csb <= csb_internal; 

    
    

end Behavioral;
