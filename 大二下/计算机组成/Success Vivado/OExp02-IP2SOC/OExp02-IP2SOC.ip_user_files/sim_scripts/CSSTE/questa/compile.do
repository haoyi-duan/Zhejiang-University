vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm
vlib questa_lib/msim/xlslice_v1_0_1
vlib questa_lib/msim/blk_mem_gen_v8_4_1
vlib questa_lib/msim/dist_mem_gen_v8_0_12

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm
vmap xlslice_v1_0_1 questa_lib/msim/xlslice_v1_0_1
vmap blk_mem_gen_v8_4_1 questa_lib/msim/blk_mem_gen_v8_4_1
vmap dist_mem_gen_v8_0_12 questa_lib/msim/dist_mem_gen_v8_0_12

vlog -work xil_defaultlib -64 -sv \
"F:/Xlinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"F:/Xlinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 \
"../../../bd/CSSTE/ipshared/68c5/MSCPUE.v" \
"../../../bd/CSSTE/ip/CSSTE_MSCPUE_0_0/sim/CSSTE_MSCPUE_0_0.v" \
"../../../bd/CSSTE/ipshared/7f8b/Arraykeys.v" \
"../../../bd/CSSTE/ip/CSSTE_Arraykeys_0_0/sim/CSSTE_Arraykeys_0_0.v" \
"../../../bd/CSSTE/ipshared/f071/SWOUT.v" \
"../../../bd/CSSTE/ip/CSSTE_SWOUT_0_0/sim/CSSTE_SWOUT_0_0.v" \
"../../../bd/CSSTE/ipshared/ebb1/EnterT32.v" \
"../../../bd/CSSTE/ip/CSSTE_EnterT32_0_0/sim/CSSTE_EnterT32_0_0.v" \
"../../../bd/CSSTE/ipshared/caa0/Clkdiv.v" \
"../../../bd/CSSTE/ip/CSSTE_Clkdiv_0_0/sim/CSSTE_Clkdiv_0_0.v" \
"../../../bd/CSSTE/ipshared/5fae/DIVO.v" \
"../../../bd/CSSTE/ip/CSSTE_DIVO_0_0/sim/CSSTE_DIVO_0_0.v" \
"../../../bd/CSSTE/ipshared/1817/DSEGIO.v" \
"../../../bd/CSSTE/ip/CSSTE_DSEGIO_0_0/sim/CSSTE_DSEGIO_0_0.v" \
"../../../bd/CSSTE/ipshared/320d/Disp2Hex.v" \
"../../../bd/CSSTE/ip/CSSTE_Disp2Hex_0_0/sim/CSSTE_Disp2Hex_0_0.v" \
"../../../bd/CSSTE/ipshared/320e/Display.v" \
"../../../bd/CSSTE/ip/CSSTE_Display_0_0/sim/CSSTE_Display_0_0.v" \
"../../../bd/CSSTE/ipshared/a600/GPIO.v" \
"../../../bd/CSSTE/ip/CSSTE_GPIO_0_0/sim/CSSTE_GPIO_0_0.v" \

vlog -work xlslice_v1_0_1 -64 \
"../../../../OExp02-IP2SOC.srcs/sources_1/bd/CSSTE/ipshared/f3db/hdl/xlslice_v1_0_vl_rfs.v" \

vlog -work xil_defaultlib -64 \
"../../../bd/CSSTE/ip/CSSTE_xlslice_0_0/sim/CSSTE_xlslice_0_0.v" \
"../../../bd/CSSTE/ipshared/0ddc/PIO.v" \
"../../../bd/CSSTE/ip/CSSTE_PIO_0_0/sim/CSSTE_PIO_0_0.v" \
"../../../bd/CSSTE/ipshared/9f8e/MIOBUS.v" \
"../../../bd/CSSTE/ip/CSSTE_MIOBUS_0_0/sim/CSSTE_MIOBUS_0_0.v" \
"../../../bd/CSSTE/ipshared/3da6/TESTOUT.v" \
"../../../bd/CSSTE/ip/CSSTE_TESTO_0_0/sim/CSSTE_TESTO_0_0.v" \
"../../../bd/CSSTE/ipshared/ac59/Font816.v" \
"../../../bd/CSSTE/ipshared/ac59/VGATEST.v" \
"../../../bd/CSSTE/ip/CSSTE_vga_debug_0_0/sim/CSSTE_vga_debug_0_0.v" \
"../../../bd/CSSTE/ipshared/caa9/vga.v" \
"../../../bd/CSSTE/ip/CSSTE_vga_0_0/sim/CSSTE_vga_0_0.v" \

vlog -work blk_mem_gen_v8_4_1 -64 \
"../../../../OExp02-IP2SOC.srcs/sources_1/bd/CSSTE/ipshared/67d8/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 \
"../../../bd/CSSTE/ip/CSSTE_blk_mem_gen_0_1/sim/CSSTE_blk_mem_gen_0_1.v" \
"../../../bd/CSSTE/ip/CSSTE_xlslice_0_1/sim/CSSTE_xlslice_0_1.v" \

vlog -work dist_mem_gen_v8_0_12 -64 \
"../../../../OExp02-IP2SOC.srcs/sources_1/bd/CSSTE/ipshared/d46a/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib -64 \
"../../../bd/CSSTE/ip/CSSTE_dist_mem_gen_0_0/sim/CSSTE_dist_mem_gen_0_0.v" \
"../../../bd/CSSTE/ipshared/a19b/Counter.v" \
"../../../bd/CSSTE/ip/CSSTE_Counter_0_0/sim/CSSTE_Counter_0_0.v" \
"../../../bd/CSSTE/sim/CSSTE.v" \

vlog -work xil_defaultlib \
"glbl.v"

