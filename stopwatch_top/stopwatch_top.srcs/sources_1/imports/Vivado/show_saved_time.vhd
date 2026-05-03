library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity show_saved_time is
    Port ( clk : in STD_LOGIC;
           data_in_cntr : in STD_LOGIC_VECTOR (18 downto 0);
           save_btn : in STD_LOGIC;
           data_in_view_mode : in STD_LOGIC_VECTOR (18 downto 0);
           output : out STD_LOGIC_VECTOR (18 downto 0)
           );
end show_saved_time;

architecture Behavioral of show_saved_time is
    signal count       : integer := 0;
    signal is_switched : boolean := false;
    signal save_btn_prev : std_logic := '0';
    signal displayed_data : std_logic_vector (18 downto 0);
    constant DURATION  : integer := 20;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            save_btn_prev <= save_btn; -- Keep track of previous state to detect change
            
            -- Detect if the switch has been toggled (Edge Detection)
            if save_btn = '1' and save_btn_prev = '0' then
                is_switched <= true;
                count <= 0;
                displayed_data <= data_in_cntr;
            end if;

            if is_switched then
                output <= displayed_data; -- Mirror the "temporary" port
                if count < DURATION then
                    count <= count + 1;
                else
                    is_switched <= false; -- Time is up!
                end if;
            else
                output <= data_in_view_mode; -- Mirror the "default" port
            end if;
        end if;
    end process;
end Behavioral;
