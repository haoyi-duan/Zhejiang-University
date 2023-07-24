onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib RandomX_Rom_opt

do {wave.do}

view wave
view structure
view signals

do {RandomX_Rom.udo}

run -all

quit -force
