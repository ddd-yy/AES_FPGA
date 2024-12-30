# AES128 加密模块

该仓库包含 AES128 加密算法的 Verilog 实现。顶层模块是 `AES128`，它协调密钥生成和加密轮次。项目结构和每个模块的功能如下所述。

## 模块描述

### [`aes_top.v`](aes_top.v)

顶层模块 `AES128` 协调 AES 加密过程。它包括密钥生成和加密轮次。

- **输入:**
  - `clk`: 时钟信号
  - `resetn`: 复位信号（低电平有效）
  - `valid_key_gen`: 触发密钥生成的信号
  - `valid_round`: 触发加密轮次的信号
  - `valid_out`: 输出最终加密数据的信号
  - `IN_DATA`: 要加密的输入数据
  - `IN_KEY`: 加密用的输入密钥

- **输出:**
  - `OUT_DATA`: 最终加密数据
  - `round_key_0` 到 `round_key_10`: 密钥扩展过程中生成的轮密钥
  - `round_data_0` 到 `round_data_10`: 每轮加密后的数据

### [`generate_key.v`](generate_key.v)

`GENERATE_KEY` 模块生成 AES 加密过程中所需的轮密钥。它使用 `S_BOX` 函数进行字节替换，并使用 `RCON` 函数生成轮常数。

### [`mix_columns.v`](mix_columns.v)

`MIX_COLUMNS` 模块执行 MixColumns 转换，这是 AES 加密过程的一部分。它混合状态矩阵的列。

### [`round_iteration.v`](round_iteration.v)

`ROUND_ITERATION` 模块执行 AES 加密过程中的一轮。它包括 SubBytes、ShiftRows 和 MixColumns 转换，并添加轮密钥。

### [`shift_rows.v`](shift_rows.v)

`SHIFT_ROWS` 模块执行 ShiftRows 转换，它移动状态矩阵的行。

### [`sub_bytes.v`](sub_bytes.v)

`SUB_BYTES` 模块执行 SubBytes 转换，它使用 S-box 替换状态矩阵中的每个字节。

### [`tb_top.v`](tb_top.v)

`testbench` 模块用于测试 AES128 加密算法。它生成时钟和复位信号，并提供输入数据和密钥进行加密。

### [`testAES.py`](testAES.py)

用于验证 Verilog 实现的 AES 加密算法正确性的 Python 脚本。它使用 PyCryptodome 库执行 AES 加密，并将结果与 Verilog 实现进行比较。

### [`testEncryption.txt`](testEncryption.txt)

包含 AES 加密算法测试向量的文本文件。它包括明文、密钥和预期的密文。

## 使用方法

1. **仿真:**
   - 使用 ModelSim 等 Verilog 仿真器仿真 [`tb_top.v`](tb_top.v) 测试平台。
   - 测试平台将生成时钟和复位信号，并提供输入数据和密钥进行加密。
   - 仿真结果将显示在控制台中。

2. **验证:**
   - 运行 [`testAES.py`](testAES.py) 脚本以验证 Verilog 实现的正确性。
   - 该脚本将使用 PyCryptodome 库执行 AES 加密，并将结果与 Verilog 实现进行比较。

## 许可证

该项目根据 MIT 许可证授权。有关详细信息，请参阅 LICENSE 文件。

---

此 README 提供了 AES128 加密模块及其组件的概述。有关更详细的信息，请参阅每个模块中的源代码和注释。

## 版权说明

版权所有 © 2024 DongYu。保留所有权利。
