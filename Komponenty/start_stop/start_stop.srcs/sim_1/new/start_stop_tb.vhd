
library ieee;
use ieee.std_logic_1164.all;

entity tb_start_stop is
end tb_start_stop;

architecture tb of tb_start_stop is

    component start_stop
        port (clk    : in std_logic;
              rst    : in std_logic;
              btn_in : in std_logic;
              ce     : in std_logic;
              en     : out std_logic);
    end component;

    signal clk    : std_logic;
    signal rst    : std_logic;
    signal btn_in : std_logic;
    signal ce     : std_logic;
    signal en     : std_logic;

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : start_stop
    port map (clk    => clk,
              rst    => rst,
              btn_in => btn_in,
              ce     => ce,
              en     => en);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        btn_in <= '0';
        ce <= '0';
        rst <= '1';
        wait for 50 ns;
        
        -- Release reset
        rst <= '0';
        wait for 50 ns;

        -- System should be OFF by default (running = '0')
        ce <= '1'; wait for 50 ns;
        ce <= '0'; wait for 50 ns;

        -- First button press (START)
        btn_in <= '1'; 
        wait for 50 ns; -- Hold button for 5 clock cycles
        btn_in <= '0';
        wait for 50 ns;
        
        ce <= '1'; wait for 50 ns;
        ce <= '0'; wait for 50 ns;
        ce <= '1'; wait for 50 ns;

        -- Second button press (STOP)
        btn_in <= '1';
        wait for 50 ns;
        btn_in <= '0';
        wait for 50 ns;

        ce <= '0'; wait for 50 ns;
        ce <= '1'; wait for 50 ns;

        -- Reset during operation
        btn_in <= '1'; wait for 50 ns; btn_in <= '0'; -- Start it again
        wait for 50 ns;
        ce <= '1';      -- Signal is passing
        wait for 50 ns;
        rst <= '1';     -- Hit reset
        wait for 50 ns;
        rst <= '0';

        -- End simulation
        wait for 100 * TbPeriod;
        TbSimEnded <= '1';
        wait;    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_start_stop of tb_start_stop is
    for tb
    end for;
end cfg_tb_start_stop;