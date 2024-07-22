// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : rvseed.v
// Author        : Rongye
// Created On    : 2022-03-25 03:42
// Last Modified : 2022-12-22 06:16
// ---------------------------------------------------------------------------------
// Description   : rvseed cpu top module.
//                 
//
// -FHDR----------------------------------------------------------------------------
`include "rvseed_defines.v"

module rvseed (
    input clk,
    input rst_n
);

wire                         ena;
wire [`CPU_WIDTH-1:0]        curr_pc;    // current pc addr
wire [`CPU_WIDTH-1:0]        next_pc;    // next pc addr

wire [`BRAN_WIDTH-1:0]       branch;     // branch flag
wire                         zero;       // alu result is zero
wire [`JUMP_WIDTH-1:0]       jump;       // jump flag

wire [`CPU_WIDTH-1:0]        inst;       // instruction

wire                         reg_wen;    // register write enable
wire [`REG_ADDR_WIDTH-1:0]   reg_waddr;  // register write address
wire [`CPU_WIDTH-1:0]        reg_wdata;  // register write data
wire [`REG_ADDR_WIDTH-1:0]   reg1_raddr; // register 1 read address
wire [`REG_ADDR_WIDTH-1:0]   reg2_raddr; // register 2 read address
wire [`CPU_WIDTH-1:0]        reg1_rdata; // register 1 read data
wire [`CPU_WIDTH-1:0]        reg2_rdata; // register 2 read data

wire                         mem_wen;    // memory write enable
wire                         mem_ren;    // memory read enable
wire                         mem2reg;    // memory to register flag
wire [`MEM_OP_WIDTH-1:0]     mem_op;     // memory opcode
wire [`CPU_WIDTH-1:0]        mem_addr;   // memory write/ read address
wire [`CPU_WIDTH-1:0]        mem_wdata;  // memory write data input
wire [`CPU_WIDTH-1:0]        mem_rdata;  // memory read data output


wire [`IMM_GEN_OP_WIDTH-1:0] imm_gen_op; // immediate extend opcode
wire [`CPU_WIDTH-1:0]        imm;        // immediate

wire [`ALU_OP_WIDTH-1:0]     alu_op;     // alu opcode
wire [`ALU_SRC_WIDTH-1:0]    alu_src_sel;// alu source select flag
wire [`CPU_WIDTH-1:0]        alu_src1;   // alu source 1
wire [`CPU_WIDTH-1:0]        alu_src2;   // alu source 2
wire [`CPU_WIDTH-1:0]        alu_res;    // alu result


pc_reg u_pc_reg_0(
    .clk                            ( clk                           ),
    .rst_n                          ( rst_n                         ),
    .ena                            ( ena                           ),
    .next_pc                        ( next_pc                       ),
    .curr_pc                        ( curr_pc                       )
);

mux_pc u_mux_pc_0(
    .ena                            ( ena                           ),
    .branch                         ( branch                        ),
    .zero                           ( zero                          ),
    .jump                           ( jump                          ),
    .imm                            ( imm                           ),
    .reg1_rdata                     ( reg1_rdata                    ),
    .curr_pc                        ( curr_pc                       ),
    .next_pc                        ( next_pc                       )
);

inst_mem u_inst_mem_0(
    .curr_pc                        ( curr_pc                       ),
    .inst                           ( inst                          )
);
ctrl u_ctrl_0(
    .inst                           ( inst                          ),
    .branch                         ( branch                        ),
    .jump                           ( jump                          ),
    .reg_wen                        ( reg_wen                       ),
    .reg_waddr                      ( reg_waddr                     ),
    .reg1_raddr                     ( reg1_raddr                    ),
    .reg2_raddr                     ( reg2_raddr                    ),
    .mem_wen                        ( mem_wen                       ),
    .mem_ren                        ( mem_ren                       ),
    .mem2reg                        ( mem2reg                       ),
    .mem_op                         ( mem_op                        ),
    .imm_gen_op                     ( imm_gen_op                    ),
    .alu_op                         ( alu_op                        ),
    .alu_src_sel                    ( alu_src_sel                   )
);

reg_file u_reg_file_0(
    .clk                            ( clk                           ),
    .rst_n                          ( rst_n                         ),
    .reg_wen                        ( reg_wen                       ),
    .reg_waddr                      ( reg_waddr                     ),
    .reg_wdata                      ( reg_wdata                     ),
    .reg1_raddr                     ( reg1_raddr                    ),
    .reg2_raddr                     ( reg2_raddr                    ),
    .reg1_rdata                     ( reg1_rdata                    ),
    .reg2_rdata                     ( reg2_rdata                    )
);

imm_gen u_imm_gen_0(
    .inst                           ( inst                          ),
    .imm_gen_op                     ( imm_gen_op                    ),
    .imm                            ( imm                           )
);

mux_alu u_mux_alu_0(
    .alu_src_sel                    ( alu_src_sel                   ),
    .reg1_rdata                     ( reg1_rdata                    ),
    .reg2_rdata                     ( reg2_rdata                    ),
    .imm                            ( imm                           ),
    .curr_pc                        ( curr_pc                       ),
    .alu_src1                       ( alu_src1                      ),
    .alu_src2                       ( alu_src2                      )
);

alu u_alu_0(
    .alu_op                         ( alu_op                        ),
    .alu_src1                       ( alu_src1                      ),
    .alu_src2                       ( alu_src2                      ),
    .zero                           ( zero                          ),
    .alu_res                        ( alu_res                       )
);

assign mem_addr = alu_res; 
mux_mem u_mux_mem_0(
    .mem_op                         ( mem_op                        ),
    .mem_addr                       ( mem_addr                      ),
    .reg2_rdata                     ( reg2_rdata                    ),
    .mem_rdata                      ( mem_rdata                     ),
    .mem_wdata                      ( mem_wdata                     )
);

data_mem u_data_mem_0(
    .clk                            ( clk                           ),
    .mem_wen                        ( mem_wen                       ),
    .mem_ren                        ( mem_ren                       ),
    .mem_addr                       ( mem_addr                      ),
    .mem_wdata                      ( mem_wdata                     ),
    .mem_rdata                      ( mem_rdata                     )
);

mux_reg u_mux_reg_0(
    .mem2reg                        ( mem2reg                       ),
    .alu_res                        ( alu_res                       ),
    .mem_op                         ( mem_op                        ),
    .mem_addr                       ( mem_addr                      ),
    .mem_rdata                      ( mem_rdata                     ),
    .reg_wdata                      ( reg_wdata                     )
);


endmodule
