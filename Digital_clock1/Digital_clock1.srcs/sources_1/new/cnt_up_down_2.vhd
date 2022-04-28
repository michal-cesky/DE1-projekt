------------------------------------------------------------
--
-- N-bit Up/Down binary counter.
-- Nexys A7-50T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2019-Present Tomas Fryza
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------
-- Entity declaration for n-bit counter
------------------------------------------------------------
entity cnt_up_down_2 is
    generic(
        g_CNT_WIDTH : natural := 4 -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;  -- Main clock
        reset    : in  std_logic;  -- Synchronous reset
        en_i     : in  std_logic;  -- Enable input
        cnt_i    : in  std_logic;  -- Direction of the counter
        cnt_i2   : in  std_logic;
        cnt_om   : out std_logic_vector(g_CNT_WIDTH - 1 downto 0);
        cnt_o    : out std_logic
    );
end entity cnt_up_down_2;

------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------
architecture behavioral of cnt_up_down_2 is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0);

begin
    --------------------------------------------------------
    -- p_cnt_up_down:
    -- Clocked process with synchronous reset which implements
    -- n-bit up/down counter.
    --------------------------------------------------------
   p_cnt_up_down : process(clk)
    begin
        if rising_edge(clk) then
        
            if (reset = '1') then   -- Synchronous reset
                s_cnt_local <= (others => '0'); -- Clear all bits

            elsif (en_i = '1') then -- Test if counter is enabled
                  s_cnt_local <= (others => '0');
                
                if ((cnt_i and cnt_i2) = '1') then
                
                    if (s_cnt_local(0) = '0') and (s_cnt_local(1) = '0' ) and (s_cnt_local(2) = '0' ) and (s_cnt_local(3) = '1' ) then
                        s_cnt_local <= s_cnt_local + 1;
                        cnt_o <= '1';
                    elsif (s_cnt_local(0) = '1') and (s_cnt_local(1) = '0' ) and (s_cnt_local(2) = '0' ) and (s_cnt_local(3) = '1' ) then
                        s_cnt_local <= (others => '0'); -- Clear all bits
                        cnt_o <= '0';
                    else
                        s_cnt_local <= s_cnt_local + 1;
                        cnt_o <= '0';  
                    end if;   
                
             else             
                    s_cnt_local <= s_cnt_local ;
                
                
                 end if;
            end if;
            
            
        end if;
    end process p_cnt_up_down;

    -- Output must be retyped from "unsigned" to "std_logic_vector"
    cnt_om <= std_logic_vector(s_cnt_local);

end architecture behavioral;
