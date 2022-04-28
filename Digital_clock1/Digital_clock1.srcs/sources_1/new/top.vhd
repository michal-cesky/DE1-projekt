----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.03.2022 12:32:31
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR(15 DOWNTO 0 );
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           BTNC : in STD_LOGIC;
           BTNU : in STD_LOGIC);
end top;

architecture Behavioral of top is

signal s_cnt_os :std_logic_vector(4-1 downto 0);
signal s_cnt_oss :std_logic_vector(4-1 downto 0);
signal s_cnt_om :std_logic_vector(4-1 downto 0);
signal s_cnt_omm :std_logic_vector(4-1 downto 0);
signal s_cnt_oh :std_logic_vector(4-1 downto 0);
signal s_cnt_ohh :std_logic_vector(4-1 downto 0);
signal s_cnt_1 : std_logic;
signal s_cnt_2 : std_logic;
signal s_cnt_3 : std_logic;
signal s_cnt_4 : std_logic;
signal s_cnt_5 : std_logic;
signal s_cnt_6 : std_logic;
signal s_en : std_logic;
signal s_cnt_am : std_logic_vector(4- 1 downto 0);
signal s_cnt_d : std_logic;
------------------------------------------------------------
-- Architecture body for top level
------------------------------------------------------------
begin

     clk_en0 : entity work.clock_enable_1
      generic map(
          g_MAX => 100000000
      )
      port map(
          clk   => CLK100MHZ,
          reset => BTNC,
          ce_o  => s_en
      );
      
     uut_cnt : entity work.cnt_up_down
        generic map(
            g_CNT_WIDTH  => 4
        )
        port map(
            clk      => CLK100MHZ,
            reset    => BTNC,
            en_i     => s_en,
            cnt_up_i => SW(0),
            cnt_os   => s_cnt_os,
            cnt_o   => s_cnt_1
        );

    --second cnt_up_down (10 seconds)
    uut_cnt1 : entity work.cnt_up_down_1
        generic map(
            g_CNT_WIDTH  => 4
        )
        port map(
            clk      => CLK100MHZ,
            reset    => BTNC,
            en_i     => s_en,
            cnt_i    => s_cnt_1,
            cnt_oss  => s_cnt_oss,
            cnt_o    => s_cnt_2
        );
    
    --third cnt_up_down (minutes)
    uut_cnt2 : entity work.cnt_up_down_2
        generic map(
            g_CNT_WIDTH  => 4
        )
        port map(
            clk      => CLK100MHZ,
            reset    => BTNC,
            en_i     => s_en,
            cnt_i    => s_cnt_1,
            cnt_i2   => s_cnt_2,
            cnt_om   => s_cnt_om,
            cnt_o    => s_cnt_3
        );    
    
    --fourth cnt_up_down 10 minutes
    uut_cnt3 : entity work.cnt_up_down_3
        generic map(
            g_CNT_WIDTH  => 4
        )
        port map(
            clk      => CLK100MHZ,
            reset    => BTNC,
            en_i     => s_en,
            cnt_i    => s_cnt_1,
            cnt_i2   => s_cnt_2,
            cnt_i3   => s_cnt_3,
            cnt_omm   => s_cnt_omm,
            cnt_o    => s_cnt_4
        );      
        
     --fifth cnt_up_down hours
    uut_cnt4 : entity work.cnt_up_down_4
        generic map(
            g_CNT_WIDTH  => 4
        )
        port map(
            clk      => CLK100MHZ,
            reset    => BTNC,
            en_i     => s_en,
            cnt_i    => s_cnt_1,
            cnt_i2   => s_cnt_2,
            cnt_i3   => s_cnt_3,
            cnt_i4   => s_cnt_4,
            cnt_oh   => s_cnt_oh,
            cnt_o    => s_cnt_5,
            cnt_i6   => s_cnt_d
        );          
    
    --sixth cnt_up_down 10 hours
    uut_cnt5 : entity work.cnt_up_down_5
        generic map(
            g_CNT_WIDTH  => 4
        )
        port map(
            clk      => CLK100MHZ,
            reset    => BTNC,
            en_i     => s_en,
            cnt_i    => s_cnt_1,
            cnt_i2   => s_cnt_2,
            cnt_i3   => s_cnt_3,
            cnt_i4   => s_cnt_4,
            cnt_i5   => s_cnt_5,
            cnt_ohh  => s_cnt_ohh,
            cnt_o    => s_cnt_6,
            cnt_d   => s_cnt_d
        );        
        
    --minutes adder        
    uut_cntm : entity work.cnt_m
        generic map(
            g_CNT_WIDTH  => 4
        )
        port map(
            clk      => CLK100MHZ,
            reset    => BTNC,
            en_i     => s_en,
            data2_i  => s_cnt_om,
            cnt_up_i => SW(1),
            cnt_o   => s_cnt_am
        );
  --------------------------------------------------------
  -- Instance (copy) of driver_7seg_4digits entity
  driver_seg_4 : entity work.driver_7seg_4digits
      port map(
          clk        => CLK100MHZ,
          reset      => BTNC,
          data0_i => s_cnt_os,
          --data0_i => "0001",--s_cnt_os,
          
          -- WRITE YOUR CODE HERE
          data1_i => s_cnt_oss,
        
          --data1_i => "0010",
          
          
          data2_i => s_cnt_om,--s_cnt_om,
          
          --data2_i => "0011",--s_cnt_om,
          
          
          data3_i => s_cnt_omm,
          --data3_i => "0100",--s_cnt_omm,
         data4_i => s_cnt_oh,
         
         data5_i => s_cnt_ohh,

          
          dp_i => "0111",
          
          seg_o(6) => CA,
          seg_o(5) => CB,
          seg_o(4) => CC,
          seg_o(3) => CD,
          seg_o(2) => CE,
          seg_o(1) => CF,
          seg_o(0) => CG,
          
          dp_o => DP,
          dig_o(5 downto 0) => AN(5 downto 0)
      );

  -- Disconnect the top four digits of the 7-segment display
  
AN(7 downto 6) <= b"11";
end architecture Behavioral;
--begin


--end Behavioral;
