onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Exp1_GPIO -L xil_defaultlib -L xpm -L dist_mem_gen_v8_0_12 -L util_vector_logic_v2_0_1 -L blk_mem_gen_v8_4_1 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Exp1_GPIO xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {Exp1_GPIO.udo}

run -all

endsim

quit -force
