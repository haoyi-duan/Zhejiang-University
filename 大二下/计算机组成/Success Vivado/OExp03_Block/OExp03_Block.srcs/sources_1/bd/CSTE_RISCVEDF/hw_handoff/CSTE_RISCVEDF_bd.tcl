
################################################################
# This is a generated script based on design: CSTE_RISCVEDF
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
# source CSTE_RISCVEDF_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7k160tffg676-2L
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name CSTE_RISCVEDF

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


# Hierarchical cell: MEMARYBLOCK
proc create_hier_cell_MEMARYBLOCK { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_MEMARYBLOCK() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 31 -to 0 MEM_Addr
  create_bd_pin -dir O -from 31 -to 0 MEM_Data
  create_bd_pin -dir I MIO
  create_bd_pin -dir I -from 31 -to 0 PCin
  create_bd_pin -dir I -from 31 -to 0 RAMADDR
  create_bd_pin -dir I SWO13
  create_bd_pin -dir I -from 9 -to 0 addra
  create_bd_pin -dir I -type clk clka
  create_bd_pin -dir I -from 31 -to 0 dina
  create_bd_pin -dir O -from 31 -to 0 douta
  create_bd_pin -dir O -from 31 -to 0 spo
  create_bd_pin -dir I -from 0 -to 0 wea

  # Create instance: MEMTEST_0, and set properties
  set MEMTEST_0 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:MEMTEST:1.0 MEMTEST_0 ]

  # Create instance: PCWA, and set properties
  set PCWA [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 PCWA ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {10} \
 ] $PCWA

  # Create instance: U2, and set properties
  set U2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dist_mem_gen:8.0 U2 ]
  set_property -dict [ list \
   CONFIG.coefficient_file {../../../../../../RISCV-DEMO9.coe} \
   CONFIG.data_width {32} \
   CONFIG.depth {1024} \
   CONFIG.memory_type {rom} \
 ] $U2

  # Create instance: U3, and set properties
  set U3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 U3 ]
  set_property -dict [ list \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../D_mem.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {1024} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $U3

  # Create port connections
  connect_bd_net -net Din_0_1 [get_bd_pins PCin] [get_bd_pins MEMTEST_0/ROMADDR] [get_bd_pins PCWA/Din]
  connect_bd_net -net MEMTEST_0_MEM_Addr [get_bd_pins MEM_Addr] [get_bd_pins MEMTEST_0/MEM_Addr]
  connect_bd_net -net MEMTEST_0_MEM_Data [get_bd_pins MEM_Data] [get_bd_pins MEMTEST_0/MEM_Data]
  connect_bd_net -net MIO_0_1 [get_bd_pins MIO] [get_bd_pins MEMTEST_0/MIO]
  connect_bd_net -net RAMADDR_0_1 [get_bd_pins RAMADDR] [get_bd_pins MEMTEST_0/RAMADDR]
  connect_bd_net -net SWO13_1_1 [get_bd_pins SWO13] [get_bd_pins MEMTEST_0/SWO13]
  connect_bd_net -net U2_spo [get_bd_pins spo] [get_bd_pins MEMTEST_0/ROMData] [get_bd_pins U2/spo]
  connect_bd_net -net U3_douta [get_bd_pins douta] [get_bd_pins MEMTEST_0/RAMData] [get_bd_pins U3/douta]
  connect_bd_net -net addra_0_1 [get_bd_pins addra] [get_bd_pins U3/addra]
  connect_bd_net -net clka_0_1 [get_bd_pins clka] [get_bd_pins U3/clka]
  connect_bd_net -net dina_0_1 [get_bd_pins dina] [get_bd_pins U3/dina]
  connect_bd_net -net wea_0_1 [get_bd_pins wea] [get_bd_pins U3/wea]
  connect_bd_net -net xlslice_0_Dout1 [get_bd_pins PCWA/Dout] [get_bd_pins U2/a]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: GPIOBLOCK
proc create_hier_cell_GPIOBLOCK { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_GPIOBLOCK() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 1 -to 0 Dout
  create_bd_pin -dir I EN_0
  create_bd_pin -dir O -from 7 -to 0 LED
  create_bd_pin -dir O LEDCK
  create_bd_pin -dir O LEDCR
  create_bd_pin -dir O LEDDT
  create_bd_pin -dir O LEDEN
  create_bd_pin -dir I -from 31 -to 0 PData
  create_bd_pin -dir I Start
  create_bd_pin -dir I clk1
  create_bd_pin -dir I rst_2

  # Create instance: U7, and set properties
  set U7 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:GPIO:1.0 U7 ]

  # Create instance: U71, and set properties
  set U71 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:PIO:1.0 U71 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {2} \
 ] $xlslice_0

  # Create port connections
  connect_bd_net -net Datai_0_1 [get_bd_pins PData] [get_bd_pins U7/Datai] [get_bd_pins U71/Datai]
  connect_bd_net -net EN_0_2 [get_bd_pins EN_0] [get_bd_pins U7/EN] [get_bd_pins U71/EN]
  connect_bd_net -net Start_0_1 [get_bd_pins Start] [get_bd_pins U7/Start]
  connect_bd_net -net U71_LED [get_bd_pins LED] [get_bd_pins U71/LED]
  connect_bd_net -net U7_GPIOf0 [get_bd_pins U7/GPIOf0] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net U7_LEDEN [get_bd_pins LEDEN] [get_bd_pins U7/LEDEN]
  connect_bd_net -net U7_ledclk [get_bd_pins LEDCK] [get_bd_pins U7/ledclk]
  connect_bd_net -net U7_ledclrn [get_bd_pins LEDCR] [get_bd_pins U7/ledclrn]
  connect_bd_net -net U7_ledsout [get_bd_pins LEDDT] [get_bd_pins U7/ledsout]
  connect_bd_net -net clk_1_3 [get_bd_pins clk1] [get_bd_pins U7/clk] [get_bd_pins U71/clk]
  connect_bd_net -net rst_2_1 [get_bd_pins rst_2] [get_bd_pins U7/rst] [get_bd_pins U71/rst]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins Dout] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DISPBLOCK
proc create_hier_cell_DISPBLOCK { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_DISPBLOCK() - Empty argument(s)!"}
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
  create_bd_pin -dir I A0
  create_bd_pin -dir O -from 3 -to 0 AN
  create_bd_pin -dir I -from 31 -to 0 Data0
  create_bd_pin -dir I EN
  create_bd_pin -dir I IO_clk
  create_bd_pin -dir I -from 63 -to 0 LES_0
  create_bd_pin -dir O SEGCK
  create_bd_pin -dir O SEGCR
  create_bd_pin -dir O SEGDT
  create_bd_pin -dir O SEGEN
  create_bd_pin -dir O -from 7 -to 0 SEGMENT
  create_bd_pin -dir I Scan2
  create_bd_pin -dir I -from 1 -to 0 Scan10
  create_bd_pin -dir I -from 2 -to 0 Test
  create_bd_pin -dir I Text
  create_bd_pin -dir I -type clk clk_100mhz_2
  create_bd_pin -dir I -from 31 -to 0 data1
  create_bd_pin -dir I -from 31 -to 0 data2
  create_bd_pin -dir I -from 31 -to 0 data3
  create_bd_pin -dir I -from 31 -to 0 data4
  create_bd_pin -dir I -from 31 -to 0 data5
  create_bd_pin -dir I -from 31 -to 0 data6
  create_bd_pin -dir I -from 31 -to 0 data7
  create_bd_pin -dir I flash
  create_bd_pin -dir I map2up
  create_bd_pin -dir I -from 63 -to 0 points_0
  create_bd_pin -dir I rst_1

  # Create instance: U5, and set properties
  set U5 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:DSEGIO:1.0 U5 ]

  # Create instance: U6, and set properties
  set U6 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:Display:1.0 U6 ]

  # Create instance: U61, and set properties
  set U61 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:Disp2Hex:1.0 U61 ]

  # Create port connections
  connect_bd_net -net A0_0_1 [get_bd_pins A0] [get_bd_pins U5/A0]
  connect_bd_net -net Data0_0_1 [get_bd_pins Data0] [get_bd_pins U5/Data0]
  connect_bd_net -net EN_0_1 [get_bd_pins EN] [get_bd_pins U5/EN]
  connect_bd_net -net LES_0_1 [get_bd_pins LES_0] [get_bd_pins U5/LES]
  connect_bd_net -net Scan10_0_1 [get_bd_pins Scan10] [get_bd_pins U61/Scan10]
  connect_bd_net -net Scan2 [get_bd_pins Scan2] [get_bd_pins U61/Scan2]
  connect_bd_net -net Test_0_1 [get_bd_pins Test] [get_bd_pins U5/Test]
  connect_bd_net -net Text_0_1 [get_bd_pins Text] [get_bd_pins U6/Text] [get_bd_pins U61/Text]
  connect_bd_net -net U5_Disp [get_bd_pins U5/Disp] [get_bd_pins U6/Hexs] [get_bd_pins U61/Hexs]
  connect_bd_net -net U5_LE [get_bd_pins U5/LE] [get_bd_pins U6/LES] [get_bd_pins U61/LES]
  connect_bd_net -net U5_mapup [get_bd_pins U5/mapup] [get_bd_pins U6/mapup]
  connect_bd_net -net U5_point [get_bd_pins U5/point] [get_bd_pins U6/points] [get_bd_pins U61/points]
  connect_bd_net -net U61_AN [get_bd_pins AN] [get_bd_pins U61/AN]
  connect_bd_net -net U61_SEGMENT [get_bd_pins SEGMENT] [get_bd_pins U61/SEGMENT]
  connect_bd_net -net U6_SEGEN [get_bd_pins SEGEN] [get_bd_pins U6/SEGEN]
  connect_bd_net -net U6_segclk [get_bd_pins SEGCK] [get_bd_pins U6/segclk]
  connect_bd_net -net U6_segclrn [get_bd_pins SEGCR] [get_bd_pins U6/segclrn]
  connect_bd_net -net U6_segsout [get_bd_pins SEGDT] [get_bd_pins U6/segsout]
  connect_bd_net -net clk_1_1 [get_bd_pins IO_clk] [get_bd_pins U5/clk]
  connect_bd_net -net clk_1_2 [get_bd_pins clk_100mhz_2] [get_bd_pins U6/clk]
  connect_bd_net -net data1_0_1 [get_bd_pins data1] [get_bd_pins U5/data1]
  connect_bd_net -net data2_0_1 [get_bd_pins data2] [get_bd_pins U5/data2]
  connect_bd_net -net data3_0_1 [get_bd_pins data3] [get_bd_pins U5/data3]
  connect_bd_net -net data4_0_1 [get_bd_pins data4] [get_bd_pins U5/data4]
  connect_bd_net -net data5_0_1 [get_bd_pins data5] [get_bd_pins U5/data5]
  connect_bd_net -net data6_0_1 [get_bd_pins data6] [get_bd_pins U5/data6]
  connect_bd_net -net data7_0_1 [get_bd_pins data7] [get_bd_pins U5/data7]
  connect_bd_net -net flash_0_1 [get_bd_pins flash] [get_bd_pins U6/flash] [get_bd_pins U61/flash]
  connect_bd_net -net map2up_0_1 [get_bd_pins map2up] [get_bd_pins U5/map2up] [get_bd_pins U6/Start]
  connect_bd_net -net points_0_1 [get_bd_pins points_0] [get_bd_pins U5/points]
  connect_bd_net -net rst_1_1 [get_bd_pins rst_1] [get_bd_pins U5/rst] [get_bd_pins U6/rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: CLKBLOCK
proc create_hier_cell_CLKBLOCK { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_CLKBLOCK() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 31 -to 0 DIV
  create_bd_pin -dir O DIVO06
  create_bd_pin -dir O DIVO08
  create_bd_pin -dir O DIVO10
  create_bd_pin -dir O DIVO12
  create_bd_pin -dir O -from 1 -to 0 DIVO18T19
  create_bd_pin -dir O DIVO20
  create_bd_pin -dir O DIVO25
  create_bd_pin -dir I STEP
  create_bd_pin -dir I -type clk clk_0
  create_bd_pin -dir O nCPUClk
  create_bd_pin -dir I -type rst rst_0

  # Create instance: DIVOTap, and set properties
  set DIVOTap [ create_bd_cell -type ip -vlnv ZJUCLIP:user:DIVO:1.0 DIVOTap ]

  # Create instance: U8, and set properties
  set U8 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:Clkdiv:1.0 U8 ]

  # Create port connections
  connect_bd_net -net DIVOTap_DIVO06 [get_bd_pins DIVO06] [get_bd_pins DIVOTap/DIVO06]
  connect_bd_net -net DIVOTap_DIVO08 [get_bd_pins DIVO08] [get_bd_pins DIVOTap/DIVO08]
  connect_bd_net -net DIVOTap_DIVO10 [get_bd_pins DIVO10] [get_bd_pins DIVOTap/DIVO10]
  connect_bd_net -net DIVOTap_DIVO12 [get_bd_pins DIVO12] [get_bd_pins DIVOTap/DIVO12]
  connect_bd_net -net DIVOTap_DIVO18T19 [get_bd_pins DIVO18T19] [get_bd_pins DIVOTap/DIVO18T19]
  connect_bd_net -net DIVOTap_DIVO20 [get_bd_pins DIVO20] [get_bd_pins DIVOTap/DIVO20]
  connect_bd_net -net DIVOTap_DIVO25 [get_bd_pins DIVO25] [get_bd_pins DIVOTap/DIVO25]
  connect_bd_net -net STEP_0_1 [get_bd_pins STEP] [get_bd_pins U8/STEP]
  connect_bd_net -net U8_CPUClk [get_bd_pins CPUClk] [get_bd_pins U8/CPUClk]
  connect_bd_net -net U8_clkdiv [get_bd_pins DIV] [get_bd_pins DIVOTap/DIV] [get_bd_pins U8/clkdiv]
  connect_bd_net -net U8_nCPUClk [get_bd_pins nCPUClk] [get_bd_pins U8/nCPUClk]
  connect_bd_net -net clk_0_2 [get_bd_pins clk_0] [get_bd_pins U8/clk]
  connect_bd_net -net rst_0_1 [get_bd_pins rst_0] [get_bd_pins U8/rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ARRAYBLOCK
proc create_hier_cell_ARRAYBLOCK { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ARRAYBLOCK() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 3 -to 0 BTN
  create_bd_pin -dir O Buzzer
  create_bd_pin -dir O CR
  create_bd_pin -dir I -from 31 -to 0 DIVO
  create_bd_pin -dir I -from 3 -to 0 KCOL
  create_bd_pin -dir O -from 4 -to 0 KROW
  create_bd_pin -dir O -from 63 -to 0 LES
  create_bd_pin -dir O ONE
  create_bd_pin -dir O RDY
  create_bd_pin -dir I RSTN
  create_bd_pin -dir O -from 15 -to 0 SWO
  create_bd_pin -dir O SWO0
  create_bd_pin -dir O SWO1
  create_bd_pin -dir O SWO13_0
  create_bd_pin -dir O SWO14_0
  create_bd_pin -dir O SWO2
  create_bd_pin -dir O -from 2 -to 0 SWO765_0
  create_bd_pin -dir I -from 15 -to 0 SW_0
  create_bd_pin -dir O ZERO
  create_bd_pin -dir O -from 7 -to 0 blink
  create_bd_pin -dir I -type clk clk_100mhz
  create_bd_pin -dir O -from 63 -to 0 points
  create_bd_pin -dir O readn
  create_bd_pin -dir O rst

  # Create instance: M4, and set properties
  set M4 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:EnterT32:1.0 M4 ]

  # Create instance: SWOTap, and set properties
  set SWOTap [ create_bd_cell -type ip -vlnv ZJUCLIP:user:SWOUT:1.0 SWOTap ]

  # Create instance: TESTOTap, and set properties
  set TESTOTap [ create_bd_cell -type ip -vlnv ZJUCLIP:user:TESTO:1.0 TESTOTap ]

  # Create instance: U9, and set properties
  set U9 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:Arraykeys:1.0 U9 ]

  # Create port connections
  connect_bd_net -net DIVO_0_1 [get_bd_pins DIVO] [get_bd_pins TESTOTap/DIVO]
  connect_bd_net -net KCOL_0_1 [get_bd_pins KCOL] [get_bd_pins U9/KCOL]
  connect_bd_net -net M4_blink [get_bd_pins blink] [get_bd_pins M4/blink] [get_bd_pins TESTOTap/blink]
  connect_bd_net -net M4_readn [get_bd_pins readn] [get_bd_pins M4/readn] [get_bd_pins U9/readn]
  connect_bd_net -net RSTN_0_1 [get_bd_pins RSTN] [get_bd_pins U9/RSTN]
  connect_bd_net -net SWOTap_SWO0 [get_bd_pins SWO0] [get_bd_pins M4/Text] [get_bd_pins SWOTap/SWO0]
  connect_bd_net -net SWOTap_SWO1 [get_bd_pins SWO1] [get_bd_pins M4/UP16] [get_bd_pins SWOTap/SWO1]
  connect_bd_net -net SWOTap_SWO2 [get_bd_pins SWO2] [get_bd_pins SWOTap/SWO2]
  connect_bd_net -net SWOTap_SWO13 [get_bd_pins SWO13_0] [get_bd_pins SWOTap/SWO13]
  connect_bd_net -net SWOTap_SWO14 [get_bd_pins SWO14_0] [get_bd_pins SWOTap/SWO14]
  connect_bd_net -net SWOTap_SWO15 [get_bd_pins M4/ArrayKey] [get_bd_pins SWOTap/SWO15]
  connect_bd_net -net SWOTap_SWO765 [get_bd_pins SWO765_0] [get_bd_pins M4/TEST] [get_bd_pins SWOTap/SWO765]
  connect_bd_net -net SW_0_1 [get_bd_pins SW_0] [get_bd_pins U9/SW]
  connect_bd_net -net TESTOTap_Buzzer [get_bd_pins Buzzer] [get_bd_pins TESTOTap/Buzzer]
  connect_bd_net -net TESTOTap_LES [get_bd_pins LES] [get_bd_pins TESTOTap/LES]
  connect_bd_net -net TESTOTap_ONE [get_bd_pins ONE] [get_bd_pins TESTOTap/ONE]
  connect_bd_net -net TESTOTap_ZERO [get_bd_pins ZERO] [get_bd_pins TESTOTap/ZERO]
  connect_bd_net -net TESTOTap_points [get_bd_pins points] [get_bd_pins TESTOTap/points]
  connect_bd_net -net U9_BTNO [get_bd_pins BTN] [get_bd_pins M4/BTN] [get_bd_pins U9/BTNO]
  connect_bd_net -net U9_CR [get_bd_pins CR] [get_bd_pins U9/CR]
  connect_bd_net -net U9_KCODE [get_bd_pins M4/Din] [get_bd_pins U9/KCODE]
  connect_bd_net -net U9_KRDY [get_bd_pins RDY] [get_bd_pins M4/DRDY] [get_bd_pins U9/KRDY]
  connect_bd_net -net U9_KROW [get_bd_pins KROW] [get_bd_pins U9/KROW]
  connect_bd_net -net U9_SWO [get_bd_pins SWO] [get_bd_pins SWOTap/SWI] [get_bd_pins TESTOTap/SWO] [get_bd_pins U9/SWO]
  connect_bd_net -net U9_rst [get_bd_pins rst] [get_bd_pins U9/rst]
  connect_bd_net -net clk_0_1 [get_bd_pins clk_100mhz] [get_bd_pins M4/clk] [get_bd_pins U9/clk]

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
  set Blue [ create_bd_port -dir O -from 3 -to 0 Blue ]
  set Buzzer [ create_bd_port -dir O Buzzer ]
  set CR [ create_bd_port -dir O CR ]
  set Green [ create_bd_port -dir O -from 3 -to 0 Green ]
  set HSYNC [ create_bd_port -dir O HSYNC ]
  set KCOL [ create_bd_port -dir I -from 3 -to 0 KCOL ]
  set KROW [ create_bd_port -dir O -from 4 -to 0 KROW ]
  set LED [ create_bd_port -dir O -from 7 -to 0 LED ]
  set LEDCK [ create_bd_port -dir O LEDCK ]
  set LEDCR [ create_bd_port -dir O LEDCR ]
  set LEDDT [ create_bd_port -dir O LEDDT ]
  set LEDEN [ create_bd_port -dir O LEDEN ]
  set RDY [ create_bd_port -dir O RDY ]
  set RSTN [ create_bd_port -dir I RSTN ]
  set Red [ create_bd_port -dir O -from 3 -to 0 Red ]
  set SEGCK [ create_bd_port -dir O SEGCK ]
  set SEGCR [ create_bd_port -dir O SEGCR ]
  set SEGDT [ create_bd_port -dir O SEGDT ]
  set SEGEN [ create_bd_port -dir O SEGEN ]
  set SEGMENT [ create_bd_port -dir O -from 7 -to 0 SEGMENT ]
  set SW [ create_bd_port -dir I -from 15 -to 0 SW ]
  set VSYNC [ create_bd_port -dir O VSYNC ]
  set clk_100mhz [ create_bd_port -dir I -type clk clk_100mhz ]
  set readn [ create_bd_port -dir O readn ]

  # Create instance: ARRAYBLOCK
  create_hier_cell_ARRAYBLOCK [current_bd_instance .] ARRAYBLOCK

  # Create instance: CLKBLOCK
  create_hier_cell_CLKBLOCK [current_bd_instance .] CLKBLOCK

  # Create instance: DISPBLOCK
  create_hier_cell_DISPBLOCK [current_bd_instance .] DISPBLOCK

  # Create instance: GPIOBLOCK
  create_hier_cell_GPIOBLOCK [current_bd_instance .] GPIOBLOCK

  # Create instance: MEMARYBLOCK
  create_hier_cell_MEMARYBLOCK [current_bd_instance .] MEMARYBLOCK

  # Create instance: U1, and set properties
  set U1 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:RSCPU9:1.0 U1 ]

  # Create instance: U4, and set properties
  set U4 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:MIOBUS:1.0 U4 ]

  # Create instance: U10, and set properties
  set U10 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:Counter:1.0 U10 ]

  # Create instance: U11, and set properties
  set U11 [ create_bd_cell -type ip -vlnv ZJUCLIP:user:VGA_TEST:1.0 U11 ]

  # Create interface connections
  connect_bd_intf_net -intf_net U1_TESTREG [get_bd_intf_pins U1/TESTREG] [get_bd_intf_pins U11/TESTREG]

  # Create port connections
  connect_bd_net -net ARRAYBLOCK_BTN [get_bd_pins ARRAYBLOCK/BTN] [get_bd_pins U4/BTN]
  connect_bd_net -net ARRAYBLOCK_LES [get_bd_pins ARRAYBLOCK/LES] [get_bd_pins DISPBLOCK/LES_0]
  connect_bd_net -net ARRAYBLOCK_SWO [get_bd_pins ARRAYBLOCK/SWO] [get_bd_pins U4/SW]
  connect_bd_net -net ARRAYBLOCK_SWO0 [get_bd_pins ARRAYBLOCK/SWO0] [get_bd_pins DISPBLOCK/Text]
  connect_bd_net -net ARRAYBLOCK_SWO1 [get_bd_pins ARRAYBLOCK/SWO1] [get_bd_pins DISPBLOCK/Scan2]
  connect_bd_net -net ARRAYBLOCK_SWO14_0 [get_bd_pins ARRAYBLOCK/SWO14_0] [get_bd_pins U11/SWO14]
  connect_bd_net -net ARRAYBLOCK_SWO2 [get_bd_pins ARRAYBLOCK/SWO2] [get_bd_pins CLKBLOCK/STEP]
  connect_bd_net -net ARRAYBLOCK_SWO765_0 [get_bd_pins ARRAYBLOCK/SWO765_0] [get_bd_pins DISPBLOCK/Test]
  connect_bd_net -net ARRAYBLOCK_blink [get_bd_pins ARRAYBLOCK/blink] [get_bd_pins U1/TNI]
  connect_bd_net -net ARRAYBLOCK_points [get_bd_pins ARRAYBLOCK/points] [get_bd_pins DISPBLOCK/points_0]
  connect_bd_net -net ARRAYBLOCK_rst [get_bd_pins ARRAYBLOCK/rst] [get_bd_pins CLKBLOCK/rst_0] [get_bd_pins DISPBLOCK/rst_1] [get_bd_pins GPIOBLOCK/rst_2] [get_bd_pins U1/reset] [get_bd_pins U10/rst] [get_bd_pins U4/rst]
  connect_bd_net -net CLKBLOCK_CPUClk [get_bd_pins CLKBLOCK/CPUClk] [get_bd_pins U1/clk]
  connect_bd_net -net CLKBLOCK_DIVO06 [get_bd_pins CLKBLOCK/DIVO06] [get_bd_pins U10/clk0]
  connect_bd_net -net CLKBLOCK_DIVO08 [get_bd_pins CLKBLOCK/DIVO08] [get_bd_pins DISPBLOCK/A0]
  connect_bd_net -net CLKBLOCK_DIVO12 [get_bd_pins CLKBLOCK/DIVO12] [get_bd_pins U10/clk2]
  connect_bd_net -net CLKBLOCK_DIVO18T19 [get_bd_pins CLKBLOCK/DIVO18T19] [get_bd_pins DISPBLOCK/Scan10]
  connect_bd_net -net CLKBLOCK_DIVO20 [get_bd_pins CLKBLOCK/DIVO20] [get_bd_pins DISPBLOCK/map2up] [get_bd_pins GPIOBLOCK/Start] [get_bd_pins U10/clk1]
  connect_bd_net -net CLKBLOCK_DIVO25 [get_bd_pins CLKBLOCK/DIVO25] [get_bd_pins DISPBLOCK/flash]
  connect_bd_net -net CLKBLOCK_nCPUClk [get_bd_pins CLKBLOCK/nCPUClk] [get_bd_pins DISPBLOCK/IO_clk] [get_bd_pins GPIOBLOCK/clk1] [get_bd_pins U4/clk]
  connect_bd_net -net KCOL_0_1 [get_bd_ports KCOL] [get_bd_pins ARRAYBLOCK/KCOL]
  connect_bd_net -net M4_readn [get_bd_ports readn] [get_bd_pins ARRAYBLOCK/readn]
  connect_bd_net -net MEMARYBLOCK_MEM_Addr [get_bd_pins MEMARYBLOCK/MEM_Addr] [get_bd_pins U11/MEM_Addr]
  connect_bd_net -net MEMARYBLOCK_MEM_Data [get_bd_pins MEMARYBLOCK/MEM_Data] [get_bd_pins U11/MEM_Data]
  connect_bd_net -net MEMARYBLOCK_douta [get_bd_pins MEMARYBLOCK/douta] [get_bd_pins U4/ram_data_out]
  connect_bd_net -net RSTN_0_1 [get_bd_ports RSTN] [get_bd_pins ARRAYBLOCK/RSTN]
  connect_bd_net -net SWO13_1 [get_bd_pins ARRAYBLOCK/SWO13_0] [get_bd_pins MEMARYBLOCK/SWO13] [get_bd_pins U11/SWO13]
  connect_bd_net -net SW_0_1 [get_bd_ports SW] [get_bd_pins ARRAYBLOCK/SW_0]
  connect_bd_net -net TESTOTap_Buzzer [get_bd_ports Buzzer] [get_bd_pins ARRAYBLOCK/Buzzer]
  connect_bd_net -net U10_Counter [get_bd_pins DISPBLOCK/data7] [get_bd_pins U10/Counter] [get_bd_pins U4/Counter]
  connect_bd_net -net U10_counter0_OUT [get_bd_pins U10/counter0_OUT] [get_bd_pins U4/C0]
  connect_bd_net -net U10_counter1_OUT [get_bd_pins U10/counter1_OUT] [get_bd_pins U4/C1]
  connect_bd_net -net U10_counter2_OUT [get_bd_pins U10/counter2_OUT] [get_bd_pins U4/C2]
  connect_bd_net -net U11_Blue [get_bd_ports Blue] [get_bd_pins U11/Blue]
  connect_bd_net -net U11_Green [get_bd_ports Green] [get_bd_pins U11/Green]
  connect_bd_net -net U11_HSYNC [get_bd_ports HSYNC] [get_bd_pins U11/HSYNC]
  connect_bd_net -net U11_Red [get_bd_ports Red] [get_bd_pins U11/Red]
  connect_bd_net -net U11_VSYNC [get_bd_ports VSYNC] [get_bd_pins U11/VSYNC]
  connect_bd_net -net U1_ALE [get_bd_pins MEMARYBLOCK/clka] [get_bd_pins U1/ALE]
  connect_bd_net -net U1_Addr [get_bd_pins DISPBLOCK/data3] [get_bd_pins MEMARYBLOCK/RAMADDR] [get_bd_pins U1/Addr] [get_bd_pins U4/Addr_bus]
  connect_bd_net -net U1_Datao [get_bd_pins DISPBLOCK/data5] [get_bd_pins U1/Datao] [get_bd_pins U4/Data4CPU]
  connect_bd_net -net U1_MIO [get_bd_pins MEMARYBLOCK/MIO] [get_bd_pins U1/MIO]
  connect_bd_net -net U1_PC [get_bd_pins DISPBLOCK/data1] [get_bd_pins MEMARYBLOCK/PCin] [get_bd_pins U1/PC]
  connect_bd_net -net U1_WR [get_bd_pins U1/WR] [get_bd_pins U4/mem_w]
  connect_bd_net -net U2_spo [get_bd_pins DISPBLOCK/data2] [get_bd_pins MEMARYBLOCK/spo] [get_bd_pins U1/INST]
  connect_bd_net -net U4_CONT_W0208 [get_bd_pins U10/counter_we] [get_bd_pins U4/CONT_W0208]
  connect_bd_net -net U4_CPU_wait [get_bd_pins U1/Ready] [get_bd_pins U4/CPU_wait]
  connect_bd_net -net U4_Data2CPU [get_bd_pins DISPBLOCK/data4] [get_bd_pins U1/Datai] [get_bd_pins U4/Data2CPU]
  connect_bd_net -net U4_GPIO_W0200 [get_bd_pins GPIOBLOCK/EN_0] [get_bd_pins U4/GPIO_W0200]
  connect_bd_net -net U4_GPIO_W0204 [get_bd_pins DISPBLOCK/EN] [get_bd_pins U4/GPIO_W0204]
  connect_bd_net -net U4_Peripheral [get_bd_pins DISPBLOCK/Data0] [get_bd_pins GPIOBLOCK/PData] [get_bd_pins U10/counter_val] [get_bd_pins U4/Peripheral]
  connect_bd_net -net U61_AN [get_bd_ports AN] [get_bd_pins DISPBLOCK/AN]
  connect_bd_net -net U61_SEGMENT [get_bd_ports SEGMENT] [get_bd_pins DISPBLOCK/SEGMENT]
  connect_bd_net -net U6_SEGEN [get_bd_ports SEGEN] [get_bd_pins DISPBLOCK/SEGEN]
  connect_bd_net -net U6_segclk [get_bd_ports SEGCK] [get_bd_pins DISPBLOCK/SEGCK]
  connect_bd_net -net U6_segclrn [get_bd_ports SEGCR] [get_bd_pins DISPBLOCK/SEGCR]
  connect_bd_net -net U6_segsout [get_bd_ports SEGDT] [get_bd_pins DISPBLOCK/SEGDT]
  connect_bd_net -net U71_LED [get_bd_ports LED] [get_bd_pins GPIOBLOCK/LED]
  connect_bd_net -net U7_LEDEN [get_bd_ports LEDEN] [get_bd_pins GPIOBLOCK/LEDEN]
  connect_bd_net -net U7_ledclk [get_bd_ports LEDCK] [get_bd_pins GPIOBLOCK/LEDCK]
  connect_bd_net -net U7_ledclrn [get_bd_ports LEDCR] [get_bd_pins GPIOBLOCK/LEDCR]
  connect_bd_net -net U7_ledsout [get_bd_ports LEDDT] [get_bd_pins GPIOBLOCK/LEDDT]
  connect_bd_net -net U8_clkdiv [get_bd_pins ARRAYBLOCK/DIVO] [get_bd_pins CLKBLOCK/DIV] [get_bd_pins DISPBLOCK/data6]
  connect_bd_net -net U9_CR [get_bd_ports CR] [get_bd_pins ARRAYBLOCK/CR]
  connect_bd_net -net U9_KRDY [get_bd_ports RDY] [get_bd_pins ARRAYBLOCK/RDY]
  connect_bd_net -net U9_KROW [get_bd_ports KROW] [get_bd_pins ARRAYBLOCK/KROW]
  connect_bd_net -net addra_1 [get_bd_pins MEMARYBLOCK/addra] [get_bd_pins U4/ram_addr]
  connect_bd_net -net clk_0_1 [get_bd_ports clk_100mhz] [get_bd_pins ARRAYBLOCK/clk_100mhz] [get_bd_pins CLKBLOCK/clk_0] [get_bd_pins DISPBLOCK/clk_100mhz_2] [get_bd_pins U10/clk] [get_bd_pins U11/clk]
  connect_bd_net -net dina_1 [get_bd_pins MEMARYBLOCK/dina] [get_bd_pins U4/ram_data_in]
  connect_bd_net -net wea_1 [get_bd_pins MEMARYBLOCK/wea] [get_bd_pins U4/data_ram_we]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins GPIOBLOCK/Dout] [get_bd_pins U10/counter_ch]

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


