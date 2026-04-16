library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Used for mathematic operations


entity lap_memory is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           lap_save : in STD_LOGIC;
           lap_scroll : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (18 downto 0);
           data_out : out STD_LOGIC_VECTOR (18 downto 0));
end lap_memory;

architecture Behavioral of lap_memory is

    -- Memory array: 8 locations, each 19 bits wide
    type memory_array is array (0 to 7) of std_logic_vector(18 downto 0);
    -- Set all memory cells to 0
    signal lap_storage : memory_array := (others => (others => '0'));

    -- Pointers for writing and reading
    -- 0 to 7
    signal write_ptr : unsigned(2 downto 0) := "000";
    signal read_ptr  : unsigned(2 downto 0) := "000"; 

    -- Signals for button press detection (to react only once per press)
    signal save_last   : std_logic := '0';
    signal scroll_last : std_logic := '0';

begin

process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Reset pointers and memory
                write_ptr <= (others => '0');
                read_ptr  <= (others => '0');
                lap_storage <= (others => (others => '0'));
                save_last <= '0';
                scroll_last <= '0';
            else
                -- Save button action
                if lap_save = '1' and save_last = '0' then
                    --Inserting value from data_in to memory cell adresed by write pointer
                    lap_storage(to_integer(write_ptr)) <= data_in;
                    write_ptr <= write_ptr + 1; --Increasing write pointer. Automatically cycles 7 -> 0. 
                end if;
                
                save_last <= lap_save;

                -- Scroll button action
                if lap_scroll = '1' and scroll_last = '0' then
                    --Increasing read pointer when button is pressed
                    read_ptr <= read_ptr + 1; 
                end if;
                
                scroll_last <= lap_scroll;
                
            end if;
        end if;
    end process;

    -- Output the value currently selected by the read pointer
    data_out <= lap_storage(to_integer(read_ptr));


end Behavioral;
