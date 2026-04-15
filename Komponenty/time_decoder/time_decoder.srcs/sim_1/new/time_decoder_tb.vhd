-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net

library ieee;
use ieee.std_logic_1164.all;

entity tb_time_decoder is
end tb_time_decoder;

architecture tb of tb_time_decoder is

    component time_decoder
        port (data_in  : in std_logic_vector (18 downto 0);
              data_out : out std_logic_vector (23 downto 0));
    end component;

    signal data_in  : std_logic_vector (18 downto 0);
    signal data_out : std_logic_vector (23 downto 0);

begin

    dut : time_decoder
    port map (data_in  => data_in,
              data_out => data_out);

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        data_in <= (others => '0');

        -- ***EDIT*** Add stimuli here
        -- Case 1: Zero time
        data_in <= (others => '0');
        wait for 100 ns; 

        -- Case 2: Exactly 1 minute, 1 second and 1 cent
        -- Number of cents = 1*6000+1*100+1 = 6101
        data_in <= "0000001011111010101";
        wait for 100 ns; 

        -- Case 3: 59 minute, 59 seconds and 99 cents
        -- Number of cents = 59*6000+59*100+99 = 359 999
        data_in <= "1010111111000111111";
        wait for 100 ns; -- Expected data_out: 0x011050 (01:10:50)
        wait;
        
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_time_decoder of tb_time_decoder is
    for tb
    end for;
end cfg_tb_time_decoder;