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
## This file is a general .xdc for the Nexys A7-50T
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

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

Write your text here.
![git](images/simulation-digital-clock.png)
<a name="top"></a>

## TOP module description and simulations

Write your text here.

<a name="video"></a>

## Video

Write your text here

<a name="references"></a>

## References

1. Nexis A7 board popis: digilentinc.com [online]. [Arty A7](https://reference.digilentinc.com/reference/programmable-logic/arty-a7/reference-manual) 
