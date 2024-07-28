//--------------------------------------------------------------------------------
// RISCV_INST_R
//--------------------------------------------------------------------------------
// Width define
`define RISCV_INST_R_OPCODE_W                       7
`define RISCV_INST_R_RD_W                           5
`define RISCV_INST_R_FUNCT3_W                       3
`define RISCV_INST_R_RS1_W                          5
`define RISCV_INST_R_RS2_W                          5
`define RISCV_INST_R_FUNCT7_W                       7

// Position define
`define RISCV_INST_R_OPCODE_LSB                     0
`define RISCV_INST_R_OPCODE_MSB                    (`RISCV_INST_R_OPCODE_W-1)    +`RISCV_INST_R_OPCODE_LSB
`define RISCV_INST_R_OPCODE                         `RISCV_INST_R_OPCODE_MSB     :`RISCV_INST_R_OPCODE_LSB

`define RISCV_INST_R_RD_LSB                         `RISCV_INST_R_OPCODE_MSB
`define RISCV_INST_R_RD_MSB                        (`RISCV_INST_R_RD_W-1)        +`RISCV_INST_R_RD_LSB
`define RISCV_INST_R_RD                             `RISCV_INST_R_RD_MSB         :`RISCV_INST_R_RD_LSB

`define RISCV_INST_R_FUNCT3_LSB                     `RISCV_INST_R_RD_MSB
`define RISCV_INST_R_FUNCT3_MSB                    (`RISCV_INST_R_FUNCT3_W-1)    +`RISCV_INST_R_FUNCT3_LSB
`define RISCV_INST_R_FUNCT3                         `RISCV_INST_R_FUNCT3_MSB     :`RISCV_INST_R_FUNCT3_LSB

`define RISCV_INST_R_RS1_LSB                        `RISCV_INST_R_FUNCT3_MSB
`define RISCV_INST_R_RS1_MSB                       (`RISCV_INST_R_RS1_W-1)       +`RISCV_INST_R_RS1_LSB
`define RISCV_INST_R_RS1                            `RISCV_INST_R_RS1_MSB        :`RISCV_INST_R_RS1_LSB

`define RISCV_INST_R_RS2_LSB                        `RISCV_INST_R_RS1_MSB
`define RISCV_INST_R_RS2_MSB                       (`RISCV_INST_R_RS2_W-1)       +`RISCV_INST_R_RS2_LSB
`define RISCV_INST_R_RS2                            `RISCV_INST_R_RS2_MSB        :`RISCV_INST_R_RS2_LSB

`define RISCV_INST_R_FUNCT7_LSB                     `RISCV_INST_R_RS2_MSB
`define RISCV_INST_R_FUNCT7_MSB                    (`RISCV_INST_R_FUNCT7_W-1)    +`RISCV_INST_R_FUNCT7_LSB
`define RISCV_INST_R_FUNCT7                         `RISCV_INST_R_FUNCT7_MSB     :`RISCV_INST_R_FUNCT7_LSB

//--------------------------------------------------------------------------------
// RISCV_INST_I
//--------------------------------------------------------------------------------
// Width define
`define RISCV_INST_I_OPCODE_W                       7
`define RISCV_INST_I_RD_W                           5
`define RISCV_INST_I_FUNCT3_W                       3
`define RISCV_INST_I_RS1_W                          5
`define RISCV_INST_I_IMM_W                          12

// Position define
`define RISCV_INST_I_OPCODE_LSB                     0
`define RISCV_INST_I_OPCODE_MSB                    (`RISCV_INST_I_OPCODE_W-1)    +`RISCV_INST_I_OPCODE_LSB
`define RISCV_INST_I_OPCODE                         `RISCV_INST_I_OPCODE_MSB     :`RISCV_INST_I_OPCODE_LSB

`define RISCV_INST_I_RD_LSB                         `RISCV_INST_I_OPCODE_MSB
`define RISCV_INST_I_RD_MSB                        (`RISCV_INST_I_RD_W-1)        +`RISCV_INST_I_RD_LSB
`define RISCV_INST_I_RD                             `RISCV_INST_I_RD_MSB         :`RISCV_INST_I_RD_LSB

`define RISCV_INST_I_FUNCT3_LSB                     `RISCV_INST_I_RD_MSB
`define RISCV_INST_I_FUNCT3_MSB                    (`RISCV_INST_I_FUNCT3_W-1)    +`RISCV_INST_I_FUNCT3_LSB
`define RISCV_INST_I_FUNCT3                         `RISCV_INST_I_FUNCT3_MSB     :`RISCV_INST_I_FUNCT3_LSB

`define RISCV_INST_I_RS1_LSB                        `RISCV_INST_I_FUNCT3_MSB
`define RISCV_INST_I_RS1_MSB                       (`RISCV_INST_I_RS1_W-1)       +`RISCV_INST_I_RS1_LSB
`define RISCV_INST_I_RS1                            `RISCV_INST_I_RS1_MSB        :`RISCV_INST_I_RS1_LSB

`define RISCV_INST_I_IMM_LSB                        `RISCV_INST_I_RS1_MSB
`define RISCV_INST_I_IMM_MSB                       (`RISCV_INST_I_IMM_W-1)       +`RISCV_INST_I_IMM_LSB
`define RISCV_INST_I_IMM                            `RISCV_INST_I_IMM_MSB        :`RISCV_INST_I_IMM_LSB

//--------------------------------------------------------------------------------
// RISCV_INST_S
//--------------------------------------------------------------------------------
// Width define
`define RISCV_INST_S_OPCODE_W                       7
`define RISCV_INST_S_IMM_0_W                        5
`define RISCV_INST_S_FUNCT3_W                       3
`define RISCV_INST_S_RS1_W                          5
`define RISCV_INST_S_RS2_W                          5
`define RISCV_INST_S_IMM_1_W                        7

// Position define
`define RISCV_INST_S_OPCODE_LSB                     0
`define RISCV_INST_S_OPCODE_MSB                    (`RISCV_INST_S_OPCODE_W-1)    +`RISCV_INST_S_OPCODE_LSB
`define RISCV_INST_S_OPCODE                         `RISCV_INST_S_OPCODE_MSB     :`RISCV_INST_S_OPCODE_LSB

`define RISCV_INST_S_IMM_0_LSB                      `RISCV_INST_S_OPCODE_MSB
`define RISCV_INST_S_IMM_0_MSB                     (`RISCV_INST_S_IMM_0_W-1)     +`RISCV_INST_S_IMM_0_LSB
`define RISCV_INST_S_IMM_0                          `RISCV_INST_S_IMM_0_MSB      :`RISCV_INST_S_IMM_0_LSB

`define RISCV_INST_S_FUNCT3_LSB                     `RISCV_INST_S_IMM_0_MSB
`define RISCV_INST_S_FUNCT3_MSB                    (`RISCV_INST_S_FUNCT3_W-1)    +`RISCV_INST_S_FUNCT3_LSB
`define RISCV_INST_S_FUNCT3                         `RISCV_INST_S_FUNCT3_MSB     :`RISCV_INST_S_FUNCT3_LSB

`define RISCV_INST_S_RS1_LSB                        `RISCV_INST_S_FUNCT3_MSB
`define RISCV_INST_S_RS1_MSB                       (`RISCV_INST_S_RS1_W-1)       +`RISCV_INST_S_RS1_LSB
`define RISCV_INST_S_RS1                            `RISCV_INST_S_RS1_MSB        :`RISCV_INST_S_RS1_LSB

`define RISCV_INST_S_RS2_LSB                        `RISCV_INST_S_RS1_MSB
`define RISCV_INST_S_RS2_MSB                       (`RISCV_INST_S_RS2_W-1)       +`RISCV_INST_S_RS2_LSB
`define RISCV_INST_S_RS2                            `RISCV_INST_S_RS2_MSB        :`RISCV_INST_S_RS2_LSB

`define RISCV_INST_S_IMM_1_LSB                      `RISCV_INST_S_RS2_MSB
`define RISCV_INST_S_IMM_1_MSB                     (`RISCV_INST_S_IMM_1_W-1)     +`RISCV_INST_S_IMM_1_LSB
`define RISCV_INST_S_IMM_1                          `RISCV_INST_S_IMM_1_MSB      :`RISCV_INST_S_IMM_1_LSB

