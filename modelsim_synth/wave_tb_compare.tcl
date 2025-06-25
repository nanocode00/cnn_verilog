vlog ../synth/work_around_yosys/*.v ../synth/*.v

vsim work.tb_compare
delete wave *

add wave -format logic     -radix binary      tb_compare/clk
add wave -format logic     -radix binary      tb_compare/rst_n
add wave -format literal   -radix unsigned    tb_compare/img_idx
add wave -format literal   -radix hexadecimal tb_compare/data_in
add wave -format literal   -radix unsigned    tb_compare/cnt
add wave -format literal   -radix unsigned    tb_compare/input_cnt
add wave -format literal   -radix unsigned    tb_compare/rand_num
add wave -format literal   -radix unsigned    tb_compare/accuracy
add wave -format literal   -radix unsigned    tb_compare/decision
add wave -format literal   -radix binary      tb_compare/valid_out_6
add wave -format literal   -radix unsigned    tb_compare/accuracy_synth
add wave -format literal   -radix unsigned    tb_compare/decision_synth
add wave -format literal   -radix binary      tb_compare/valid_out_6_synth
add wave -format literal   -radix unsigned    tb_compare/match_cnt
add wave -format literal   -radix binary      tb_compare/match

run 100ns
