onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib CSTE_RISCVEDF_opt

do {wave.do}

view wave
view structure
view signals

do {CSTE_RISCVEDF.udo}

run -all

quit -force
