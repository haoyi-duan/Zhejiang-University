vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm
vlib riviera/dist_mem_gen_v8_0_12
vlib riviera/util_vector_logic_v2_0_1
vlib riviera/blk_mem_gen_v8_4_1

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm
vmap dist_mem_gen_v8_0_12 riviera/dist_mem_gen_v8_0_12
vmap util_vector_logic_v2_0_1 riviera/util_vector_logic_v2_0_1
vmap blk_mem_gen_v8_4_1 riviera/blk_mem_gen_v8_4_1

vlog -work xil_defaultlib  -sv2k12 \
"F:/Xlinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"F:/Xlinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/b52a/Arraykeys.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_Arraykeys_0_0/sim/Exp1_GPIO_Arraykeys_0_0.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/ebb1/EnterT32.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_EnterT32_0_0/sim/Exp1_GPIO_EnterT32_0_0.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/f071/SWOUT.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_SWOUT_0_0/sim/Exp1_GPIO_SWOUT_0_0.v" \

vlog -work dist_mem_gen_v8_0_12  -v2k5 \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/d46a/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_dist_mem_gen_0_1/sim/Exp1_GPIO_dist_mem_gen_0_1.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/509e/PIO.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_PIO_0_0/sim/Exp1_GPIO_PIO_0_0.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/f4e4/GPIO.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_GPIO_0_0/sim/Exp1_GPIO_GPIO_0_0.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/341e/DSEGIO.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_DSEGIO_0_0/sim/Exp1_GPIO_DSEGIO_0_0.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/320d/Disp2Hex.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_Disp2Hex_0_0/sim/Exp1_GPIO_Disp2Hex_0_0.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/320e/Display.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_Display_0_0/sim/Exp1_GPIO_Display_0_0.v" \

vlog -work util_vector_logic_v2_0_1  -v2k5 \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/2137/hdl/util_vector_logic_v2_0_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_util_vector_logic_0_0/sim/Exp1_GPIO_util_vector_logic_0_0.v" \

vlog -work blk_mem_gen_v8_4_1  -v2k5 \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/67d8/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_blk_mem_gen_0_0/sim/Exp1_GPIO_blk_mem_gen_0_0.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/d6be/Clkdiv.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_Clkdiv_0_0/sim/Exp1_GPIO_Clkdiv_0_0.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ipshared/fac0/DIVO.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/ip/Exp1_GPIO_DIVO_0_0/sim/Exp1_GPIO_DIVO_0_0.v" \
"../../../../Exp1_GPIO.srcs/sources_1/bd/Exp1_GPIO/sim/Exp1_GPIO.v" \

vlog -work xil_defaultlib \
"glbl.v"

