`timescale 1ns / 1ps
module AES128(
    input clk,
    input rstn,
    input en, // AES启动使能信号(key是否可以开始generate)

    input data_in_valid, // 输入明文是否有效
    input [127:0] data_in, // 输入的明文

    output aes_state, // AES工作状态
    output rk_ready, // 密钥准备就绪，提示可以开始加密

    output data_out_valid, // 输出密文是否有效
    output [127:0] data_out, // 输出的密文

    input [127:0] key_in, // 输入的密钥
    input slt_module // 选择加密/解密模式（默认加密，由于暂时没有完成解密，暂不考虑解密模式）
);

reg aes_state_reg;
reg rk_ready_reg;
reg data_out_valid_reg;
reg [127:0] data_out_reg;

assign aes_state = aes_state_reg;
assign rk_ready = rk_ready_reg;
assign data_out_valid = data_out_valid_reg;
assign data_out = data_out_reg;

reg [127:0] ROUND_KEY [0:9];
reg [127:0] NEXT_KEY [0:10];
always @(*) begin
    NEXT_KEY[0]=key_in;
end

//用状态机实现密钥扩展,三段式
parameter IDLE =2'b00,GENERATING=2'b01,DONE=2'b10 ;
reg [1:0] current_state,next_state;
reg [3:0] i;
reg [127:0]in_key;
wire [127:0]out_key;
reg [3:0]round;
always @(posedge clk or negedge rstn) begin
    if(!rstn)begin
        current_state<=IDLE;
    end
    else begin
        current_state<=next_state;
    end
end
always @(posedge clk or negedge rstn) begin
    if(!rstn)next_state<=IDLE;
end
always @(posedge clk or negedge rstn) begin
    if(!rstn)i<=0;
    else if(current_state==GENERATING)begin
        if(NEXT_KEY[i+1]&&i<10)i<=i+1;
    end
end
always @(*) begin
    case(current_state)
        IDLE:begin
            if(en&&i==0)begin
                next_state=GENERATING;
            end
            else next_state=IDLE;
        end
        GENERATING:begin
            if(i<10) begin
                next_state=GENERATING;
            end
            else begin
                next_state=DONE;
            end
        end
        DONE:begin
            next_state=IDLE;
        end
        default:next_state=next_state;
    endcase
end
//输出逻辑用case, if默认是有优先级的
always @(posedge clk or negedge rstn) begin
    case(current_state)
        GENERATING:begin
        NEXT_KEY[i+1]=out_key;
        ROUND_KEY[i]=NEXT_KEY[i+1];
        in_key=NEXT_KEY[i];
        round=i;
        end
    endcase
end
GENERATE_KEY K_inst(
    .ROUND_KEY(round),
    .IN_KEY(in_key),
    .OUT_KEY(out_key)
);

//密钥准备状态
always @(posedge clk or negedge rstn) begin
    if(!rstn)rk_ready_reg<=1'b0;
    else if(current_state==DONE)begin
        rk_ready_reg<=1'b1;
    end
end

// AES状态控制逻辑
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        aes_state_reg <= 1'b0;
    end else if (rk_ready_reg && data_in_valid) begin
        aes_state_reg <= 1'b1;
    end else begin
        aes_state_reg <= 1'b0; // 保持 aes_state_reg 为 0
    end
end

//流水线实现加密
parameter PIPLINE_DEPTH = 10;
wire [127:0] pip_data_in [0:PIPLINE_DEPTH];
wire flag [0:PIPLINE_DEPTH-1];
//数据输入
assign pip_data_in[0] = data_in_valid?data_in^key_in:128'bx;

always @(*) begin
    if(!rstn)begin
        data_out_valid_reg=1'b0;
        data_out_reg=128'b0;
    end
    else if(pip_data_in[PIPLINE_DEPTH]&&pip_data_in[0])begin
        data_out_reg=pip_data_in[PIPLINE_DEPTH];
        data_out_valid_reg=1'b1;
    end
end

generate
    genvar R2;
    for(R2=0;R2<PIPLINE_DEPTH;R2=R2+1)begin:R_inst
        assign flag[R2]=(R2==PIPLINE_DEPTH-1)?1'b1:1'b0;
        ROUND_ITERATION inst(
            .IN_DATA(pip_data_in[R2]),
            .IN_KEY(ROUND_KEY[R2]),
            .LAST_ROUND_FLAG(flag[R2]), // 标志是否是最后一轮
            .OUT_DATA(pip_data_in[R2+1])
        ); 
    end
endgenerate


endmodule