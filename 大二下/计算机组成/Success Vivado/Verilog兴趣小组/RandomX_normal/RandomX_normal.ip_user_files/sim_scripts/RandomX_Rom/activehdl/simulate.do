onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+RandomX_Rom -L dist_mem_gen_v8_0_12 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.RandomX_Rom xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {RandomX_Rom.udo}

run -all

endsim

quit -force
