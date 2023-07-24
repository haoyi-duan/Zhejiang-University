onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+CSTE_RISCVEDF -L xil_defaultlib -L xpm -L xlslice_v1_0_1 -L dist_mem_gen_v8_0_12 -L blk_mem_gen_v8_4_1 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.CSTE_RISCVEDF xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {CSTE_RISCVEDF.udo}

run -all

endsim

quit -force
