# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7k160tffg676-2L

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir F:/Desk/lab10/EXP010/OExp05_CPU.cache/wt [current_project]
set_property parent.project_path F:/Desk/lab10/EXP010/OExp05_CPU.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo f:/Desk/lab10/EXP010/OExp05_CPU.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files F:/Desk/lab10/EXP010/coe/D_mem.coe
add_files F:/Desk/lab10/EXP010/coe/RISCV-DEMO9.coe
add_files F:/Desk/lab10/EXP010/coe/lab7_inst.coe
add_files F:/Desk/lab10/EXP010/coe/LAB7DIY.coe
add_files F:/Desk/lab10/EXP010/coe/RV32P2BubbleDEMO.coe
read_verilog -library xil_defaultlib {
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/sources_1/imports/RSDP9/ALU_5359/ALU_5359.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/Arraykeys.v
  {F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/Pipeline DEBUG/CPUTEST.v}
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/Clkdiv.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/VGA/Code2Inst.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/Counter.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/DSEGIO.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/Disp2Hex.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/Display.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/EnterT32.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/VGA/Font816.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/GPIO.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/sources_1/new/ImmGen.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/MIOBUS.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/PIO.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/sources_1/new/REG32.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/new/REG_EX_MEM.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/new/REG_ID_EX.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/new/REG_IF_ID.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/new/REG_MEM_WB.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/new/RV32IPCU_C.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/new/RV32IPDP_C.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/new/RV32PCPU.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/VGA/VGATEST.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/sources_1/imports/RSDP9/regs.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/VGA/vga.v
  F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/new/OEXp05_CPU.v
}
read_ip -quiet F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/ip/RAM/RAM.xci
set_property used_in_implementation false [get_files -all f:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/ip/RAM/RAM_ooc.xdc]

read_ip -quiet F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/ip/ROM/ROM.xci
set_property used_in_implementation false [get_files -all f:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/ip/ROM/ROM_ooc.xdc]

read_edif F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/EnterT32.edf
read_edif F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/Arraykeys.edf
read_edif F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/PIO.edf
read_edif F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/GPIO.edf
read_edif F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/Disp2Hex.edf
read_edif F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/Display.edf
read_edif F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/DSEGIO.edf
read_edif F:/Desk/lab10/EXP010/OExp05_CPU.srcs/sources_1/imports/OExp05_CPU/IO/MIOBUS.edf
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc F:/Desk/lab10/EXP010/OExp05_CPU.srcs/constrs_1/imports/coe/CSTE_V20.xdc
set_property used_in_implementation false [get_files F:/Desk/lab10/EXP010/OExp05_CPU.srcs/constrs_1/imports/coe/CSTE_V20.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top OEXp05_CPU -part xc7k160tffg676-2L


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef OEXp05_CPU.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file OEXp05_CPU_utilization_synth.rpt -pb OEXp05_CPU_utilization_synth.pb"
