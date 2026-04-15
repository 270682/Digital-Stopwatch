
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity view_mode is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           time_data : in STD_LOGIC_VECTOR (18 downto 0);
           lap_data : in STD_LOGIC_VECTOR (18 downto 0);
           mode : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (18 downto 0));
end view_mode;

architecture Behavioral of view_mode is

    -- Internal state signal (0 = display current time, 1 = display lap time)
    signal selector : STD_LOGIC := '0';
    
    -- Register to store the previous state of the mode input
    signal mode_prev : STD_LOGIC := '0';
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                selector  <= '0';
                mode_prev <= '0';
            else
                -- Checks if the button is press now but was not in last cycle
                if mode = '1' and mode_prev = '0' then
                    selector <= not selector;   -- State switch
                end if;

                -- Update the history register for next clock cycle
                mode_prev <= mode;
            end if;
        end if;
        
    end process;

    -- Multiplexer controlled by selector signal
    data_out <= time_data when (selector = '0') else lap_data;

end Behavioral;
