transcript file result_single.log

vlog ../*.v top_tb.v

vsim work.top_tb

add wave -format logic     -radix binary      top_tb/clk
add wave -format logic     -radix binary      top_tb/rst_n
add wave -format literal   -radix unsigned    top_tb/img_idx
add wave -format literal   -radix hexadecimal top_tb/data_in
add wave -format literal   -radix unsigned    top_tb/decision
add wave -format literal   -radix binary      top_tb/valid_out_6

run -all
