module ROUND_ITERATION(
    input [127:0] IN_DATA,
    input [127:0] IN_KEY,
    // input [3:0] Round, // 标志当前轮次
    input LAST_ROUND_FLAG, // 标志是否是最后一轮
    output [127:0] OUT_DATA
);

wire [127:0] SB_DATA;
wire [127:0] SHIFT_DATA;
wire [127:0] MIXED_DATA;
// wire [127:0] ADD_KEY_DATA;

// 实例化子模块
SUB_BYTES SB(
    .IN_DATA(IN_DATA), 
    .SB_DATA(SB_DATA)
);

SHIFT_ROWS SR(
    .IN_DATA(SB_DATA), 
    .SHIFT_DATA(SHIFT_DATA)
);

MIX_COLUMNS MC(
    .IN_DATA(SHIFT_DATA), 
    .MIXED_DATA(MIXED_DATA)
);

// assign OUT_DATA = MIXED_DATA ^ IN_KEY;
// 根据 LAST_ROUND_FLAG 选择是否进行列混合操作
assign OUT_DATA = LAST_ROUND_FLAG ? (SHIFT_DATA ^ IN_KEY) : (MIXED_DATA ^ IN_KEY);


endmodule