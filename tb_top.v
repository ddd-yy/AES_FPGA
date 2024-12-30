`timescale 1ns / 1ps

module testbench;
  reg clk;
  reg resetn;

  reg valid_key_gen;
  reg valid_round;
  reg valid_out;

  reg [127:0] inp_data;
  reg [127:0] inp_key;
  wire [127:0] out_data;

  wire [127:0] round_key_0;
  wire [127:0] round_key_1;
  wire [127:0] round_key_2;
  wire [127:0] round_key_3;
  wire [127:0] round_key_4;
  wire [127:0] round_key_5;
  wire [127:0] round_key_6;
  wire [127:0] round_key_7;
  wire [127:0] round_key_8;
  wire [127:0] round_key_9;
  wire [127:0] round_key_10;

  wire [127:0] round_data_0;
  wire [127:0] round_data_1;
  wire [127:0] round_data_2;
  wire [127:0] round_data_3;
  wire [127:0] round_data_4;
  wire [127:0] round_data_5;
  wire [127:0] round_data_6;
  wire [127:0] round_data_7;
  wire [127:0] round_data_8;
  wire [127:0] round_data_9;
  wire [127:0] round_data_10;

  // 实例化AES128模块
  AES128 AES128_DUT(
    .clk(clk),
    .resetn(resetn),

    .valid_key_gen(valid_key_gen),
    .valid_round(valid_round),
    .valid_out(valid_out),

    .IN_DATA(inp_data),
    .IN_KEY(inp_key),
    .OUT_DATA(out_data),
    .round_key_0(round_key_0),
    .round_key_1(round_key_1),
    .round_key_2(round_key_2),
    .round_key_3(round_key_3),
    .round_key_4(round_key_4),
    .round_key_5(round_key_5),
    .round_key_6(round_key_6),
    .round_key_7(round_key_7),
    .round_key_8(round_key_8),
    .round_key_9(round_key_9),
    .round_key_10(round_key_10),
    .round_data_0(round_data_0),
    .round_data_1(round_data_1),
    .round_data_2(round_data_2),
    .round_data_3(round_data_3),
    .round_data_4(round_data_4),
    .round_data_5(round_data_5),
    .round_data_6(round_data_6),
    .round_data_7(round_data_7),
    .round_data_8(round_data_8),
    .round_data_9(round_data_9),
    .round_data_10(round_data_10)
  );


  always #5 clk = !clk; // 时钟周期为10ns

  initial begin
    clk = 0;
    resetn = 0;

    valid_key_gen = 0;
    valid_round = 0;
    valid_out = 0;

    inp_data = 128'b0;
    inp_key = 128'b0;

    #10;
    resetn = 1;

    // #10;  

    // 测试1：测试密钥生成
    valid_key_gen = 1;
    inp_key = 128'h0123456789ABCDEF0123456789ABCDEF;
    #10;
    valid_key_gen = 0;

    // 检查密钥生成结果
    $display("Test Case 1 - Key Generation:");
    $display("Round 0 Key: %h", round_key_0);
    $display("Round 1 Key: %h", round_key_1);
    $display("Round 2 Key: %h", round_key_2);
    $display("Round 3 Key: %h", round_key_3);
    $display("Round 4 Key: %h", round_key_4);
    $display("Round 5 Key: %h", round_key_5);
    $display("Round 6 Key: %h", round_key_6);
    $display("Round 7 Key: %h", round_key_7);
    $display("Round 8 Key: %h", round_key_8);
    $display("Round 9 Key: %h", round_key_9);
    $display("Round 10 Key: %h", round_key_10);

    // 测试2：测试加密过程
    valid_round = 1;
    inp_data = 128'hd7e5dbd3324595f8fdc7d7c571da6c2a;
    #10;
    valid_round = 0;

    // 检查加密结果
    $display("Test Case 2 - Encryption:");
    $display("Round 0 Data: %h", round_data_0);
    $display("Round 1 Data: %h", round_data_1);
    $display("Round 2 Data: %h", round_data_2);
    $display("Round 3 Data: %h", round_data_3);
    $display("Round 4 Data: %h", round_data_4);
    $display("Round 5 Data: %h", round_data_5);
    $display("Round 6 Data: %h", round_data_6);
    $display("Round 7 Data: %h", round_data_7);
    $display("Round 8 Data: %h", round_data_8);
    $display("Round 9 Data: %h", round_data_9);
    $display("Round 10 Data: %h", round_data_10);

    // 测试3：测试最终输出
    valid_out = 1;
    #10;
    valid_out = 0;

    // 检查最终输出结果
    $display("Test Case 3 - Final Output:");
    $display("Encrypted value: %h", out_data);


    #100 $finish;
  end

endmodule
