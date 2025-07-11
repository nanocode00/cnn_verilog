module chip(
    input clk,
    input rst_n,
    input [7:0] data_in,
    output [3:0] decision,
    output valid_out_6,    
    //data
    input [0:199] w_11,
    input [0:199] w_12,
    input [0:199] w_13,
    input [0:23] b_1,
    input [0:23] b_2,
    input [0:199] w_211,
    input [0:199] w_212,
    input [0:199] w_213,
    input [0:199] w_221,
    input [0:199] w_222,
    input [0:199] w_223,
    input [0:199] w_231,
    input [0:199] w_232,
    input [0:199] w_233,
    input [0:3839] w_fc,
    input [0:79] b_fc
);
    wire signed [11:0] conv_out_1, conv_out_2, conv_out_3;
    wire signed [11:0] conv2_out_1, conv2_out_2, conv2_out_3;
    wire signed [11:0] max_value_1, max_value_2, max_value_3;
    wire signed [11:0] max2_value_1, max2_value_2, max2_value_3;
    wire signed [11:0] fc_out_data;
    wire valid_out_1, valid_out_2, valid_out_3, valid_out_4, valid_out_5;

    // Module Instantiation
    conv1_layer conv1_layer(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .conv_out_1(conv_out_1),
        .conv_out_2(conv_out_2),
        .conv_out_3(conv_out_3),
        .valid_out_conv(valid_out_1),
        .w_11(w_11),
        .w_12(w_12),
        .w_13(w_13),
        .b_1(b_1)
    );

    maxpool_relu_1 maxpool_relu_1(
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_out_1),
        .conv_out_1(conv_out_1),
        .conv_out_2(conv_out_2),
        .conv_out_3(conv_out_3),
        .max_value_1(max_value_1),
        .max_value_2(max_value_2),
        .max_value_3(max_value_3),
        .valid_out_relu(valid_out_2)
    );

    conv2_layer conv2_layer(
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_out_2),
        .max_value_1(max_value_1),
        .max_value_2(max_value_2),
        .max_value_3(max_value_3),
        .conv2_out_1(conv2_out_1),
        .conv2_out_2(conv2_out_2),
        .conv2_out_3(conv2_out_3),
        .valid_out_conv2(valid_out_3),
        .w_211(w_211),
        .w_212(w_212),
        .w_213(w_213),
        .w_221(w_221),
        .w_222(w_222),
        .w_223(w_223),
        .w_231(w_231),
        .w_232(w_232),
        .w_233(w_233),
        .b_2(b_2)
    );

    maxpool_relu_2 maxpool_relu_2(
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_out_3),
        .conv_out_1(conv2_out_1),
        .conv_out_2(conv2_out_2),
        .conv_out_3(conv2_out_3),
        .max_value_1(max2_value_1),
        .max_value_2(max2_value_2),
        .max_value_3(max2_value_3),
        .valid_out_relu(valid_out_4)
    );

    fully_connected fully_connected(
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_out_4),
        .data_in_1(max2_value_1),
        .data_in_2(max2_value_2),
        .data_in_3(max2_value_3),
        .data_out(fc_out_data),
        .valid_out_fc(valid_out_5),
        .w_fc(w_fc),
        .b_fc(b_fc)
    );

    comparator comparator(
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_out_5),
        .data_in(fc_out_data),
        .decision(decision),
        .valid_out(valid_out_6)
    );

endmodule

