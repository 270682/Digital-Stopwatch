-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Fri, 10 Apr 2026 16:07:23 GMT
-- Request id : cfwk-fed377c2-69d9203b9e1b9

library ieee;
use ieee.std_logic_1164.all;

entity tb_view_mode is
end tb_view_mode;

architecture tb of tb_view_mode is

    component view_mode
        port (clk       : in std_logic;
              rst       : in std_logic;
              time_data : in std_logic_vector (18 downto 0);
              lap_data  : in std_logic_vector (18 downto 0);
              mode      : in std_logic;
              data_out  : out std_logic_vector (18 downto 0));
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal time_data : std_logic_vector (18 downto 0);
    signal lap_data  : std_logic_vector (18 downto 0);
    signal mode      : std_logic;
    signal data_out  : std_logic_vector (18 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : view_mode
    port map (clk       => clk,
              rst       => rst,
              time_data => time_data,
              lap_data  => lap_data,
              mode      => mode,
              data_out  => data_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        time_data <= (others => '0');
        lap_data <= (others => '1');
        mode <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;

        -- First click 
        mode <= '1';
        wait for 50 ns;       
        mode <= '0';
        wait for 50 ns;         

        -- Second click
        mode <= '1';
        wait for 50 ns;
        mode <= '0';
        wait for 50 ns;    
       
       --Third click 
        mode <= '1';
        wait for 50 ns;
        mode <= '0';
        wait for 50 ns;        
    

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_view_mode of tb_view_mode is
    for tb
    end for;
end cfg_tb_view_mode;