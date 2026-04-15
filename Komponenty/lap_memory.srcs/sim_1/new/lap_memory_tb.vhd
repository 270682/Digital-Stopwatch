-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net

library ieee;
use ieee.std_logic_1164.all;

entity tb_lap_memory is
end tb_lap_memory;

architecture tb of tb_lap_memory is

    component lap_memory
        port (clk        : in std_logic;
              rst        : in std_logic;
              lap_save   : in std_logic;
              lap_scroll : in std_logic;
              data_in    : in std_logic_vector (18 downto 0);
              data_out   : out std_logic_vector (18 downto 0));
    end component;

    signal clk        : std_logic;
    signal rst        : std_logic;
    signal lap_save   : std_logic;
    signal lap_scroll : std_logic;
    signal data_in    : std_logic_vector (18 downto 0);
    signal data_out   : std_logic_vector (18 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : lap_memory
    port map (clk        => clk,
              rst        => rst,
              lap_save   => lap_save,
              lap_scroll => lap_scroll,
              data_in    => data_in,
              data_out   => data_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        lap_save <= '0';
        lap_scroll <= '0';
        data_in <= (others => '0');

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        -- ***EDIT*** Add stimuli here
        -- Lap 1
        data_in <= "0101010101010101010";
        wait for 20 ns;
        lap_save <= '1';
        wait for 20 ns;
        lap_save <= '0'; --Press and release
        wait for 50 ns;

        -- Lap 2
        data_in <= "1111111111111111111";
        wait for 20 ns;
        lap_save <= '1';
        wait for 20 ns; 
        lap_save <= '0'; 
        wait for 50 ns;
        
        --Output should switch from "0101010101010101010" to "1111111111111111111" 
        lap_scroll <= '1';        
        wait for 20 ns; 
        lap_scroll <= '0'; 
        wait for 50 ns;
        
        --Output should switch from "1111111111111111111" to "0000000000000000000" (initial value)
        lap_scroll <= '1';        
        wait for 20 ns; 
        lap_scroll <= '0'; 
        wait for 50 ns;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_lap_memory of tb_lap_memory is
    for tb
    end for;
end cfg_tb_lap_memory;