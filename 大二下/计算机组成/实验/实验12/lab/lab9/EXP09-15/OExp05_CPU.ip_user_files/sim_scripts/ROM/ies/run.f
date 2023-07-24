-makelib ies_lib/xil_defaultlib -sv \
  "F:/Xlinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "F:/Xlinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/dist_mem_gen_v8_0_12 \
  "../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../OExp05_CPU.srcs/sources_1/ip/ROM/sim/ROM.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

