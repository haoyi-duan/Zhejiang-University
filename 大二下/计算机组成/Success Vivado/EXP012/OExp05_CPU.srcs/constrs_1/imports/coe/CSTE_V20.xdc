#系统时钟
set_property -dict {PACKAGE_PIN AC18 IOSTANDARD LVCMOS18} [get_ports clk_100mhz]

#Reset or CR
set_property -dict {PACKAGE_PIN W13  IOSTANDARD LVCMOS18} [get_ports RSTN]

#SWORD LED：LED同步串行接口
set_property -dict {PACKAGE_PIN N26  IOSTANDARD LVCMOS33} [get_ports LEDCK]   
set_property -dict {PACKAGE_PIN N24  IOSTANDARD LVCMOS33} [get_ports LEDCR]
set_property -dict {PACKAGE_PIN M26  IOSTANDARD LVCMOS33} [get_ports LEDDT]
set_property -dict {PACKAGE_PIN P18  IOSTANDARD LVCMOS33} [get_ports LEDEN]
 
#SWORD SEG：七段码同步串行接口
set_property -dict {PACKAGE_PIN M24  IOSTANDARD LVCMOS33} [get_ports SEGCK]
set_property -dict {PACKAGE_PIN M20  IOSTANDARD LVCMOS33} [get_ports SEGCR]
set_property -dict {PACKAGE_PIN L24  IOSTANDARD LVCMOS33} [get_ports SEGDT]
set_property -dict {PACKAGE_PIN R18  IOSTANDARD LVCMOS33} [get_ports SEGEN]

#Tri-LED：三色指示灯       #LEDR0  #LEDG0 #LEDR0
set_property -dict {PACKAGE_PIN U22  IOSTANDARD LVCMOS33} [get_ports readn]
set_property -dict {PACKAGE_PIN V22  IOSTANDARD LVCMOS33} [get_ports CR]   
set_property -dict {PACKAGE_PIN U21  IOSTANDARD LVCMOS33} [get_ports RDY]   
#set_property -dict {PACKAGE_PIN U24  IOSTANDARD LVCMOS33} [get_ports LEDR1]
#set_property -dict {PACKAGE_PIN U25  IOSTANDARD LVCMOS33} [get_ports LEDG1]
#set_property -dict {PACKAGE_PIN V23  IOSTANDARD LVCMOS33} [get_ports LEDB1]
                                     
#Arraykeys：阵列键盘-行
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS18} [get_ports {KCOL[0]}]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS18} [get_ports {KCOL[1]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS18} [get_ports {KCOL[2]}]
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS18} [get_ports {KCOL[3]}]
#Arraykeys：阵列键盘-列
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {KROW[0]}] 
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {KROW[1]}]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {KROW[2]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {KROW[3]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS18 PULLUP true} [get_ports {KROW[4]}]
  
#SWitch：滑动开关                                     
set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS15} [get_ports {SW[0]}]
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS15} [get_ports {SW[1]}]
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS15} [get_ports {SW[2]}]
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS15} [get_ports {SW[3]}]
set_property -dict {PACKAGE_PIN Y13  IOSTANDARD LVCMOS15} [get_ports {SW[4]}]
set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS15} [get_ports {SW[5]}]
set_property -dict {PACKAGE_PIN AD11 IOSTANDARD LVCMOS15} [get_ports {SW[6]}]
set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS15} [get_ports {SW[7]}]
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS15} [get_ports {SW[8]}]
set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVCMOS15} [get_ports {SW[9]}]
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS15} [get_ports {SW[10]}]
set_property -dict {PACKAGE_PIN AE8  IOSTANDARD LVCMOS15} [get_ports {SW[11]}]
set_property -dict {PACKAGE_PIN AF8  IOSTANDARD LVCMOS15} [get_ports {SW[12]}]
set_property -dict {PACKAGE_PIN AE13 IOSTANDARD LVCMOS15} [get_ports {SW[13]}]
set_property -dict {PACKAGE_PIN AF13 IOSTANDARD LVCMOS15} [get_ports {SW[14]}]
set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVCMOS15} [get_ports {SW[15]}]
             
#PS2 Key：PS2标准同步串行接口
#set_property -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS33 PULLUP true} [get_ports PS2D]
#set_property -dict {PACKAGE_PIN N18  IOSTANDARD LVCMOS33 PULLUP true} [get_ports PS2C]

#UART：异步串行接口
#set_property -dict {PACKAGE_PIN L25 IOSTANDARD LVCMOS33 PULLUP true} [get_ports RXD]
#set_property -dict {PACKAGE_PIN P24 IOSTANDARD LVCMOS33 DRIVE 16 SLEW FAST PULLUP true} [get_ports TXD]


#VGA
set_property -dict {PACKAGE_PIN N21  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {Red[0]}]
set_property -dict {PACKAGE_PIN N22  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {Red[1]}]
set_property -dict {PACKAGE_PIN R21  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {Red[2]}]
set_property -dict {PACKAGE_PIN P21  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {Red[3]}]
set_property -dict {PACKAGE_PIN R22  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {Green[0]}]
set_property -dict {PACKAGE_PIN R23  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {Green[1]}]
set_property -dict {PACKAGE_PIN T24  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {Green[2]}]
set_property -dict {PACKAGE_PIN T25  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {Green[3]}]
set_property -dict {PACKAGE_PIN T20  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {Blue[0]}]
set_property -dict {PACKAGE_PIN R20  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {Blue[1]}]
set_property -dict {PACKAGE_PIN T22  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {Blue[2]}]
set_property -dict {PACKAGE_PIN T23  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {Blue[3]}]
set_property -dict {PACKAGE_PIN M22  IOSTANDARD LVCMOS33 SLEW FAST}  [get_ports HSYNC]
set_property -dict {PACKAGE_PIN M21  IOSTANDARD LVCMOS33 SLEW FAST}  [get_ports VSYNC]

#######################################################
#ArDUNIO-IO for LED
set_property -dict {PACKAGE_PIN AF24 IOSTANDARD LVCMOS33} [get_ports {LED[0]}]
set_property -dict {PACKAGE_PIN AE21 IOSTANDARD LVCMOS33} [get_ports {LED[1]}]
set_property -dict {PACKAGE_PIN Y22  IOSTANDARD LVCMOS33} [get_ports {LED[2]}]
set_property -dict {PACKAGE_PIN Y23  IOSTANDARD LVCMOS33} [get_ports {LED[3]}]
set_property -dict {PACKAGE_PIN AA23 IOSTANDARD LVCMOS33} [get_ports {LED[4]}]
set_property -dict {PACKAGE_PIN Y25  IOSTANDARD LVCMOS33} [get_ports {LED[5]}]
set_property -dict {PACKAGE_PIN AB26 IOSTANDARD LVCMOS33} [get_ports {LED[6]}]
set_property -dict {PACKAGE_PIN W23  IOSTANDARD LVCMOS33} [get_ports {LED[7]}]



#Arduino for Buzzer
set_property -dict {PACKAGE_PIN AF25 IOSTANDARD LVCMOS33} [get_ports Buzzer]

##ArDUNIO-IO for SEG
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports {SEGMENT[0]}]
set_property -dict {PACKAGE_PIN AD24 IOSTANDARD LVCMOS33} [get_ports {SEGMENT[1]}]
set_property -dict {PACKAGE_PIN AD23 IOSTANDARD LVCMOS33} [get_ports {SEGMENT[2]}]
set_property -dict {PACKAGE_PIN Y21  IOSTANDARD LVCMOS33} [get_ports {SEGMENT[3]}]
set_property -dict {PACKAGE_PIN W20  IOSTANDARD LVCMOS33} [get_ports {SEGMENT[4]}]
set_property -dict {PACKAGE_PIN AC24 IOSTANDARD LVCMOS33} [get_ports {SEGMENT[5]}]
set_property -dict {PACKAGE_PIN AC23 IOSTANDARD LVCMOS33} [get_ports {SEGMENT[6]}]
set_property -dict {PACKAGE_PIN AA22 IOSTANDARD LVCMOS33} [get_ports {SEGMENT[7]}]

set_property -dict {PACKAGE_PIN AD21 IOSTANDARD LVCMOS33} [get_ports {AN[0]}]
set_property -dict {PACKAGE_PIN AC21 IOSTANDARD LVCMOS33} [get_ports {AN[1]}]
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports {AN[2]}]
set_property -dict {PACKAGE_PIN AC22 IOSTANDARD LVCMOS33} [get_ports {AN[3]}]

###################################

#SD
#set_property -dict {PACKAGE_PIN AF23 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports sdClk]
#set_property -dict {PACKAGE_PIN AD25 IOSTANDARD LVCMOS33 SLEW FAST PULLUP true} [get_ports sdCmd]
#set_property -dict {PACKAGE_PIN AE25 IOSTANDARD LVCMOS33 SLEW FAST PULLUP true} [get_ports {sdDat[0]}]
#set_property -dict {PACKAGE_PIN AE22 IOSTANDARD LVCMOS33 SLEW FAST PULLUP true} [get_ports {sdDat[1]}]
#set_property -dict {PACKAGE_PIN AF22 IOSTANDARD LVCMOS33 SLEW FAST PULLUP true} [get_ports {sdDat[2]}]
#set_property -dict {PACKAGE_PIN Y20  IOSTANDARD LVCMOS33 SLEW FAST PULLUP true} [get_ports {sdDat[3]}]
#set_property -dict {PACKAGE_PIN AE26 IOSTANDARD LVCMOS33} [get_ports sdCd]
#set_property -dict {PACKAGE_PIN AE23 IOSTANDARD LVCMOS33} [get_ports sdRst]

#Old Arduino
#set_property -dict {PACKAGE_PIN AF24 IOSTANDARD LVCMOS33} [get_ports {LED[7]}]
#set_property -dict {PACKAGE_PIN AE21 IOSTANDARD LVCMOS33} [get_ports {LED[6]}]
#set_property -dict {PACKAGE_PIN Y22  IOSTANDARD LVCMOS33} [get_ports {LED[5]}]
#set_property -dict {PACKAGE_PIN Y23  IOSTANDARD LVCMOS33} [get_ports {LED[4]}]
#set_property -dict {PACKAGE_PIN AA23 IOSTANDARD LVCMOS33} [get_ports {LED[3]}]
#set_property -dict {PACKAGE_PIN Y25  IOSTANDARD LVCMOS33} [get_ports {LED[2]}]
#set_property -dict {PACKAGE_PIN AB26 IOSTANDARD LVCMOS33} [get_ports {LED[1]}]
#set_property -dict {PACKAGE_PIN W23  IOSTANDARD LVCMOS33} [get_ports {LED[0]}]

#set_property -dict {PACKAGE_PIN AA22 IOSTANDARD LVCMOS33} [get_ports {segment[7]}]
#set_property -dict {PACKAGE_PIN AC23 IOSTANDARD LVCMOS33} [get_ports {segment[6]}]
#set_property -dict {PACKAGE_PIN AC24 IOSTANDARD LVCMOS33} [get_ports {segment[5]}]
#set_property -dict {PACKAGE_PIN W20  IOSTANDARD LVCMOS33} [get_ports {segment[4]}]
#set_property -dict {PACKAGE_PIN Y21  IOSTANDARD LVCMOS33} [get_ports {segment[3]}]
#set_property -dict {PACKAGE_PIN AD23 IOSTANDARD LVCMOS33} [get_ports {segment[2]}]
#set_property -dict {PACKAGE_PIN AD24 IOSTANDARD LVCMOS33} [get_ports {segment[1]}]
#set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports {segment[0]}]

#set_property -dict {PACKAGE_PIN F10 IOSTANDARD LVCMOS33} [get_ports {anode[3]}]
#set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVCMOS33} [get_ports {anode[2]}]
#set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports {anode[1]}]
#set_property -dict {PACKAGE_PIN AC22 IOSTANDARD LVCMOS33} [get_ports {anode[0]}]
#set_property -dict {PACKAGE_PIN AF24 IOSTANDARD LVCMOS33} [get_ports buzzer]

             