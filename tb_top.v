`timescale 1ns / 1ps

module testbench;
  reg clk;
  reg rstn;

  reg en;
  reg data_in_valid;
  reg [127:0] data_in;
  reg [127:0] key_in;
  reg slt_module;

  wire aes_state;
  wire rk_ready;
  wire data_out_valid;
  wire [127:0] data_out;

  // 实例化AES128模块
  AES128 AES128_DUT(
    .clk(clk),
    .rstn(rstn),
    .en(en),
    .data_in_valid(data_in_valid),
    .data_in(data_in),
    .aes_state(aes_state),
    .rk_ready(rk_ready),
    .data_out_valid(data_out_valid),
    .data_out(data_out),
    .key_in(key_in),
    .slt_module(slt_module)
  );

  always #5 clk = !clk; // 时钟周期为10ns

  initial begin
    clk = 0;
    rstn = 0;
    en = 0;
    data_in_valid = 0;
    data_in = 128'b0;
    key_in = 128'b0;
    slt_module = 1'b0; // 默认加密模式

    #10;
    rstn = 1;

    // 测试1：测试密钥生成
    key_in = 128'h0123456789ABCDEF0123456789ABCDEF;
    en = 1;
    #10;
    en = 0;

    // 等待密钥生成完成
    wait (rk_ready);

    // 测试2：测试加密过程
    data_in_valid = 1;
    data_in = 128'hd7e5dbd3324595f8fdc7d7c571da6c2a;
    //525a0bb6f6626e941a81cd7b5fe8b620
    #10;
     data_in = 128'ha2f4dbd3324595f8fdc7d7c571da6c2b;
    //d73f13dadea97657531d06d240c2c627
    #10;
     data_in_valid = 0;
    // 等待加密完成
    wait (data_out_valid);

    // 检查最终输出结果
    $display("Test Case 2 - Encryption:");
    $display("Encrypted value: %h", data_out);

    // // 测试3：测试解密过程（假设解密逻辑已实现）
    // slt_module = 1'b1; // 切换到解密模式
    // data_in_valid = 1;
    // data_in = data_out; // 使用加密后的数据作为解密输入
    // #10;
    // data_in_valid = 0;

    // // 等待解密完成
    // wait (data_out_valid);

    // // 检查最终输出结果
    // $display("Test Case 3 - Decryption:");
    // $display("Decrypted value: %h", data_out);

    #100 $finish;
  end

endmodule