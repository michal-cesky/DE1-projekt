# DIGITAL CLOCK

### Team members

* Member 1 Šimon Buchta
* Member 2 Michal Český
* Member 3 Raul Gomez Ibanez

### Table of contents

* [Project objectives](#objectives)
* [Hardware description](#hardware)
* [VHDL modules description and simulations](#modules)
* [TOP module description and simulations](#top)
* [Video](#video)
* [References](#references)

<a name="objectives"></a>

## Project objectives

Tento repositář vznikl na základě předmětu Digitální elektrotechnika 1 na vysoké škole VUT FEKT.
Zadáním bylo vytvořit digitální hodiny v jazyce vhdl. Hodiny by měli mít základní hodinový strojek pro počítání sekund, minut a následně hodin, možnost nastavení času a na závěr nastavení budíku na určitý čas kde se poté rozsvítí LED dioda. Čas se bude zobrazovat na šesti segmentových displejích.
Toto implementujeme pomocí programu Vivadeo na desku Nexys A7-50T.

<a name="hardware"></a>

## Hardware description

Deska Nexys A7 je kompletní platforma pro vývoj digitálních obvodů připravená k použití, založená na nejnovějším Artix-7™ Field Programmable Gate Array (FPGA) od Xilinx®. Díky velkému, vysokokapacitnímu FPGA, velkorysým externím pamětem a sbírce USB, Ethernet a dalších portů může Nexys A7 hostit návrhy od úvodních kombinačních obvodů až po výkonné vestavěné procesory.

![git](images/nexys-a7.png)

V našem případě budeme pouze používat segmentové displeje, tlačítka a spínače.

#### Display
Deska Nexys A7 obsahuje dva čtyřmístné sedmisegmentové LED displeje se společnou anodou, nakonfigurované tak, aby se chovaly jako jeden osmimístný displej. V našem případě budeme využívat oba čtyřsegmentové displeje ale ten druhý pouze z půlky. Jeden sedmisegmentový displej se skládá ze sedmi segmentů, pokud budou svítit všechny segmenty dostaneme číslo 8. K tomu, aby každý displej mohl svítit samostatně je zapotřebí mít oddělené katody. Jeho schéma je vidět na obrázku.

![git](images/displej.png)

#### Tlačítka a Spínače

Tato deska disponuje 16 spínačia a tlačítky. Tyto spínače a tlačítka jsou k desce připojeny přes odpory aby nemohlo vzniknout poškození desky. Tlačítka jsou dizainované na změně výkonu. Při stisknutí generují mnohem větší výkon nežpři normáloném stavu. 
Jak josuzapojeny tlačítka, spínače, LED diody, segmentové displeje a následně RGB LED diody zobrazuje toto schema.

![git](images/schemadeska.png)

#### Constraints File
Tento soubor slouží k správnému přiřazení pinů na desce.

```shell
## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {CLK100MHZ}];

##Switches
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { SW[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { SW[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { SW[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=sw[2]
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { SW[3] }]; #IO_L13N_T2_MRCC_14 Sch=sw[3]

##7 segment display
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { CA }]; #IO_L24N_T3_A00_D16_14 Sch=ca
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { CB }]; #IO_25_14 Sch=cb
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { CC }]; #IO_25_15 Sch=cc
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { CD }]; #IO_L17P_T2_A26_15 Sch=cd
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { CE }]; #IO_L13P_T2_MRCC_14 Sch=ce
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { CF }]; #IO_L19P_T3_A10_D26_14 Sch=cf
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { CG }]; #IO_L4P_T0_D04_14 Sch=cg
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { DP }]; #IO_L19N_T3_A21_VREF_15 Sch=dp
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { AN[0] }]; #IO_L23P_T3_FOE_B_15 Sch=an[0]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { AN[1] }]; #IO_L23N_T3_FWE_B_15 Sch=an[1]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { AN[2] }]; #IO_L24P_T3_A01_D17_14 Sch=an[2]
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { AN[3] }]; #IO_L19P_T3_A22_15 Sch=an[3]
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { AN[4] }]; #IO_L8N_T1_D12_14 Sch=an[4]
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { AN[5] }]; #IO_L14P_T2_SRCC_14 Sch=an[5]
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { AN[6] }]; #IO_L23P_T3_35 Sch=an[6]
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { AN[7] }]; #IO_L23N_T3_A02_D18_14 Sch=an[7]

##Buttons
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { BTNC }]; #IO_L9P_T1_DQS_14 Sch=btnc
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { BTNU }]; #IO_L4N_T0_D05_14 Sch=btnu
```

<a name="modules"></a>

## VHDL modules description and simulations

#### Clock_enable
Tento modul slouží ke generování hodinového signálu. Tento modul jsme následně využili u cnt_up_down.
```vhdl
library ieee;               -- Standard library
use ieee.std_logic_1164.all;-- Package for data types and logic operations
use ieee.numeric_std.all;   -- Package for arithmetic operations

entity clock_enable is
    generic(
        g_MAX : natural := 400000  -- Number of clk pulses to
                               -- generate one enable signal
                               -- period
    );  -- Note that there IS a semicolon between generic 
        -- and port sections
    port(
        clk   : in  std_logic; -- Main clock
        reset : in  std_logic; -- Synchronous reset
        ce_o  : out std_logic  -- Clock enable pulse signal
    );
end entity clock_enable;

architecture Behavioral of clock_enable is

    -- Local counter
    signal s_cnt_local : natural;

begin
    p_clk_ena : process(clk)
    begin
        if rising_edge(clk) then    -- Synchronous process

            if (reset = '1') then   -- High active reset
                s_cnt_local <= 0;   -- Clear local counter
                ce_o        <= '0'; -- Set output to low

            -- Test number of clock periods
            elsif (s_cnt_local >= (g_MAX - 1)) then
                s_cnt_local <= 0;   -- Clear local counter
                ce_o        <= '1'; -- Generate clock enable pulse

            else
                s_cnt_local <= s_cnt_local + 1;
                ce_o        <= '0';
            end if;
        end if;
    end process p_clk_ena;

end architecture Behavioral;
```

#### cnt_up_down 0
Modul slouží k jednotlivému počítání setin vteřin. Podmínka značí že pokud čítač dosáhne hodnoty 9 vyresetuje se a začne počítat zase od 0.
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cnt_up_down is
    generic(
        g_CNT_WIDTH : natural := 4 -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;  -- Main clock
        reset    : in  std_logic;  -- Synchronous reset
        en_i     : in  std_logic;  -- Enable input
        cnt_up_i : in  std_logic;  -- Direction of the counter
        cnt_os   : out std_logic_vector(g_CNT_WIDTH - 1 downto 0);
        cnt_o    : out std_logic
    );
end entity cnt_up_down;

architecture behavioral of cnt_up_down is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0);
begin
    p_cnt_up_down : process(clk)
    begin
        
        if rising_edge(clk) then        
            if (reset = '1') then   -- Synchronous reset
                s_cnt_local <= (others => '0'); -- Clear all bits
            elsif (en_i = '1') then -- Test if counter is enabled
                  s_cnt_local <= (others => '0');
                if (cnt_up_i = '1') then                             
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
    cnt_os <= std_logic_vector(s_cnt_local);
    
end architecture behavioral;
```



#### cnt_up_down 1
Modul slouží k jednotlivému počítání desítek vteřin. Podmínka značí že pokud čítač cnt_up_down dosáhne hodnoty 9 tak začne počítat. Tato podmínka platí do té doby než čítač dosáhne hodnoty 6. Poté se vyresetuje.
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cnt_up_down_1 is
    generic(
        g_CNT_WIDTH : natural := 4 -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;  -- Main clock
        reset    : in  std_logic;  -- Synchronous reset
        en_i     : in  std_logic;  -- Enable input
        cnt_i   : in  std_logic;  -- Direction of the counter
        cnt_oss  : out std_logic_vector(g_CNT_WIDTH - 1 downto 0);
        cnt_o   : out std_logic
    );
end entity cnt_up_down_1;

architecture behavioral of cnt_up_down_1 is

    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0);

begin

    p_cnt_up_down : process(clk)
    begin
        if rising_edge(clk) then        
            if (reset = '1') then   -- Synchronous reset
                s_cnt_local <= (others => '0'); -- Clear all bits
            elsif (en_i = '1') then -- Test if counter is enabled
                  s_cnt_local <= (others => '0');               
                if (cnt_i = '1') then               
                    if (s_cnt_local(0) = '0') and (s_cnt_local(1) = '0' ) and (s_cnt_local(2) = '1' ) and (s_cnt_local(3) = '0' ) then
                        s_cnt_local <= s_cnt_local + 1;
                        cnt_o <= '1';
                    elsif (s_cnt_local(0) = '1') and (s_cnt_local(1) = '0' ) and (s_cnt_local(2) = '1' ) and (s_cnt_local(3) = '0' ) then
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
    cnt_oss <= std_logic_vector(s_cnt_local);

end architecture behavioral;
```

#### cnt_up_down 2
Modul slouží k jednotlivému počítání jednotek minut. Podmínka značí že pokud čítač cnt_up_down 1 dosáhne hodnoty 6 a zároveň čítač cnt_up_down hodnty 9 tak začne počítat. Tato podmínka platí do té doby než čítač cnt_up_down dosáhne hodnoty 9. Poté se vyresetuje.
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

architecture behavioral of cnt_up_down_2 is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0);

begin
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
```
#### cnt_up_down 3
Modul slouží k jednotlivému počítání desítek minut. Podmínka značí že pokud čítač cnt_up_down 2 dosáhne hodnoty 9 a zároveň  cnt_up_down 1 dosáhne hodnoty 6 a zároveň čítač cnt_up_down hodnoty 9 tak začne počítat. Tato podmínka platí do té doby než čítač cnt_up_down dosáhne hodnoty 9. Poté se vyresetuje.
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cnt_up_down_3 is
    generic(
        g_CNT_WIDTH : natural := 4 -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;  -- Main clock
        reset    : in  std_logic;  -- Synchronous reset
        en_i     : in  std_logic;  -- Enable input
        cnt_i    : in  std_logic;  -- Direction of the counter
        cnt_i2   : in  std_logic;
        cnt_i3   : in  std_logic;
        cnt_omm   : out std_logic_vector(g_CNT_WIDTH - 1 downto 0);
        cnt_o    : out std_logic
    );
end entity cnt_up_down_3;

architecture behavioral of cnt_up_down_3 is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0);

begin
   p_cnt_up_down : process(clk)
    begin
        if rising_edge(clk) then
        
            if (reset = '1') then   -- Synchronous reset
                s_cnt_local <= (others => '0'); -- Clear all bits
            elsif (en_i = '1') then -- Test if counter is enabled
                  s_cnt_local <= (others => '0');               
                if ((cnt_i and cnt_i2 and cnt_i3) = '1') then                
                    if (s_cnt_local(0) = '0') and (s_cnt_local(1) = '0' ) and (s_cnt_local(2) = '1' ) and (s_cnt_local(3) = '0' ) then
                        s_cnt_local <= s_cnt_local + 1;
                        cnt_o <= '1';
                    elsif (s_cnt_local(0) = '1') and (s_cnt_local(1) = '0' ) and (s_cnt_local(2) = '1' ) and (s_cnt_local(3) = '0' ) then
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
    cnt_omm <= std_logic_vector(s_cnt_local);

end architecture behavioral;
```
#### cnt_up_down 4
Modul slouží k jednotlivému počítání jednotek hodin. Podmínka značí že pokud čítač cnt_up_down 3 dosáhne hodnoty 6 a zároveň cnt_up_down 2 dosáhne hodnoty 9 a zároveň cnt_up_down 1 dosáhne hodnoty 6 a zároveň čítač cnt_up_down hodnoty 9 tak začne počítat. Tato podmínka platí do té doby než čítač cnt_up_down dosáhne hodnoty 9. Poté se vyresetuje.
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cnt_up_down_4 is
    generic(
        g_CNT_WIDTH : natural := 4 -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;  -- Main clock
        reset    : in  std_logic;  -- Synchronous reset
        en_i     : in  std_logic;  -- Enable input
        cnt_i    : in  std_logic;  -- Direction of the counter
        cnt_i2   : in  std_logic;
        cnt_i3   : in  std_logic;
        cnt_i4   : in  std_logic;
        cnt_i6   : in  std_logic;
        cnt_oh   : out std_logic_vector(g_CNT_WIDTH - 1 downto 0);
        cnt_o    : out std_logic
    );
end entity cnt_up_down_4;

architecture behavioral of cnt_up_down_4 is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0);

begin
   p_cnt_up_down : process(clk)
    begin
        if rising_edge(clk) then       
            if (reset = '1') then   -- Synchronous reset
                s_cnt_local <= (others => '0'); -- Clear all bits
            elsif (en_i = '1') then -- Test if counter is enabled
                  s_cnt_local <= (others => '0');               
                if ((cnt_i and cnt_i2 and cnt_i3 and cnt_i4) = '1') then             
                    if (s_cnt_local(0) = '0') and (s_cnt_local(1) = '0' ) and (s_cnt_local(2) = '0' ) and (s_cnt_local(3) = '1' )  then
                        s_cnt_local <= s_cnt_local + 1;
                        cnt_o <= '1';
                    elsif (s_cnt_local(0) = '1') and (s_cnt_local(1) = '0' ) and (s_cnt_local(2) = '0' ) and (s_cnt_local(3) = '1' )  then
                        s_cnt_local <= (others => '0'); -- Clear all bits
                        cnt_o <= '0';
                    elsif (s_cnt_local(0) = '0') and (s_cnt_local(1) = '1' ) and (s_cnt_local(2) = '0' ) and (s_cnt_local(3) = '0' ) and (cnt_i6 = '1') then
                        s_cnt_local <= s_cnt_local +1;
                        cnt_o <= '1';                   
                    elsif (s_cnt_local(0) = '1') and (s_cnt_local(1) = '1' ) and (s_cnt_local(2) = '0' ) and (s_cnt_local(3) = '0' ) and (cnt_i6 = '1') then
                        s_cnt_local <= (others => '0'); -- Clear all binary_read
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
    cnt_oh <= std_logic_vector(s_cnt_local);

end architecture behavioral;
```
#### cnt_up_down 5
Modul slouží k jednotlivému počítání desítek hodin. Podmínka značí že pokud čítač cnt_up_down 4 dosáhne hodnoty 9 a zároveň cnt_up_down 3 dosáhne hodnoty 6 a zároveň cnt_up_down 2 dosáhne hodnoty 9 a zároveň cnt_up_down 1 dosáhne hodnoty 6 a zároveň čítač cnt_up_down hodnoty 9 tak začne počítat. Tato podmínka platí do té doby než čítač cnt_up_down dosáhne hodnoty 9. Poté se vyresetuje.
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cnt_up_down_5 is
    generic(
        g_CNT_WIDTH : natural := 4 -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;  -- Main clock
        reset    : in  std_logic;  -- Synchronous reset
        en_i     : in  std_logic;  -- Enable input
        cnt_i    : in  std_logic;  -- Direction of the counter
        cnt_i2   : in  std_logic;
        cnt_i3   : in  std_logic;
        cnt_i4   : in  std_logic;
        cnt_i5   : in  std_logic;
        cnt_ohh  : out std_logic_vector(g_CNT_WIDTH - 1 downto 0);
        cnt_o    : out std_logic;
        cnt_d    : out std_logic
    );
end entity cnt_up_down_5;

architecture behavioral of cnt_up_down_5 is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0);
    signal cnt_6o : std_logic;
begin
   p_cnt_up_down : process(clk)
    begin
        if rising_edge(clk) then       
            if (reset = '1') then   -- Synchronous reset
                s_cnt_local <= (others => '0'); -- Clear all bits
            elsif (en_i = '1') then -- Test if counter is enabled
                  s_cnt_local <= (others => '0');            
                if ((cnt_i and cnt_i2 and cnt_i3 and cnt_i4 and cnt_i5) = '1') then              
                    if (s_cnt_local(0) = '1') and (s_cnt_local(1) = '0' ) and (s_cnt_local(2) = '0' ) and (s_cnt_local(3) = '0' ) then
                        s_cnt_local <= s_cnt_local + 1;
                        cnt_o <= '1';
                        cnt_6o <= '1';
                    elsif (s_cnt_local(0) = '0') and (s_cnt_local(1) = '1' ) and (s_cnt_local(2) = '0' ) and (s_cnt_local(3) = '0' ) then
                        s_cnt_local <= (others => '0'); -- Clear all bits
                        cnt_o <= '0';
                        cnt_6o <= '0';
                    else
                        s_cnt_local <= s_cnt_local + 1;
                        cnt_o <= '0';
                        cnt_6o <= '0';  
                    end if;               
             else             
                    s_cnt_local <= s_cnt_local ;                
                 end if;
            end if;                       
        end if;
    end process p_cnt_up_down;

    -- Output must be retyped from "unsigned" to "std_logic_vector"
    cnt_ohh <= std_logic_vector(s_cnt_local);
    cnt_d <= std_logic(cnt_6o);
end architecture behavioral;
```
#### driver_7seg_4digits
Modul slouží ke zvolení správnému displeje a nastavené dané hodnoty.
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity driver_7seg_4digits is
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;
        -- 4-bit input values for individual digits
        data0_i : in  std_logic_vector(4 - 1 downto 0);
        data1_i : in  std_logic_vector(4 - 1 downto 0);
        data2_i : in  std_logic_vector(4 - 1 downto 0);
        data3_i : in  std_logic_vector(4 - 1 downto 0);
        data4_i : in  std_logic_vector(4 - 1 downto 0);
        data5_i : in  std_logic_vector(4 - 1 downto 0);
        -- 4-bit input value for decimal points
        dp_i    : in  std_logic_vector(4 - 1 downto 0);
        -- Decimal point for specific digit
        dp_o    : out std_logic;
        -- Cathode values for individual segments
        seg_o   : out std_logic_vector(7 - 1 downto 0);
        -- Common anode signals to individual displays
        dig_o   : out std_logic_vector(6 - 1 downto 0)
    );
end entity driver_7seg_4digits;

architecture Behavioral of driver_7seg_4digits is

    -- Internal clock enable
    signal s_en  : std_logic;
    -- Internal 2-bit counter for multiplexing 4 digits
    signal s_cnt : std_logic_vector(3 - 1 downto 0);
    -- Internal 4-bit value for 7-segment decoder
    signal s_hex : std_logic_vector(4 - 1 downto 0);

begin
    clk_en0 : entity work.clock_enable
        generic map(
            g_MAX => 4000
        )
        port map(
            clk => clk , 
            reset => reset,
            ce_o  => s_en
        );

    bin_cnt0 : entity work.cnt_up_down_0
        generic map(
            g_CNT_Width => 3
        )
        port map(
            en_i => s_en,
            cnt_up_i =>'0',
            reset => reset,
            clk => clk,
            cnt_o =>s_cnt
        );

    hex2seg : entity work.hex_7seg
        port map(
            hex_i => s_hex,
            seg_o => seg_o
        );
        
    p_mux : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                s_hex <= data0_i;
                dp_o  <= dp_i(0);
                dig_o <= "111110";
            else
                case s_cnt is
                    when "110" =>
                        s_hex <= data5_i;
                        dp_o  <= dp_i(3);
                        dig_o <= "011111";

                    when "101" =>
                        s_hex <= data4_i;
                        dp_o  <= dp_i(2);
                        dig_o <= "101111";

                    when "100" =>
                        s_hex <= data3_i;
                        dp_o  <= dp_i(1);
                        dig_o <= "110111";
                    
                    when "011" =>
                        s_hex <= data2_i;
                        dp_o  <= dp_i(1);
                        dig_o <= "111011"; 
                        
                    when "010" =>
                        s_hex <= data1_i;
                        dp_o  <= dp_i(1);
                        dig_o <= "111101";       

                    when others =>
                        s_hex <= data0_i;
                        dp_o  <= dp_i(0);
                        dig_o <= "111110";
                end case;
            end if;
        end if;
    end process p_mux;

end architecture Behavioral;
```

#### hex_7_seg
Modul slouží ke zvolení číslic a znaků na segmentový display. Zadávní je pomocí binárního kódu.
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex_7seg is
    Port ( hex_i : in STD_LOGIC_VECTOR (3 downto 0);
           seg_o : out STD_LOGIC_VECTOR (6 downto 0));
end hex_7seg;

architecture Behavioral of hex_7seg is
begin
p_7seg_decoder : process(hex_i)
    begin
        case hex_i is
            when "0000" =>
                seg_o <= "0000001"; -- 0
            when "0001" =>
                seg_o <= "1001111"; -- 1

            when "0010" =>
                seg_o <= "0010010"; -- 2
            when "0011" =>
                seg_o <= "0000110"; -- 3
            
            when "0100" =>
                seg_o <= "1001100"; -- 4

            when "0101" =>
                seg_o <= "0100100"; -- 5

            when "0110" =>
                seg_o <= "0100000"; -- 6

            when "0111" =>
                seg_o <= "0001111"; -- 7

            when "1000" =>
                seg_o <= "0000000"; -- 8

            -- WRITE YOUR CODE HERE
            when "1001" =>
                seg_o <= "0000100"; -- 9

            when "1010" =>
                seg_o <= "0000000"; -- A

            when "1011" =>
                seg_o <= "1100000"; -- B

            when "1100" =>
                seg_o <= "0110001"; -- C

            when "1101" =>
                seg_o <= "1000010"; -- D

            when "1110" =>
                seg_o <= "0110000"; -- E
            when others =>
                seg_o <= "0111000"; -- F
        end case;
    end process p_7seg_decoder;

end Behavioral;
```

![git](images/simulation-digital-clock.png)
<a name="top"></a>

## TOP module description and simulations

#### Top
Modul slouží ke propojení jednotlivých modulů k sobě.
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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

  driver_seg_4 : entity work.driver_7seg_4digits
      port map(
          clk        => CLK100MHZ,
          reset      => BTNC,
          data0_i => s_cnt_os,
          
          data1_i => s_cnt_oss,
        
          data2_i => s_cnt_om,--s_cnt_om,          
         
          data3_i => s_cnt_omm,
          
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
  
AN(7 downto 6) <= b"11";
end architecture Behavioral;
```
<a name="video"></a>

## Video

Write your text here

<a name="references"></a>

## References

1. Nexis A7 board popis: digilentinc.com [online]. [Arty A7](https://reference.digilentinc.com/reference/programmable-logic/arty-a7/reference-manual) 
