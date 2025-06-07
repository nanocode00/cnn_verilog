vlog verilog/*.v

vsim work.top_tb_1000
delete wave *

add wave -format logic     -radix binary      top_tb_1000/clk
add wave -format logic     -radix binary      top_tb_1000/rst_n
add wave -format literal   -radix unsigned    top_tb_1000/img_idx
add wave -format literal   -radix hexadecimal top_tb_1000/data_in
add wave -format literal   -radix unsigned    top_tb_1000/cnt
add wave -format literal   -radix unsigned    top_tb_1000/input_cnt
add wave -format literal   -radix unsigned    top_tb_1000/rand_num
add wave -format literal   -radix unsigned    top_tb_1000/accuracy
add wave -format literal   -radix unsigned    top_tb_1000/decision
add wave -format literal   -radix binary      top_tb_1000/valid_out_6

run 100ns
