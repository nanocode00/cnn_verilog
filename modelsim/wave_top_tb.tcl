vlog verilog/*.v

vsim work.top_tb
delete wave *

add wave -format logic     -radix binary      top_tb/clk
add wave -format logic     -radix binary      top_tb/rst_n
add wave -format literal   -radix unsigned    top_tb/img_idx
add wave -format literal   -radix hexadecimal top_tb/data_in
add wave -format literal   -radix unsigned    top_tb/decision
add wave -format literal   -radix binary      top_tb/valid_out_6

run 100ns
