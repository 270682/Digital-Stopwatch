
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_driver is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (23 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (5 downto 0));
end display_driver;

architecture Behavioral of display_driver is

        -- Component declaration for clock enable
        component clk_en is
            generic ( G_MAX : positive );
            port (
                clk : in  std_logic;
                rst : in  std_logic;
                ce  : out std_logic
            );
        end component clk_en;
    
        -- Component declaration for binary counter
        component counter is
            generic ( G_BITS : positive );
            port (
                clk : in  std_logic;
                rst : in  std_logic;
                en  : in  std_logic;
                cnt : out std_logic_vector(G_BITS - 1 downto 0)
            );
        end component counter;
    
        -- Component declaration for bin2seg
        component bin2seg is
            port (
                bin : in  std_logic_vector(3 downto 0);
                seg : out std_logic_vector(6 downto 0)
            );
        end component bin2seg;
    
    -- Internal signals
    signal sig_en    : std_logic;
    signal sig_digit : std_logic_vector(2 downto 0);  -- Can be scalable. We need 6 values.
    signal sig_bin   : std_logic_vector(3 downto 0);

begin

    ------------------------------------------------------------------------
    -- Clock enable generator for refresh timing
    ------------------------------------------------------------------------
    clock_0 : clk_en
        generic map ( G_MAX => 8 ) -- Adjust for flicker-free multiplexing
        port map (                 -- For simulation: 8
            clk => clk,            -- For implementation: 8_000_000
            rst => rst,
            ce  => sig_en
        );

    ------------------------------------------------------------------------
    -- N-bit counter for digit selection
    ------------------------------------------------------------------------
    counter_0 : counter
       generic map ( G_BITS => 3 )
       port map (
           clk => clk,
           rst => rst,
           en  => sig_en,
           cnt => sig_digit
       );

    ------------------------------------------------------------------------
    -- Digit select multiplexer
    ------------------------------------------------------------------------
    process (sig_digit, data)
    begin
        case sig_digit is
            when "000"  => sig_bin <= data(3 downto 0);   -- Hundredths ones
            when "001"  => sig_bin <= data(7 downto 4);   -- Hundredths tens
            when "010"  => sig_bin <= data(11 downto 8);  -- Seconds ones
            when "011"  => sig_bin <= data(15 downto 12); -- Seconds tens
            when "100"  => sig_bin <= data(19 downto 16); -- Minutes ones
            when "101"  => sig_bin <= data(23 downto 20); -- Minutes tens
            when others => sig_bin <= "0000";
        end case;
    end process;
    ------------------------------------------------------------------------
    -- 7-segment decoder
    ------------------------------------------------------------------------
    decoder_0 : bin2seg
        port map (
            bin => sig_bin,
            seg => seg
        );

    ------------------------------------------------------------------------
    -- Anode select process
    ------------------------------------------------------------------------
    p_anode_select : process (sig_digit) is
    begin
        case sig_digit is
            when "000"  => an <= "111110"; -- Digit 0 on
            when "001"  => an <= "111101"; -- Digit 1 on
            when "010"  => an <= "111011"; -- Digit 2 on
            when "011"  => an <= "110111"; -- Digit 3 on
            when "100"  => an <= "101111"; -- Digit 4 on
            when "101"  => an <= "011111"; -- Digit 5 on
            when others => an <= "111111"; -- All off
        end case;
    end process;


end Behavioral;
