
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lap_memory is
    Generic (
        DATA_WIDTH : integer := 19;
        NUMBER_OF_LAPS : integer := 8
        );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           lap_save : in STD_LOGIC;
           lap_scroll : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
           );
end lap_memory;

architecture Behavioral of lap_memory is

-----DEFINOVANI POLE (ARRAY) PRO UKLADANI JEDNOTLIVYCH CASU-----
type lap_times_array is array (0 to NUMBER_OF_LAPS-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
-----VYCHOZI HODNOTY PRO ARRAY (JSOU NULA), PAMETOVE POLE SE BUDE VOLAT SIGNALEM WRITE-----
signal write : lap_times_array := (others => (others => '0'));


-----DEFINOVANI POINTERU (UKAZATELU), TYTO POINTERY URCUJI, KAM SE ZAPISE POSLEDNI CAS (WRITE POINTER),
-----A KTERY CAS PUJDE NA VYSTUP (READ POINTER)-----
signal write_ptr : integer range 0 to NUMBER_OF_LAPS - 1 := 0;
signal read_ptr  : integer range 0 to NUMBER_OF_LAPS - 1 := 0;


-----SIGNALY, KTERE ZAJISTUJI POUZE JEDNO OPAKOVANI ZAPISU/CTENI PRI JEDNOM STISKNUTI TLACITKA-----
signal lap_save_last      : std_logic := '0';
signal lap_scroll_last    : std_logic := '0';


begin

    process(clk)
    begin
        if rising_edge(clk) then
            -----RESETOVACI TLACITKO-----
            if rst = '1' then
                write_ptr <= 0;
                read_ptr  <= 0;
                write <= (others => (others => '0'));
                lap_save_last <= '0';
                lap_scroll_last <= '0';
            else
                lap_save_last <= lap_save;
                lap_scroll_last <= lap_scroll;

                if lap_save = '1' and lap_save_last = '0' then
                    write(write_ptr) <= data_in;
                    
                    if write_ptr = NUMBER_OF_LAPS - 1 then
                        write_ptr <= 0;
                    else
                        write_ptr <= write_ptr + 1;
                    end if;
                end if;
                
                if lap_scroll = '1' and lap_scroll_last = '0' then
                    if read_ptr = NUMBER_OF_LAPS - 1 then
                        read_ptr <= 0;
                    else
                        read_ptr <= read_ptr + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;  
    
data_out <= write(read_ptr);  

end Behavioral;
