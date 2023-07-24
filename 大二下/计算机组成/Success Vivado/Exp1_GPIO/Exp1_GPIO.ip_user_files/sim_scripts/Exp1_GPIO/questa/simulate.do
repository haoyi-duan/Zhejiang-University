onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Exp1_GPIO_opt

do {wave.do}

view wave
view structure
view signals

do {Exp1_GPIO.udo}

run -all

quit -force
