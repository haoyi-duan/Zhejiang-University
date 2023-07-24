vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm
vlib activehdl/xlslice_v1_0_1
vlib activehdl/dist_mem_gen_v8_0_12
vlib activehdl/blk_mem_gen_v8_4_1

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm
vmap xlslice_v1_0_1 activehdl/xlslice_v1_0_1
vmap dist_mem_gen_v8_0_12 activehdl/dist_mem_gen_v8_0_12
vmap blk_mem_gen_v8_4_1 activehdl/blk_mem_gen_v8_4_1

vlog -work xil_defaultlib  -sv2k12 \
"F:/Xlinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"F:/Xlinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xlslice_v1_0_1  -v2k5 \
"../../../../OExp03_Block.srcs/sources_1/bd/CSTE_RISCVEDF/ipshared/f3db/hdl/xlslice_v1_0_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_xlslice_0_1/sim/CSTE_RISCVEDF_xlslice_0_1.v" \

vlog -work dist_mem_gen_v8_0_12  -v2k5 \
"../../../../OExp03_Block.srcs/sources_1/bd/CSTE_RISCVEDF/ipshared/d46a/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_dist_mem_gen_0_0/sim/CSTE_RISCVEDF_dist_mem_gen_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/c7ab/MEMTEST.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_MEMTEST_0_0/sim/CSTE_RISCVEDF_MEMTEST_0_0.v" \

vlog -work blk_mem_gen_v8_4_1  -v2k5 \
"../../../../OExp03_Block.srcs/sources_1/bd/CSTE_RISCVEDF/ipshared/67d8/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_blk_mem_gen_0_0/sim/CSTE_RISCVEDF_blk_mem_gen_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_xlslice_0_0/sim/CSTE_RISCVEDF_xlslice_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/a600/GPIO.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_GPIO_0_0/sim/CSTE_RISCVEDF_GPIO_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/0ddc/PIO.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_PIO_0_0/sim/CSTE_RISCVEDF_PIO_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/3185/DSEGIO.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_DSEGIO_0_0/sim/CSTE_RISCVEDF_DSEGIO_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/320e/Display.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_Display_0_0/sim/CSTE_RISCVEDF_Display_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/320d/Disp2Hex.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_Disp2Hex_0_0/sim/CSTE_RISCVEDF_Disp2Hex_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/5fae/DIVO.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_DIVO_0_0/sim/CSTE_RISCVEDF_DIVO_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/caa0/Clkdiv.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_Clkdiv_0_0/sim/CSTE_RISCVEDF_Clkdiv_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/7f8b/Arraykeys.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_Arraykeys_0_0/sim/CSTE_RISCVEDF_Arraykeys_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/2726/TESTOUT.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_TESTO_0_0/sim/CSTE_RISCVEDF_TESTO_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/ebb1/EnterT32.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_EnterT32_0_0/sim/CSTE_RISCVEDF_EnterT32_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/a138/SWOUT.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_SWOUT_0_0/sim/CSTE_RISCVEDF_SWOUT_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/f084/RSCPU9.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_RSCPU9_0_0/sim/CSTE_RISCVEDF_RSCPU9_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/9f8e/MIOBUS.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_MIOBUS_0_0/sim/CSTE_RISCVEDF_MIOBUS_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/5415/Counter.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_Counter_0_0/sim/CSTE_RISCVEDF_Counter_0_0.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/32ab/Font816.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/32ab/VGATEST.v" \
"../../../bd/CSTE_RISCVEDF/ipshared/32ab/vga.v" \
"../../../bd/CSTE_RISCVEDF/ip/CSTE_RISCVEDF_VGA_TEST_0_0/sim/CSTE_RISCVEDF_VGA_TEST_0_0.v" \
"../../../bd/CSTE_RISCVEDF/sim/CSTE_RISCVEDF.v" \

vlog -work xil_defaultlib \
"glbl.v"

