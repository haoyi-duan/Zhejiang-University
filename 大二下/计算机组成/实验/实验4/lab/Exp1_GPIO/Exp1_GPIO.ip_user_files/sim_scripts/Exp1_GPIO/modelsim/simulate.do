onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L dist_mem_gen_v8_0_12 -L util_vector_logic_v2_0_1 -L blk_mem_gen_v8_4_1 -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.Exp1_GPIO xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {Exp1_GPIO.udo}

run -all

quit -force
