// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : exu.v
// Author        : Rongye
// Created On    : 2022-12-25 03:08
// Last Modified : 2024-08-12 08:23
// ---------------------------------------------------------------------------------
// Description   :
//
//
// -FHDR----------------------------------------------------------------------------
module EXU(
// global 
    input  wire                             clk,
    input  wire                             rst_n,          
    input  wire                             enable,          
// IDU2EXU
    input  wire                             idu2exu_en,
    input  wire [`CPU_WIDTH         -1:0]   idu2exu_pc,
    input  wire [`CPU_WIDTH         -1:0]   idu2exu_inst,

    input  wire [`BRAN_WIDTH        -1:0]   idu2exu_branch,     
    input  wire [`JUMP_WIDTH        -1:0]   idu2exu_jump,       

    input  wire                             idu2exu_reg_wen,    
    input  wire [`REG_ADDR_WIDTH    -1:0]   idu2exu_reg_waddr,  

    input  wire                             idu2exu_mem_wen,    
    input  wire [`DATA_MEM_ADDR_WIDTH-1:0]  idu2exu_mem_waddr,     
    input  wire                             idu2exu_mem_ren,    
    input  wire [`DATA_MEM_ADDR_WIDTH-1:0]  idu2exu_mem_raddr,     

    input  wire                             idu2exu_mem2reg,    
    input  wire [`MEM_OP_WIDTH      -1:0]   idu2exu_mem_op,     

    input  wire [`ALU_OP_WIDTH      -1:0]   idu2exu_alu_op,     
    input  wire [`CPU_WIDTH         -1:0]   idu2exu_alu_src1,
    input  wire [`CPU_WIDTH         -1:0]   idu2exu_alu_src2,

    output  reg [`CPU_WIDTH         -1:0]   alu_res

);

localparam DLY = 0.1;

always @(*) begin
wire alu_op   = idu2exu_alu_op;     // default select reg2 data
wire alu_src1 = idu2exu_alu_src1;     // defalut select reg1 data
wire alu_src2 = idu2exu_alu_src2;     // default select reg2 data
end

always @(*) begin
    alu_res = `CPU_WIDTH'b0;
    case (alu_op)
        `ALU_AND: 
            alu_res = alu_src1 & alu_src2;
        `ALU_OR: 
            alu_res = alu_src1 | alu_src2;
        `ALU_XOR: 
            alu_res = alu_src1 ^ alu_src2;
        `ALU_ADD: 
            alu_res = alu_src1 + alu_src2;
        `ALU_SUB: 
            alu_res = alu_src1 - alu_src2;
        `ALU_SLL: 
            alu_res = alu_src1 << alu_src2[4:0];
        `ALU_SRL: 
            alu_res = alu_src1 >> alu_src2[4:0];
        `ALU_SRA: 
            alu_res = $signed(alu_src1) >>> alu_src2[4:0];
        `ALU_SLT:
            alu_res = {{(`CPU_WIDTH-1){1'b0}},($signed(alu_src1) < $signed(alu_src2))};
        `ALU_SLTU:
            alu_res = {{(`CPU_WIDTH-1){1'b0}},($unsigned(alu_src1) < $unsigned(alu_src2))};
        `ALU_EQU: 
            alu_res = {{(`CPU_WIDTH-1){1'b0}},(alu_src1 == alu_src2)};
    endcase
end
endmodule

