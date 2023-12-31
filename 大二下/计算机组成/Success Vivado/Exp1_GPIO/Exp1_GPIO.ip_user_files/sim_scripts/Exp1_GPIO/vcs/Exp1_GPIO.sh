#!/bin/bash -f
#*********************************************************************************************************
# Vivado (TM) v2017.4 (64-bit)
#
# Filename    : Exp1_GPIO.sh
# Simulator   : Synopsys Verilog Compiler Simulator
# Description : Simulation script for compiling, elaborating and verifying the project source files.
#               The script will automatically create the design libraries sub-directories in the run
#               directory, add the library logical mappings in the simulator setup file, create default
#               'do/prj' file, execute compilation, elaboration and simulation steps.
#
# Generated by Vivado on Thu Mar 11 11:24:26 +0800 2021
# SW Build 2086221 on Fri Dec 15 20:55:39 MST 2017
#
# Copyright 1986-2017 Xilinx, Inc. All Rights Reserved. 
#
# usage: Exp1_GPIO.sh [-help]
# usage: Exp1_GPIO.sh [-lib_map_path]
# usage: Exp1_GPIO.sh [-noclean_files]
# usage: Exp1_GPIO.sh [-reset_run]
#
# Prerequisite:- To compile and run simulation, you must compile the Xilinx simulation libraries using the
# 'compile_simlib' TCL command. For more information about this command, run 'compile_simlib -help' in the
# Vivado Tcl Shell. Once the libraries have been compiled successfully, specify the -lib_map_path switch
# that points to these libraries and rerun export_simulation. For more information about this switch please
# type 'export_simulation -help' in the Tcl shell.
#
# You can also point to the simulation libraries by either replacing the <SPECIFY_COMPILED_LIB_PATH> in this
# script with the compiled library directory path or specify this path with the '-lib_map_path' switch when
# executing this script. Please type 'Exp1_GPIO.sh -help' for more information.
#
# Additional references - 'Xilinx Vivado Design Suite User Guide:Logic simulation (UG900)'
#
#*********************************************************************************************************

# Directory path for design sources and include directories (if any) wrt this path
ref_dir="."

# Override directory with 'export_sim_ref_dir' env path value if set in the shell
if [[ (! -z "$export_sim_ref_dir") && ($export_sim_ref_dir != "") ]]; then
  ref_dir="$export_sim_ref_dir"
fi

# Command line options
vlogan_opts="-full64"
vhdlan_opts="-full64"
vcs_elab_opts="-full64 -debug_pp -t ps -licqueue -l elaborate.log"
vcs_sim_opts="-ucli -licqueue -l simulate.log"

# Design libraries
design_libs=(xil_defaultlib xpm dist_mem_gen_v8_0_12 util_vector_logic_v2_0_1 blk_mem_gen_v8_4_1)

# Simulation root library directory
sim_lib_dir="vcs_lib"

# Script info
echo -e "Exp1_GPIO.sh - Script generated by export_simulation (Vivado v2017.4 (64-bit)-id)\n"

# Main steps
run()
{
  check_args $# $1
  setup $1 $2
  compile
  elaborate
  simulate
}

# RUN_STEP: <compile>
compile()
{
  # Compile design files
  vlogan -work xil_defaultlib $vlogan_opts -sverilog \
    "F:/Xlinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
  2>&1 | tee -a vlogan.log

  vhdlan -work xpm $vhdlan_opts \
    "F:/Xlinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
  2>&1 | tee -a vhdlan.log

  vlogan -work xil_defaultlib $vlogan_opts +v2k \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/b52a/Arraykeys.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_Arraykeys_0_0/sim/Exp1_GPIO_Arraykeys_0_0.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/ebb1/EnterT32.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_EnterT32_0_0/sim/Exp1_GPIO_EnterT32_0_0.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/f071/SWOUT.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_SWOUT_0_0/sim/Exp1_GPIO_SWOUT_0_0.v" \
  2>&1 | tee -a vlogan.log

  vlogan -work dist_mem_gen_v8_0_12 $vlogan_opts +v2k \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/d46a/simulation/dist_mem_gen_v8_0.v" \
  2>&1 | tee -a vlogan.log

  vlogan -work xil_defaultlib $vlogan_opts +v2k \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_dist_mem_gen_0_1/sim/Exp1_GPIO_dist_mem_gen_0_1.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/509e/PIO.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_PIO_0_0/sim/Exp1_GPIO_PIO_0_0.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/f4e4/GPIO.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_GPIO_0_0/sim/Exp1_GPIO_GPIO_0_0.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/341e/DSEGIO.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_DSEGIO_0_0/sim/Exp1_GPIO_DSEGIO_0_0.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/320d/Disp2Hex.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_Disp2Hex_0_0/sim/Exp1_GPIO_Disp2Hex_0_0.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/320e/Display.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_Display_0_0/sim/Exp1_GPIO_Display_0_0.v" \
  2>&1 | tee -a vlogan.log

  vlogan -work util_vector_logic_v2_0_1 $vlogan_opts +v2k \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/2137/hdl/util_vector_logic_v2_0_vl_rfs.v" \
  2>&1 | tee -a vlogan.log

  vlogan -work xil_defaultlib $vlogan_opts +v2k \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_util_vector_logic_0_0/sim/Exp1_GPIO_util_vector_logic_0_0.v" \
  2>&1 | tee -a vlogan.log

  vlogan -work blk_mem_gen_v8_4_1 $vlogan_opts +v2k \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/67d8/simulation/blk_mem_gen_v8_4.v" \
  2>&1 | tee -a vlogan.log

  vlogan -work xil_defaultlib $vlogan_opts +v2k \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_blk_mem_gen_0_0/sim/Exp1_GPIO_blk_mem_gen_0_0.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/d6be/Clkdiv.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_Clkdiv_0_0/sim/Exp1_GPIO_Clkdiv_0_0.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/fac0/DIVO.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_DIVO_0_0/sim/Exp1_GPIO_DIVO_0_0.v" \
    "$ref_dir/../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/sim/Exp1_GPIO.v" \
  2>&1 | tee -a vlogan.log


  vlogan -work xil_defaultlib $vlogan_opts +v2k \
    glbl.v \
  2>&1 | tee -a vlogan.log

}

# RUN_STEP: <elaborate>
elaborate()
{
  vcs $vcs_elab_opts xil_defaultlib.Exp1_GPIO xil_defaultlib.glbl -o Exp1_GPIO_simv
}

# RUN_STEP: <simulate>
simulate()
{
  ./Exp1_GPIO_simv $vcs_sim_opts -do simulate.do
}

# STEP: setup
setup()
{
  case $1 in
    "-lib_map_path" )
      if [[ ($2 == "") ]]; then
        echo -e "ERROR: Simulation library directory path not specified (type \"./Exp1_GPIO.sh -help\" for more information)\n"
        exit 1
      fi
      create_lib_mappings $2
    ;;
    "-reset_run" )
      reset_run
      echo -e "INFO: Simulation run files deleted.\n"
      exit 0
    ;;
    "-noclean_files" )
      # do not remove previous data
    ;;
    * )
      create_lib_mappings $2
  esac

  create_lib_dir

  # Add any setup/initialization commands here:-

  # <user specific commands>

}

# Define design library mappings
create_lib_mappings()
{
  file="synopsys_sim.setup"
  if [[ -e $file ]]; then
    if [[ ($1 == "") ]]; then
      return
    else
      rm -rf $file
    fi
  fi

  touch $file

  lib_map_path=""
  if [[ ($1 != "") ]]; then
    lib_map_path="$1"
  fi

  for (( i=0; i<${#design_libs[*]}; i++ )); do
    lib="${design_libs[i]}"
    mapping="$lib:$sim_lib_dir/$lib"
    echo $mapping >> $file
  done

  if [[ ($lib_map_path != "") ]]; then
    incl_ref="OTHERS=$lib_map_path/synopsys_sim.setup"
    echo $incl_ref >> $file
  fi
}

# Create design library directory paths
create_lib_dir()
{
  if [[ -e $sim_lib_dir ]]; then
    rm -rf $sim_lib_dir
  fi

  for (( i=0; i<${#design_libs[*]}; i++ )); do
    lib="${design_libs[i]}"
    lib_dir="$sim_lib_dir/$lib"
    if [[ ! -e $lib_dir ]]; then
      mkdir -p $lib_dir
    fi
  done
}

# Delete generated data from the previous run
reset_run()
{
  files_to_remove=(ucli.key Exp1_GPIO_simv vlogan.log vhdlan.log compile.log elaborate.log simulate.log .vlogansetup.env .vlogansetup.args .vcs_lib_lock scirocco_command.log 64 AN.DB csrc Exp1_GPIO_simv.daidir)
  for (( i=0; i<${#files_to_remove[*]}; i++ )); do
    file="${files_to_remove[i]}"
    if [[ -e $file ]]; then
      rm -rf $file
    fi
  done

  create_lib_dir
}

# Check command line arguments
check_args()
{
  if [[ ($1 == 1 ) && ($2 != "-lib_map_path" && $2 != "-noclean_files" && $2 != "-reset_run" && $2 != "-help" && $2 != "-h") ]]; then
    echo -e "ERROR: Unknown option specified '$2' (type \"./Exp1_GPIO.sh -help\" for more information)\n"
    exit 1
  fi

  if [[ ($2 == "-help" || $2 == "-h") ]]; then
    usage
  fi
}

# Script usage
usage()
{
  msg="Usage: Exp1_GPIO.sh [-help]\n\
Usage: Exp1_GPIO.sh [-lib_map_path]\n\
Usage: Exp1_GPIO.sh [-reset_run]\n\
Usage: Exp1_GPIO.sh [-noclean_files]\n\n\
[-help] -- Print help information for this script\n\n\
[-lib_map_path <path>] -- Compiled simulation library directory path. The simulation library is compiled\n\
using the compile_simlib tcl command. Please see 'compile_simlib -help' for more information.\n\n\
[-reset_run] -- Recreate simulator setup files and library mappings for a clean run. The generated files\n\
from the previous run will be removed. If you don't want to remove the simulator generated files, use the\n\
-noclean_files switch.\n\n\
[-noclean_files] -- Reset previous run, but do not remove simulator generated files from the previous run.\n\n"
  echo -e $msg
  exit 1
}

# Launch script
run $1 $2
