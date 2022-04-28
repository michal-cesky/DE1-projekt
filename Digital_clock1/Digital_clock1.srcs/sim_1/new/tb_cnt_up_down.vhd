------------------------------------------------------------
--
-- Testbench for N-bit Up/Down binary counter.
-- Nexys A7-50T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2020-Present Tomas Fryza
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------
entity tb_cnt_up_down is
    -- Entity of testbench is always empty
end entity tb_cnt_up_down; 

------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------
architecture testbench of tb_cnt_up_down is

    -- Number of bits for testbench counter
    constant c_CNT_WIDTH         : natural := 5;
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz : std_logic;
    signal s_reset      : std_logic;
    signal s_en         : std_logic;
    signal s_cnt_up     : std_logic;
    signal s_cnt1       : std_logic;
    signal s_cnts       : std_logic_vector(c_CNT_WIDTH - 1 downto 0);
    signal s_cnt2       : std_logic;
    signal s_cntss      : std_logic_vector(c_CNT_WIDTH - 1 downto 0);
    signal s_cnt3       : std_logic; 
    signal s_cntm       : std_logic_vector(c_CNT_WIDTH - 1 downto 0);
    signal s_cnt4       : std_logic;
    signal s_cntmm      : std_logic_vector(c_CNT_WIDTH - 1 downto 0);
    signal s_cnt5       : std_logic;
    signal s_cnth       : std_logic_vector(c_CNT_WIDTH - 1 downto 0); 
    signal s_cnt6       : std_logic;
    signal s_cnthh      : std_logic_vector(c_CNT_WIDTH - 1 downto 0);
    signal s_cnt_d      : std_logic;
begin
    -- Connecting testbench signals with cnt_up_down entity
    -- (Unit Under Test)
    --first cnt_up_down (seconds)
    uut_cnt : entity work.cnt_up_down
        generic map(
            g_CNT_WIDTH  => c_CNT_WIDTH
        )
        port map(
            clk      => s_clk_100MHz,
            reset    => s_reset,
            en_i     => s_en,
            cnt_up_i => s_cnt_up,
            cnt_os   => s_cnts,
            cnt_o   => s_cnt1
        );

    --second cnt_up_down (10 seconds)
    uut_cnt1 : entity work.cnt_up_down_1
        generic map(
            g_CNT_WIDTH  => c_CNT_WIDTH
        )
        port map(
            clk      => s_clk_100MHz,
            reset    => s_reset,
            en_i     => s_en,
            cnt_i    => s_cnt1,
            cnt_oss  => s_cntss,
            cnt_o    => s_cnt2
        );
    
    --third cnt_up_down (minutes)
    uut_cnt2 : entity work.cnt_up_down_2
        generic map(
            g_CNT_WIDTH  => c_CNT_WIDTH
        )
        port map(
            clk      => s_clk_100MHz,
            reset    => s_reset,
            en_i     => s_en,
            cnt_i    => s_cnt1,
            cnt_i2   => s_cnt2,
            cnt_om   => s_cntm,
            cnt_o    => s_cnt3
        );    
    
    --fourth cnt_up_down 10 minutes
    uut_cnt3 : entity work.cnt_up_down_3
        generic map(
            g_CNT_WIDTH  => c_CNT_WIDTH
        )
        port map(
            clk      => s_clk_100MHz,
            reset    => s_reset,
            en_i     => s_en,
            cnt_i    => s_cnt1,
            cnt_i2   => s_cnt2,
            cnt_i3   => s_cnt3,
            cnt_omm   => s_cntmm,
            cnt_o    => s_cnt4
        );      
        
     --fifth cnt_up_down hours
    uut_cnt4 : entity work.cnt_up_down_4
        generic map(
            g_CNT_WIDTH  => c_CNT_WIDTH
        )
        port map(
            clk      => s_clk_100MHz,
            reset    => s_reset,
            en_i     => s_en,
            cnt_i    => s_cnt1,
            cnt_i2   => s_cnt2,
            cnt_i3   => s_cnt3,
            cnt_i4   => s_cnt4,
            cnt_oh   => s_cnth,
            cnt_o    => s_cnt5,
            cnt_i6   => s_cnt_d
        );          
    
    --sixth cnt_up_down 10 hours
    uut_cnt5 : entity work.cnt_up_down_5
        generic map(
            g_CNT_WIDTH  => c_CNT_WIDTH
        )
        port map(
            clk      => s_clk_100MHz,
            reset    => s_reset,
            en_i     => s_en,
            cnt_i    => s_cnt1,
            cnt_i2   => s_cnt2,
            cnt_i3   => s_cnt3,
            cnt_i4   => s_cnt4,
            cnt_i5   => s_cnt5,
            cnt_ohh  => s_cnthh,
            cnt_o    => s_cnt6,
            cnt_d   => s_cnt_d
        );            
    --------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 1000 ns loop -- 75 periods of 100MHz clock
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2000;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2000;
        end loop;
        wait;
    end process p_clk_gen;

    --------------------------------------------------------
    -- Reset generation process
    --------------------------------------------------------
    p_reset_gen : process
    begin
        
        -- Reset activated
        s_reset <= '1'; wait for 13 ns;
        -- Reset deactivated
        s_reset <= '0';
        wait;
    end process p_reset_gen;

    --------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;

        -- Enable counting
        s_en     <= '1';
        
        -- Change counter direction
        s_cnt_up <= '1';
        wait for 4000000 ns;
        s_cnt_up <= '0';
        wait for 220 ns;
        

        -- Disable counting
        s_en     <= '0';

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end architecture testbench;


