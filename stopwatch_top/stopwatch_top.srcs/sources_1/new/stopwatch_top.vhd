library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity stopwatch_top is
    Port ( clk : in STD_LOGIC;
           btnu : in STD_LOGIC;
           btnd : in STD_LOGIC;
           btnc : in STD_LOGIC;
           btnr : in STD_LOGIC;
           btnl : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           dp : out STD_LOGIC;
           led16_b : out STD_LOGIC;
           led : out STD_LOGIC_VECTOR (7 downto 0));
end stopwatch_top;

architecture Behavioral of stopwatch_top is

    component show_saved_time is
        port ( clk : in STD_LOGIC;
               data_in_cntr : in STD_LOGIC_VECTOR (18 downto 0);
               save_btn : in STD_LOGIC;
               data_in_view_mode : in STD_LOGIC_VECTOR (18 downto 0);
               output : out STD_LOGIC_VECTOR (18 downto 0)
               );
    end component show_saved_time;

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
    
    component bin2seg is
    port (
        bin : in  std_logic_vector(3 downto 0);  -- 4-bit hexadecimal input
        seg : out std_logic_vector(6 downto 0)   -- {a,b,c,d,e,f,g} active-low outputs
    );
    end component bin2seg;
    
    component debounce is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        btn_in      : in  std_logic;  -- Bouncey button input
      
        btn_press   : out std_logic;   -- 1-clock press pulse
        btn_state   : out std_logic
        -- btn_release : out std_logic   -- 1-clock release pulse
    );
    end component debounce;
    
    component view_mode is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           time_data : in STD_LOGIC_VECTOR (18 downto 0);
           lap_data : in STD_LOGIC_VECTOR (18 downto 0);
           mode : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (18 downto 0));
    end component view_mode;
    
    component time_decoder is
    Port ( data_in : in STD_LOGIC_VECTOR (18 downto 0);
           data_out : out STD_LOGIC_VECTOR (23 downto 0));
    end component  time_decoder;
    
    component start_stop is
    Port ( clk : in STD_LOGIC;
           rst    : in  STD_LOGIC;
           btn_in : in STD_LOGIC;
           ce : in STD_LOGIC;
           en : out STD_LOGIC);
    end component start_stop;
    
    component lap_memory is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           lap_save : in STD_LOGIC;
           lap_scroll : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (18 downto 0);
           led_out : out STD_LOGIC_VECTOR (7 downto 0);
           mode : in STD_LOGIC;     
           data_out : out STD_LOGIC_VECTOR (18 downto 0));  
    end component lap_memory;
    
    component display_driver is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (23 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (5 downto 0);
           dp : out STD_LOGIC);
    end component display_driver;
    
    signal sig_start_stop  : std_logic;
    signal sig_clk_en : std_logic;
    signal sig_lap_save : std_logic;
    signal sig_lap_scroll : std_logic;
    signal sig_mode : std_logic;
    signal sig_start_stop_en : std_logic;
    signal sig_cnt : std_logic_vector(18 downto 0);
    signal sig_mux_out : std_logic_vector(18 downto 0);
    signal sig_lap_memory : std_logic_vector(18 downto 0);
    signal sig_decoded : std_logic_vector(23 downto 0);
    signal sig_show_saved : std_logic_vector(18 downto 0);

begin

        debounce_0 : debounce
        port map (                 
            clk => clk,            
            rst => btnd,
            btn_in => btnu,
            btn_state => open,
            btn_press => sig_start_stop
        );

        debounce_1 : debounce
        port map (                 
            clk => clk,            
            rst => btnd,
            btn_in => btnc,
            btn_state => led16_b,
            btn_press => sig_lap_save
         );
         
        debounce_2 : debounce
        port map (                 
            clk => clk,            
            rst => btnd,
            btn_in => btnr,
            btn_state => open,
            btn_press => sig_lap_scroll
         );
         
        debounce_3 : debounce
        port map (                 
            clk => clk,            
            rst => btnd,
            btn_in => btnl,
            btn_state => open,
            btn_press => sig_mode
         );

        clk_en_0 : clk_en
        generic map ( G_MAX => 1000000 ) 
        port map (                 
            clk => clk,            
            rst => btnd,
            ce => sig_clk_en
         );
         
        start_stop_0 : start_stop
        port map (                 
            clk => clk,            
            rst => btnd,
            btn_in => sig_start_stop,
            ce => sig_clk_en,
            en => sig_start_stop_en
         );
         
        counter_0 : counter
        generic map ( G_BITS => 19 ) 
        port map (                 
            clk => clk,            
            rst => btnd,
            cnt => sig_cnt,
            en => sig_start_stop_en
         );

        lap_memory_0 : lap_memory
        port map (                 
            clk => clk,            
            rst => btnd,
            lap_save => sig_lap_save,
            lap_scroll => sig_lap_scroll,
            mode => sig_mode,     
            data_in => sig_cnt,
            data_out => sig_lap_memory,
            led_out => led  );                   
         
        view_mode_0 : view_mode
        port map (                 
            clk => clk,            
            rst => btnd,
            time_data => sig_cnt,
            lap_data => sig_lap_memory,
            mode => sig_mode,
            data_out => sig_mux_out
         );
         
        time_decoder_0 : time_decoder
        port map (         
        data_in => sig_show_saved,
        data_out => sig_decoded     
         );

         
        display_driver_0 : display_driver
        port map (                 
            clk => clk,            
            rst => btnd,
            data => sig_decoded,
            seg => seg,
            an(5 downto 0) => an(5 downto 0),
            dp => dp
         );
         
         an(7 downto 6) <= "11";
         
         show_saved_time_0 : show_saved_time
         port map (
            clk => clk,
            data_in_cntr => sig_cnt,
            save_btn => sig_lap_save,
            data_in_view_mode => sig_mux_out,
            output => sig_show_saved
            );
        

end Behavioral;