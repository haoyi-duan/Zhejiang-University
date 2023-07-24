onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L xlslice_v1_0_1 -L dist_mem_gen_v8_0_12 -L blk_mem_gen_v8_4_1 -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.CSTE_RISCVEDF xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {CSTE_RISCVEDF.udo}

run -all

quit -force
