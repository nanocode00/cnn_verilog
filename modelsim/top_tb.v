/*------------------------------------------------------------------------
 *
 *  Copyright (c) 2021 by Bo Young Kang, All rights reserved.
 *
 *  File name  : top_tb.v
 *  Written by : Kang, Bo Young
 *  Written on : Oct 15, 2021
 *  Version    : 21.2
 *  Design     : Testbench for CNN MNIST dataset - single input image
 *
 *------------------------------------------------------------------------*/

/*-------------------------------------------------------------------
 *  Module: top_tb
 *------------------------------------------------------------------*/
`timescale 1ps/1ps
module top_tb();
    parameter DATA_BITS = 8;
    reg clk, rst_n;
    reg [7:0] pixels [0:783];
    reg [9:0] img_idx;
    reg [7:0] data_in;

    wire [3:0] decision;
    wire valid_out_6;

    //conv1
    reg signed [7:0] weight_11 [0:24];
    reg signed [7:0] weight_12 [0:24];
    reg signed [7:0] weight_13 [0:24];
    reg signed [7:0] bias_1 [0:2];
    //conv2
    reg signed [7:0] bias_2 [0:2];
    reg signed [7:0] weight_211 [0:24];
    reg signed [7:0] weight_212 [0:24];
    reg signed [7:0] weight_213 [0:24];

    reg signed [7:0] weight_221 [0:24];
    reg signed [7:0] weight_222 [0:24];
    reg signed [7:0] weight_223 [0:24];

    reg signed [7:0] weight_231 [0:24];
    reg signed [7:0] weight_232 [0:24];
    reg signed [7:0] weight_233 [0:24];
    //fullyconnected

    reg signed [7:0] weight_fc [0:479];
    reg signed [7:0] bias_fc [0:9];


    wire signed [0:199] w_11;
    wire signed [0:199] w_12;
    wire signed [0:199] w_13;
    wire signed [0:23] b_1;
    wire signed [0:23] b_2;
    wire signed [0:199] w_211;
    wire signed [0:199] w_212;
    wire signed [0:199] w_213;
    wire signed [0:199] w_221;
    wire signed [0:199] w_222;
    wire signed [0:199] w_223;
    wire signed [0:199] w_231;
    wire signed [0:199] w_232;
    wire signed [0:199] w_233;
    wire signed [0:3839] w_fc;
    wire signed [0:79] b_fc;
    // Clock generation
    always #5 clk = ~clk;

    // Read image text file
    initial begin
    $readmemh("../data/2_0.txt", pixels);
    clk <= 1'b0;
    rst_n <= 1'b1;
    #3
    rst_n <= 1'b0;
    #3
    rst_n <= 1'b1;
    end
    initial begin
    //conv1
    $readmemh("../data/conv1_weight_1.txt", weight_11);
    $readmemh("../data/conv1_weight_2.txt", weight_12);
    $readmemh("../data/conv1_weight_3.txt", weight_13);
    $readmemh("../data/conv1_bias.txt", bias_1);
    //conv2
    $readmemh("../data/conv2_bias.txt", bias_2);
        $readmemh("../data/conv2_weight_11.txt", weight_211);
        $readmemh("../data/conv2_weight_12.txt", weight_212);
        $readmemh("../data/conv2_weight_13.txt", weight_213);
        $readmemh("../data/conv2_weight_21.txt", weight_221);
        $readmemh("../data/conv2_weight_22.txt", weight_222);
        $readmemh("../data/conv2_weight_23.txt", weight_223);
        $readmemh("../data/conv2_weight_31.txt", weight_231);
        $readmemh("../data/conv2_weight_32.txt", weight_232);
        $readmemh("../data/conv2_weight_33.txt", weight_233);
    //fullyconnected
    $readmemh("../data/fc_weight.txt", weight_fc);
    $readmemh("../data/fc_bias.txt", bias_fc);
    end
    
    always @(posedge clk) begin
    if(~rst_n) begin
        img_idx <= 0;
    end else begin
        if(img_idx < 10'd784) begin
        img_idx <= img_idx + 1'b1;
        end
        data_in <= pixels[img_idx];
    end
    end
    always @(*) begin
        if(valid_out_6==1) #5 $finish;
    end
    chip chip1 (
    clk,rst_n,data_in,decision,valid_out_6,
    w_11 , w_12 , w_13 , b_1 ,
    //conv2
    b_2 , w_211 , w_212 , w_213 , w_221 , w_222 , w_223 , w_231 , w_232 , w_233 ,
    //fullyconnected
    w_fc, b_fc);

    genvar i;
    generate
        for(i=0;i<=24;i=i+1) begin
            assign w_11[(8*i)+:8]=weight_11[i];
            assign w_12[(8*i)+:8]=weight_12[i];
            assign w_13[(8*i)+:8]=weight_13[i];
            assign w_211[(8*i)+:8]=weight_211[i];
            assign w_212[(8*i)+:8]=weight_212[i];
            assign w_213[(8*i)+:8]=weight_213[i];
            assign w_221[(8*i)+:8]=weight_221[i];
            assign w_222[(8*i)+:8]=weight_222[i];
            assign w_223[(8*i)+:8]=weight_223[i];
            assign w_231[(8*i)+:8]=weight_231[i];
            assign w_232[(8*i)+:8]=weight_232[i];
            assign w_233[(8*i)+:8]=weight_233[i];            
        end
        for(i=0;i<=2;i=i+1) begin
            assign b_1[(8*i)+:8]=bias_1[i];
            assign b_2[(8*i)+:8]=bias_2[i];          
        end
        for(i=0;i<=479;i=i+1) begin
            assign w_fc[(8*i)+:8]=weight_fc[i];    
        end
        for(i=0;i<=9;i=i+1) begin
            assign b_fc[(8*i)+:8]=bias_fc[i];          
        end
    endgenerate

endmodule
