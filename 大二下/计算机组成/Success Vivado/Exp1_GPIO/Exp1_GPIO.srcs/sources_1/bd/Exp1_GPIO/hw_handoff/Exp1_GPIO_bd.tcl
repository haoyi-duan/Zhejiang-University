
################################################################
# This is a generated script based on design: Exp1_GPIO
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source Exp1_GPIO_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7k160tffg676-2L
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name Exp1_GPIO

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: clk
proc create_hier_cell_clk { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_clk() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O CPUClk
  create_bd_pin -dir O DIVO10
  create_bd_pin -dir O -from 1 -to 0 DIVO18T19
  create_bd_pin -dir O DIVO20
  create_bd_pin -dir O DIVO25
  create_bd_pin -dir I STEP
  create_bd_pin -dir I -type clk clk_100mhz
  create_bd_pin -dir O -from 31 -to 0 clkdiv
  create_bd_pin -dir O nCPUClk
  create_bd_pin -dir I -type rst rst

  # Create instance: DIVTap, and set properties
  set DIVTap [ create_bd_cell -type ip -vlnv ZJUCLIP:user:DIVO:1.0 DIVTap ]

  # Create instance: U8, and set properties
  set U8 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:Clkdiv:1.0 U8 ]

  # Create port connections
  connect_bd_net -net DIVTap_DIVO10 [get_bd_pins DIVO10] [get_bd_pins DIVTap/DIVO10]
  connect_bd_net -net DIVTap_DIVO18T19 [get_bd_pins DIVO18T19] [get_bd_pins DIVTap/DIVO18T19]
  connect_bd_net -net DIVTap_DIVO20 [get_bd_pins DIVO20] [get_bd_pins DIVTap/DIVO20]
  connect_bd_net -net DIVTap_DIVO25 [get_bd_pins DIVO25] [get_bd_pins DIVTap/DIVO25]
  connect_bd_net -net STEP_0_1 [get_bd_pins STEP] [get_bd_pins U8/STEP]
  connect_bd_net -net U8_CPUClk [get_bd_pins CPUClk] [get_bd_pins U8/CPUClk]
  connect_bd_net -net U8_clkdiv [get_bd_pins clkdiv] [get_bd_pins DIVTap/DIV] [get_bd_pins U8/clkdiv]
  connect_bd_net -net U8_nCPUClk [get_bd_pins nCPUClk] [get_bd_pins U8/nCPUClk]
  connect_bd_net -net clk_0_2 [get_bd_pins clk_100mhz] [get_bd_pins U8/clk]
  connect_bd_net -net rst_0_1 [get_bd_pins rst] [get_bd_pins U8/rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: RAM
proc create_hier_cell_RAM { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_RAM() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTA_0

  # Create pins
  create_bd_pin -dir O -from 31 -to 0 Dout
  create_bd_pin -dir I -from 9 -to 0 addra
  create_bd_pin -dir I -from 0 -to 0 clk_100mhz
  create_bd_pin -dir I -from 31 -to 0 dina
  create_bd_pin -dir I -from 0 -to 0 wea

  # Create instance: RAM_B, and set properties
  set RAM_B [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 RAM_B ]
  set_property -dict [ list \
   CONFIG.Byte_Size {9} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {1024} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $RAM_B

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create interface connections
  connect_bd_intf_net -intf_net BRAM_PORTA_0_1 [get_bd_intf_pins BRAM_PORTA_0] [get_bd_intf_pins RAM_B/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net Op1_0_1 [get_bd_pins clk_100mhz] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net RAM_B_douta [get_bd_pins Dout] [get_bd_pins RAM_B/douta]
  connect_bd_net -net addra_0_1 [get_bd_pins addra] [get_bd_pins RAM_B/addra]
  connect_bd_net -net dina_0_1 [get_bd_pins dina] [get_bd_pins RAM_B/dina]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins RAM_B/clka] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net wea_0_1 [get_bd_pins wea] [get_bd_pins RAM_B/wea]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: GPIO
proc create_hier_cell_GPIO { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_GPIO() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I EN
  create_bd_pin -dir O -from 23 -to 0 GPIOf0_0
  create_bd_pin -dir O -from 7 -to 0 LED
  create_bd_pin -dir O LEDCK
  create_bd_pin -dir O LEDCR
  create_bd_pin -dir O LEDDT
  create_bd_pin -dir O LEDEN
  create_bd_pin -dir I -from 31 -to 0 PData
  create_bd_pin -dir I Start
  create_bd_pin -dir I -type clk clk_100mhz
  create_bd_pin -dir I rst

  # Create instance: U7, and set properties
  set U7 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:GPIO:1.0 U7 ]

  # Create instance: U71, and set properties
  set U71 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:PIO:1.0 U71 ]

  # Create port connections
  connect_bd_net -net EN_0_2 [get_bd_pins EN] [get_bd_pins U7/EN] [get_bd_pins U71/EN]
  connect_bd_net -net PData_0_1 [get_bd_pins PData] [get_bd_pins U7/PData] [get_bd_pins U71/PData]
  connect_bd_net -net Start_0_1 [get_bd_pins Start] [get_bd_pins U7/Start]
  connect_bd_net -net U71_GPIOf0 [get_bd_pins GPIOf0_0] [get_bd_pins U71/GPIOf0]
  connect_bd_net -net U71_LED [get_bd_pins LED] [get_bd_pins U71/LED]
  connect_bd_net -net U7_LEDEN [get_bd_pins LEDEN] [get_bd_pins U7/LEDEN]
  connect_bd_net -net U7_ledclk [get_bd_pins LEDCK] [get_bd_pins U7/ledclk]
  connect_bd_net -net U7_ledclrn [get_bd_pins LEDCR] [get_bd_pins U7/ledclrn]
  connect_bd_net -net U7_ledsout [get_bd_pins LEDDT] [get_bd_pins U7/ledsout]
  connect_bd_net -net clk_0_2 [get_bd_pins clk_100mhz] [get_bd_pins U7/clk] [get_bd_pins U71/clk]
  connect_bd_net -net rst_0_1 [get_bd_pins rst] [get_bd_pins U7/rst] [get_bd_pins U71/rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Display
proc create_hier_cell_Display { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_Display() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 3 -to 0 AN
  create_bd_pin -dir I -from 31 -to 0 Data0
  create_bd_pin -dir I EN
  create_bd_pin -dir I -from 63 -to 0 LES
  create_bd_pin -dir O SEGCLK
  create_bd_pin -dir O SEGCLR
  create_bd_pin -dir O SEGDT
  create_bd_pin -dir O SEGEN
  create_bd_pin -dir O -from 7 -to 0 SEGMENT
  create_bd_pin -dir I Scan2
  create_bd_pin -dir I -from 1 -to 0 Scan10
  create_bd_pin -dir I Start
  create_bd_pin -dir I -from 2 -to 0 Test
  create_bd_pin -dir I Text
  create_bd_pin -dir I -type clk clk_100mhz
  create_bd_pin -dir I -from 31 -to 0 data1
  create_bd_pin -dir I -from 31 -to 0 data2
  create_bd_pin -dir I -from 31 -to 0 data6
  create_bd_pin -dir I -from 31 -to 0 data7
  create_bd_pin -dir I flash
  create_bd_pin -dir I -from 63 -to 0 points
  create_bd_pin -dir I rst

  # Create instance: U5, and set properties
  set U5 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:DSEGIO:1.0 U5 ]

  # Create instance: U6, and set properties
  set U6 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:Display:1.0 U6 ]

  # Create instance: U61, and set properties
  set U61 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:Disp2Hex:1.0 U61 ]

  # Create port connections
  connect_bd_net -net Data0_0_1 [get_bd_pins Data0] [get_bd_pins U5/Data0]
  connect_bd_net -net EN_0_1 [get_bd_pins EN] [get_bd_pins U5/EN]
  connect_bd_net -net LES_0_1 [get_bd_pins LES] [get_bd_pins U5/LES]
  connect_bd_net -net Scan10_0_1 [get_bd_pins Scan10] [get_bd_pins U61/Scan10]
  connect_bd_net -net Scan2 [get_bd_pins Scan2] [get_bd_pins U61/Scan2]
  connect_bd_net -net Start_0_1 [get_bd_pins Start] [get_bd_pins U6/Start]
  connect_bd_net -net Test_0_1 [get_bd_pins Test] [get_bd_pins U5/Test]
  connect_bd_net -net Text_0_1 [get_bd_pins Text] [get_bd_pins U6/Text] [get_bd_pins U61/Text]
  connect_bd_net -net U5_Disp [get_bd_pins U5/Disp] [get_bd_pins U6/Hexs] [get_bd_pins U61/Hexs]
  connect_bd_net -net U5_LE [get_bd_pins U5/LE] [get_bd_pins U6/LES] [get_bd_pins U61/LES]
  connect_bd_net -net U5_mapup [get_bd_pins U5/mapup] [get_bd_pins U6/mapup]
  connect_bd_net -net U5_point [get_bd_pins U5/point] [get_bd_pins U6/points] [get_bd_pins U61/points]
  connect_bd_net -net U61_AN [get_bd_pins AN] [get_bd_pins U61/AN]
  connect_bd_net -net U61_SEGMENT [get_bd_pins SEGMENT] [get_bd_pins U61/SEGMENT]
  connect_bd_net -net U6_SEGEN [get_bd_pins SEGEN] [get_bd_pins U6/SEGEN]
  connect_bd_net -net U6_segclk [get_bd_pins SEGCLK] [get_bd_pins U6/segclk]
  connect_bd_net -net U6_segclrn [get_bd_pins SEGCLR] [get_bd_pins U6/segclrn]
  connect_bd_net -net U6_segsout [get_bd_pins SEGDT] [get_bd_pins U6/segsout]
  connect_bd_net -net clk_0_2 [get_bd_pins clk_100mhz] [get_bd_pins U5/clk] [get_bd_pins U6/clk]
  connect_bd_net -net data1_0_1 [get_bd_pins data1] [get_bd_pins U5/data1]
  connect_bd_net -net data2_0_1 [get_bd_pins data2] [get_bd_pins U5/data2] [get_bd_pins U5/data3] [get_bd_pins U5/data4] [get_bd_pins U5/data5]
  connect_bd_net -net data6_0_1 [get_bd_pins data6] [get_bd_pins U5/data6]
  connect_bd_net -net data7_0_1 [get_bd_pins data7] [get_bd_pins U5/data7]
  connect_bd_net -net flash_0_1 [get_bd_pins flash] [get_bd_pins U6/flash] [get_bd_pins U61/flash]
  connect_bd_net -net points_0_1 [get_bd_pins points] [get_bd_pins U5/points]
  connect_bd_net -net rst_0_1 [get_bd_pins rst] [get_bd_pins U5/rst] [get_bd_pins U6/rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set AN [ create_bd_port -dir O -from 3 -to 0 AN ]
  set CR [ create_bd_port -dir O CR ]
  set DIVCLKO [ create_bd_port -dir O -from 31 -to 0 DIVCLKO ]
  set EN [ create_bd_port -dir I EN ]
  set KCOL [ create_bd_port -dir I -from 3 -to 0 KCOL ]
  set KROW [ create_bd_port -dir O -from 4 -to 0 KROW ]
  set LED [ create_bd_port -dir O -from 7 -to 0 LED ]
  set LEDCK [ create_bd_port -dir O LEDCK ]
  set LEDCR [ create_bd_port -dir O LEDCR ]
  set LEDDT [ create_bd_port -dir O LEDDT ]
  set LEDEN [ create_bd_port -dir O LEDEN ]
  set LES [ create_bd_port -dir I -from 63 -to 0 LES ]
  set PData [ create_bd_port -dir I -from 31 -to 0 PData ]
  set RDY [ create_bd_port -dir O RDY ]
  set RSTN [ create_bd_port -dir I RSTN ]
  set SEGCK [ create_bd_port -dir O SEGCK ]
  set SEGCR [ create_bd_port -dir O SEGCR ]
  set SEGDT [ create_bd_port -dir O SEGDT ]
  set SEGEN [ create_bd_port -dir O SEGEN ]
  set SEGMENT [ create_bd_port -dir O -from 7 -to 0 SEGMENT ]
  set SW [ create_bd_port -dir I -from 15 -to 0 SW ]
  set addr [ create_bd_port -dir I -from 9 -to 0 addr ]
  set blink [ create_bd_port -dir O -from 7 -to 0 blink ]
  set clk_100mhz [ create_bd_port -dir I -type clk clk_100mhz ]
  set points [ create_bd_port -dir I -from 63 -to 0 points ]
  set readn [ create_bd_port -dir O readn ]
  set wea [ create_bd_port -dir I -from 0 -to 0 wea ]

  # Create instance: Display
  create_hier_cell_Display [current_bd_instance .] Display

  # Create instance: GPIO
  create_hier_cell_GPIO [current_bd_instance .] GPIO

  # Create instance: M4, and set properties
  set M4 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:EnterT32:1.0 M4 ]

  # Create instance: RAM
  create_hier_cell_RAM [current_bd_instance .] RAM

  # Create instance: ROM_D, and set properties
  set ROM_D [ create_bd_cell -type ip -vlnv xilinx.com:ip:dist_mem_gen:8.0 ROM_D ]
  set_property -dict [ list \
   CONFIG.coefficient_file {../../../../../../ROM.coe} \
   CONFIG.data_width {32} \
   CONFIG.depth {1024} \
   CONFIG.memory_type {rom} \
 ] $ROM_D

  # Create instance: SWTap, and set properties
  set SWTap [ create_bd_cell -type ip -vlnv ZJUCLIP:user:SWOUT:1.0 SWTap ]

  # Create instance: U9, and set properties
  set U9 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:Arraykeys:1.0 U9 ]

  # Create instance: clk
  create_hier_cell_clk [current_bd_instance .] clk

  # Create port connections
  connect_bd_net -net EN_0_1 [get_bd_ports EN] [get_bd_pins Display/EN] [get_bd_pins GPIO/EN]
  connect_bd_net -net KCOL_0_1 [get_bd_ports KCOL] [get_bd_pins U9/KCOL]
  connect_bd_net -net LES_0_1 [get_bd_ports LES] [get_bd_pins Display/LES]
  connect_bd_net -net M4_Ai [get_bd_pins Display/Data0] [get_bd_pins M4/Ai]
  connect_bd_net -net M4_Bi [get_bd_pins Display/data1] [get_bd_pins M4/Bi]
  connect_bd_net -net M4_blink [get_bd_ports blink] [get_bd_pins M4/blink]
  connect_bd_net -net M4_readn [get_bd_ports readn] [get_bd_pins M4/readn] [get_bd_pins U9/readn]
  connect_bd_net -net PData_0_1 [get_bd_ports PData] [get_bd_pins GPIO/PData]
  connect_bd_net -net RAM_Dout [get_bd_pins Display/data7] [get_bd_pins RAM/Dout]
  connect_bd_net -net RSTN_0_1 [get_bd_ports RSTN] [get_bd_pins U9/RSTN]
  connect_bd_net -net STEP_1 [get_bd_pins SWTap/SWO2] [get_bd_pins clk/STEP]
  connect_bd_net -net SWOUT_0_SWO0 [get_bd_pins Display/Text] [get_bd_pins M4/Text] [get_bd_pins SWTap/SWO0]
  connect_bd_net -net SWOUT_0_SWO1 [get_bd_pins Display/Scan2] [get_bd_pins M4/UP16] [get_bd_pins SWTap/SWO1]
  connect_bd_net -net SWOUT_0_SWO15 [get_bd_pins M4/ArrayKey] [get_bd_pins SWTap/SWO15]
  connect_bd_net -net SWOUT_0_SWO765 [get_bd_pins Display/Test] [get_bd_pins M4/TEST] [get_bd_pins SWTap/SWO765]
  connect_bd_net -net SW_0_1 [get_bd_ports SW] [get_bd_pins U9/SW]
  connect_bd_net -net Scan10_1 [get_bd_pins Display/Scan10] [get_bd_pins clk/DIVO18T19]
  connect_bd_net -net Start_1 [get_bd_pins Display/Start] [get_bd_pins GPIO/Start] [get_bd_pins clk/DIVO10]
  connect_bd_net -net U61_AN [get_bd_ports AN] [get_bd_pins Display/AN]
  connect_bd_net -net U61_SEGMENT [get_bd_ports SEGMENT] [get_bd_pins Display/SEGMENT]
  connect_bd_net -net U6_SEGEN [get_bd_ports SEGEN] [get_bd_pins Display/SEGEN]
  connect_bd_net -net U6_segclk [get_bd_ports SEGCK] [get_bd_pins Display/SEGCLK]
  connect_bd_net -net U6_segclrn [get_bd_ports SEGCR] [get_bd_pins Display/SEGCLR]
  connect_bd_net -net U6_segsout [get_bd_ports SEGDT] [get_bd_pins Display/SEGDT]
  connect_bd_net -net U71_LED [get_bd_ports LED] [get_bd_pins GPIO/LED]
  connect_bd_net -net U7_LEDEN [get_bd_ports LEDEN] [get_bd_pins GPIO/LEDEN]
  connect_bd_net -net U7_ledclk [get_bd_ports LEDCK] [get_bd_pins GPIO/LEDCK]
  connect_bd_net -net U7_ledclrn [get_bd_ports LEDCR] [get_bd_pins GPIO/LEDCR]
  connect_bd_net -net U7_ledsout [get_bd_ports LEDDT] [get_bd_pins GPIO/LEDDT]
  connect_bd_net -net U9_BTNO [get_bd_pins M4/BTN] [get_bd_pins U9/BTNO]
  connect_bd_net -net U9_CR [get_bd_ports CR] [get_bd_pins U9/CR]
  connect_bd_net -net U9_KCODE [get_bd_pins M4/Din] [get_bd_pins U9/KCODE]
  connect_bd_net -net U9_KRDY [get_bd_ports RDY] [get_bd_pins M4/DRDY] [get_bd_pins U9/KRDY]
  connect_bd_net -net U9_KROW [get_bd_ports KROW] [get_bd_pins U9/KROW]
  connect_bd_net -net U9_SWO [get_bd_pins SWTap/SWI] [get_bd_pins U9/SWO]
  connect_bd_net -net addra_0_1 [get_bd_ports addr] [get_bd_pins RAM/addra] [get_bd_pins ROM_D/a]
  connect_bd_net -net clk_0_1 [get_bd_ports clk_100mhz] [get_bd_pins Display/clk_100mhz] [get_bd_pins GPIO/clk_100mhz] [get_bd_pins M4/clk] [get_bd_pins RAM/clk_100mhz] [get_bd_pins U9/clk] [get_bd_pins clk/clk_100mhz]
  connect_bd_net -net clk_DIVO25 [get_bd_pins Display/flash] [get_bd_pins clk/DIVO25]
  connect_bd_net -net clk_clkdiv [get_bd_ports DIVCLKO] [get_bd_pins Display/data2] [get_bd_pins clk/clkdiv]
  connect_bd_net -net dina_1 [get_bd_pins Display/data6] [get_bd_pins RAM/dina] [get_bd_pins ROM_D/spo]
  connect_bd_net -net points_0_1 [get_bd_ports points] [get_bd_pins Display/points]
  connect_bd_net -net rst_1 [get_bd_pins Display/rst] [get_bd_pins GPIO/rst] [get_bd_pins U9/rst] [get_bd_pins clk/rst]
  connect_bd_net -net wea_0_1 [get_bd_ports wea] [get_bd_pins RAM/wea]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


