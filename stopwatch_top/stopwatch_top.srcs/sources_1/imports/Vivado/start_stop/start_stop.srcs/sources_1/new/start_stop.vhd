
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity start_stop is
    Port ( clk : in STD_LOGIC;
           rst    : in  STD_LOGIC;
           btn_in : in STD_LOGIC;
           ce : in STD_LOGIC;
           en : out STD_LOGIC);
end start_stop;

architecture Behavioral of start_stop is
    signal running      : STD_LOGIC := '0'; -- In default state output en is disabled
    signal btn_prev     : STD_LOGIC := '0'; --Register to store the previous button state for edge detection
begin
    process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                -- Reset to default state
                running <= '0';
                btn_prev <= '0';
            else
            -- Checks if the button is pressed now ('1') but was not in the last cycle ('0').
                if btn_in = '1' and btn_prev = '0' then
                    running <= not running; --  Toggle state switch
                end if;
            
                -- Update the history register for the next clock cycle
                btn_prev <= btn_in;
            end if;
          end if;
        end process;

       -- When running is '1', the output 'en' follows the input 'ce'.
       -- When running is '0', the output 'en' is forced to '0'.
        en <= ce when running = '1' else '0';

end Behavioral;
