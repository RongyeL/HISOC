// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : pc_next.v
// Author        : Rongye
// Created On    : 2022-03-21 22:56
// Last Modified : 2024-07-31 08:35
// ---------------------------------------------------------------------------------
// Description   : Determine the update value of the pc. 
//
//
// -FHDR----------------------------------------------------------------------------
module MUX_PC (
    input                        ena,
    input      [`BRAN_WIDTH-1:0] branch,     // branch type 
    input                        zero,       // alu result is zero
    input      [`JUMP_WIDTH-1:0] jump,       // jump type 
    input      [`CPU_WIDTH-1:0]  reg1_rdata, // register 1 read data
    input      [`CPU_WIDTH-1:0]  imm,        // immediate  

    input      [`CPU_WIDTH-1:0]  curr_pc,    // current pc addr
    input      [`CPU_WIDTH-1:0]  idu_inst_pc,    // current pc addr
    output reg [`CPU_WIDTH-1:0]  next_pc     // next pc addr
);


endmodule
