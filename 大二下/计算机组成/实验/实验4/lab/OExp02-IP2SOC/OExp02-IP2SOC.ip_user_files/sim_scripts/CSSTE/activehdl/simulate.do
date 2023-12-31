onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+CSSTE -L xil_defaultlib -L xpm -L xlslice_v1_0_1 -L blk_mem_gen_v8_4_1 -L dist_mem_gen_v8_0_12 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.CSSTE xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {CSSTE.udo}

run -all

endsim

quit -force
