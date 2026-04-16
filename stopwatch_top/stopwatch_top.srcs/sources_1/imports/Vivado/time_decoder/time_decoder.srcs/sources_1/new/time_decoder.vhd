
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; --Library used to numeric operations


entity time_decoder is
    Port ( data_in : in STD_LOGIC_VECTOR (18 downto 0);
           data_out : out STD_LOGIC_VECTOR (23 downto 0));
end time_decoder;

architecture Behavioral of time_decoder is
begin

process(data_in)
        
        -- Variables for calculations
        -- Integer is only whole number.
        variable total_cents : integer; -- Output from counter.
        variable mm, ss, hh  : integer;
        
        -- Variables for individual BCD digits
        variable mm_tens, mm_ones : integer; -- Minutes
        variable ss_tens, ss_ones : integer; -- Seconds
        variable hh_tens, hh_ones : integer; -- Hundredths
    begin
        -- Convert input vector to integer
        total_cents := to_integer(unsigned(data_in));

        -- Split into time units
        hh := total_cents rem 100; -- rem = Remainder after division. This variable only takes what is left after dividing it into whole seconds.
        ss := (total_cents / 100) rem 60; -- rem 60 limits variable ss to 59. 
        mm := (total_cents / 6000) rem 60; -- rem 60 limits variable ss to 59. 

        -- 2. Convert each unit to two BCD digits
        hh_tens := hh / 10;
        hh_ones := hh rem 10;
        
        ss_tens := ss / 10;
        ss_ones := ss rem 10;
        
        mm_tens := mm / 10;
        mm_ones := mm rem 10;

        -- Assemble the 24-bit output (6 digits * 4 bits)
        data_out(23 downto 20) <= std_logic_vector(to_unsigned(mm_tens, 4));
        data_out(19 downto 16) <= std_logic_vector(to_unsigned(mm_ones, 4));
        data_out(15 downto 12) <= std_logic_vector(to_unsigned(ss_tens, 4));
        data_out(11 downto 8)  <= std_logic_vector(to_unsigned(ss_ones, 4));
        data_out(7 downto 4)   <= std_logic_vector(to_unsigned(hh_tens, 4));
        data_out(3 downto 0)   <= std_logic_vector(to_unsigned(hh_ones, 4));
        
    end process;

end Behavioral;
