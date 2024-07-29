// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : exu.v
// Author        : Rongye
// Created On    : 2022-12-25 03:08
// Last Modified : 2024-07-29 06:14
// ---------------------------------------------------------------------------------
// Description   :
//
//
// -FHDR----------------------------------------------------------------------------
module EXU(
// global 
    input  wire                             clk,
    input  wire                             rst_n,          // active low
    input  wire                             enable,          // rvseed enable ctrl
// IDU2EXU
    input  wire                             idu_done_en,
    input  wire [`CPU_WIDTH           -1:0] idu_inst_pc,
    input  wire [`CPU_WIDTH           -1:0] idu_inst,

    input  wire [`BRAN_WIDTH          -1:0] idu_inst_branch,     // branch flag
    input  wire [`JUMP_WIDTH          -1:0] idu_inst_jump,       // jump flag

    input  wire                             idu_inst_reg_wen,    // register write enable
    input  wire [`REG_ADDR_WIDTH      -1:0] idu_inst_reg_waddr,  // register write address
    input  wire [`REG_ADDR_WIDTH      -1:0] idu_inst_reg1_raddr, // register 1 read address
    input  wire [`REG_ADDR_WIDTH      -1:0] idu_inst_reg2_raddr, // register 2 read address

    input  wire                             idu_inst_mem_wen,    // memory write enable
    input  wire                             idu_inst_mem_ren,    // memory read enable
    input  wire                             idu_inst_mem2reg,    // memory to register flag
    input  wire [`MEM_OP_WIDTH        -1:0] idu_inst_mem_op,     // memory opcode

    input  wire [`CPU_WIDTH           -1:0] idu_inst_imm,        // immediate value

    input  wire [`ALU_OP_WIDTH        -1:0] idu_inst_alu_op,     // alu opcode
    input  wire [`ALU_SRC_WIDTH       -1:0] idu_inst_alu_src_sel // alu source select flag
);

localparam DLY = 0.1;

MUX_ALU U_MUX_ALU(
    .alu_src_sel                    ( idu_inst_alu_src_sel                   ),
    .reg1_rdata                     ( reg1_rdata                    ),
    .reg2_rdata                     ( reg2_rdata                    ),
    .imm                            ( imm                           ),
    .curr_pc                        ( curr_pc                       ),
    .alu_src1                       ( alu_src1                      ),
    .alu_src2                       ( alu_src2                      )
);

ALU U_ALU(
    .alu_op                         ( alu_op                        ),
    .alu_src1                       ( alu_src1                      ),
    .alu_src2                       ( alu_src2                      ),
    .zero                           ( zero                          ),
    .alu_res                        ( alu_res                       )
);
endmodule

