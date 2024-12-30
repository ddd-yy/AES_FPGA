module AES128(
    input clk,
    input resetn,

    input valid_key_gen,
    input valid_round,
    input valid_out,

    input [127:0] IN_DATA,
    input [127:0] IN_KEY,
    output [127:0] OUT_DATA,

    output [127:0] round_key_0, // in_key
    output [127:0] round_key_1,
    output [127:0] round_key_2,
    output [127:0] round_key_3,
    output [127:0] round_key_4,
    output [127:0] round_key_5,
    output [127:0] round_key_6,
    output [127:0] round_key_7,
    output [127:0] round_key_8,
    output [127:0] round_key_9,
    output [127:0] round_key_10,

    output [127:0] round_data_0, // first output: in_data^in_key
    output [127:0] round_data_1,
    output [127:0] round_data_2,
    output [127:0] round_data_3,
    output [127:0] round_data_4,
    output [127:0] round_data_5,
    output [127:0] round_data_6,
    output [127:0] round_data_7,
    output [127:0] round_data_8,
    output [127:0] round_data_9,
    output [127:0] round_data_10 // out_data,the correct encrypted text
);

reg [127:0] R0_OUT_DATA;
reg [3:0] round_counter;
reg [127:0] ROUND_KEY [0:9];
wire [127:0] NEXT_KEY [0:9];
wire [127:0] ROUND_OUT_DATA [0:9];

// 生成密钥扩展组合逻辑
generate
    genvar i;
    for (i = 0; i < 10; i = i + 1) begin : KEY_GEN
        if (i == 0) begin
            GENERATE_KEY K(
                .ROUND_KEY(i[3:0]), 
                .IN_KEY(IN_KEY), 
                .OUT_KEY(NEXT_KEY[i])
            );
        end else begin
            GENERATE_KEY K(
                .ROUND_KEY(i[3:0]), 
                .IN_KEY(NEXT_KEY[i-1]), 
                .OUT_KEY(NEXT_KEY[i])
            );
        end
    end
endgenerate

// 将 NEXT_KEY 赋值给 ROUND_KEY
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        ROUND_KEY[0] <= 128'b0;
        ROUND_KEY[1] <= 128'b0;
        ROUND_KEY[2] <= 128'b0;
        ROUND_KEY[3] <= 128'b0;
        ROUND_KEY[4] <= 128'b0;
        ROUND_KEY[5] <= 128'b0;
        ROUND_KEY[6] <= 128'b0;
        ROUND_KEY[7] <= 128'b0;
        ROUND_KEY[8] <= 128'b0;
        ROUND_KEY[9] <= 128'b0;
    end else if (valid_key_gen) begin
        ROUND_KEY[0] <= NEXT_KEY[0];
        ROUND_KEY[1] <= NEXT_KEY[1];
        ROUND_KEY[2] <= NEXT_KEY[2];
        ROUND_KEY[3] <= NEXT_KEY[3];
        ROUND_KEY[4] <= NEXT_KEY[4];
        ROUND_KEY[5] <= NEXT_KEY[5];
        ROUND_KEY[6] <= NEXT_KEY[6];
        ROUND_KEY[7] <= NEXT_KEY[7];
        ROUND_KEY[8] <= NEXT_KEY[8];
        ROUND_KEY[9] <= NEXT_KEY[9];
    end
end

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        R0_OUT_DATA <= 128'b0;
        round_counter <= 4'b0;
    end else if (valid_round) begin
        R0_OUT_DATA <= IN_DATA ^ IN_KEY;
        round_counter <= round_counter + 1;
    end
end

// 生成轮迭代
generate
    genvar j;
    for (j = 0; j < 10; j = j + 1) begin : ROUND_ITER
        if (j == 0) begin
            ROUND_ITERATION R(
                .IN_DATA(R0_OUT_DATA), 
                .IN_KEY(ROUND_KEY[j]), 
                .LAST_ROUND_FLAG(1'b0), 
                .OUT_DATA(ROUND_OUT_DATA[j])
            );
        end else if (j == 9) begin
            ROUND_ITERATION R(
                .IN_DATA(ROUND_OUT_DATA[j-1]), 
                .IN_KEY(ROUND_KEY[j]), 
                .LAST_ROUND_FLAG(1'b1), 
                .OUT_DATA(ROUND_OUT_DATA[j])
            );
        end else begin
            ROUND_ITERATION R(
                .IN_DATA(ROUND_OUT_DATA[j-1]), 
                .IN_KEY(ROUND_KEY[j]), 
                .LAST_ROUND_FLAG(1'b0), 
                .OUT_DATA(ROUND_OUT_DATA[j])
            );
        end
    end
endgenerate

// 输出每轮的密钥和加密后的数据
assign round_key_0 = IN_KEY;
assign round_key_1 = ROUND_KEY[0];
assign round_key_2 = ROUND_KEY[1];
assign round_key_3 = ROUND_KEY[2];
assign round_key_4 = ROUND_KEY[3];
assign round_key_5 = ROUND_KEY[4];
assign round_key_6 = ROUND_KEY[5];
assign round_key_7 = ROUND_KEY[6];
assign round_key_8 = ROUND_KEY[7];
assign round_key_9 = ROUND_KEY[8];
assign round_key_10 = ROUND_KEY[9];

assign round_data_0 = R0_OUT_DATA;
assign round_data_1 = ROUND_OUT_DATA[0];
assign round_data_2 = ROUND_OUT_DATA[1];
assign round_data_3 = ROUND_OUT_DATA[2];
assign round_data_4 = ROUND_OUT_DATA[3];
assign round_data_5 = ROUND_OUT_DATA[4];
assign round_data_6 = ROUND_OUT_DATA[5];
assign round_data_7 = ROUND_OUT_DATA[6];
assign round_data_8 = ROUND_OUT_DATA[7];
assign round_data_9 = ROUND_OUT_DATA[8];
assign round_data_10 = ROUND_OUT_DATA[9];

assign OUT_DATA = valid_out ? ROUND_OUT_DATA[9] : 128'b0;

endmodule