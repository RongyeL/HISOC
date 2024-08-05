// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : idu2exu.v
// Author        : Rongye
// Created On    : 2024-08-05 06:09
// Last Modified : 2024-08-05 08:47
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module IDU2EXU (
    input  wire                             clk,
    input  wire                             rst_n,             
// IDU2EXU
    input  wire                             idu2exu_en,
    input  wire [`CPU_WIDTH         -1:0]   idu2exu_pc,
    input  wire [`CPU_WIDTH         -1:0]   idu2exu_inst,

    input  wire [`BRAN_WIDTH        -1:0]   idu2exu_branch,     // branch flag
    input  wire [`JUMP_WIDTH        -1:0]   idu2exu_jump,       // jump flag

    input  wire                             idu2exu_reg_wen,    // register write enable
    input  wire [`REG_ADDR_WIDTH    -1:0]   idu2exu_reg_waddr,  // register write address
    input  wire [`REG_ADDR_WIDTH    -1:0]   idu2exu_reg1_raddr, // register 1 read address
    input  wire [`REG_ADDR_WIDTH    -1:0]   idu2exu_reg2_raddr, // register 2 read address

    input  wire                             idu2exu_mem_wen,    // memory write enable
    input  wire                             idu2exu_mem_ren,    // memory read enable
    input  wire                             idu2exu_mem2reg,    // memory to register flag
    input  wire [`MEM_OP_WIDTH      -1:0]   idu2exu_mem_op,     // memory opcode

    input  wire [`CPU_WIDTH         -1:0]   idu2exu_imm,        // immediate value

    input  wire [`ALU_OP_WIDTH      -1:0]   idu2exu_alu_op,     // alu opcode
    input  wire [`ALU_SRC_WIDTH     -1:0]   idu2exu_alu_src_sel, // alu source select flag

    output reg                              idu2exu_en_r,
    output reg  [`CPU_WIDTH         -1:0]   idu2exu_pc_r,
    output reg  [`CPU_WIDTH         -1:0]   idu2exu_inst_r,
    
    output reg  [`BRAN_WIDTH        -1:0]   idu2exu_branch_r,
    output reg  [`JUMP_WIDTH        -1:0]   idu2exu_jump_r,
    
    output reg                              idu2exu_reg_wen_r,
    output reg  [`REG_ADDR_WIDTH    -1:0]   idu2exu_reg_waddr_r,
    output reg  [`REG_ADDR_WIDTH    -1:0]   idu2exu_reg1_raddr_r,
    output reg  [`REG_ADDR_WIDTH    -1:0]   idu2exu_reg2_raddr_r,
    
    output reg                              idu2exu_mem_wen_r,
    output reg                              idu2exu_mem_ren_r,
    output reg                              idu2exu_mem2reg_r,
    output reg  [`MEM_OP_WIDTH      -1:0]   idu2exu_mem_op_r,
    
    output reg  [`CPU_WIDTH         -1:0]   idu2exu_imm_r,
    
    output reg  [`ALU_OP_WIDTH      -1:0]   idu2exu_alu_op_r,
    output reg  [`ALU_SRC_WIDTH     -1:0]   idu2exu_alu_src_sel_r
);
localparam DLY = 0.1;

// IDU2EXU Register 
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        idu2exu_en_r <= #DLY 1'b0;
    end
    else begin
        idu2exu_en_r <= #DLY idu2exu_en;
    end
end
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        idu2exu_pc_r   <= #DLY `CPU_WIDTH'b0;
        idu2exu_inst_r <= #DLY `CPU_WIDTH'b0;
    end
    else if (idu2exu_en) begin
        idu2exu_pc_r   <= #DLY idu2exu_pc ;
        idu2exu_inst_r <= #DLY idu2exu_inst ;
    end
end 

always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        idu2exu_branch_r      <= #DLY {`BRAN_WIDTH{1'b0}};
        idu2exu_jump_r        <= #DLY {`JUMP_WIDTH{1'b0}};
        idu2exu_reg_wen_r     <= #DLY 1'b0;
        idu2exu_reg_waddr_r   <= #DLY {`REG_ADDR_WIDTH{1'b0}};
        idu2exu_reg1_raddr_r  <= #DLY {`REG_ADDR_WIDTH{1'b0}};
        idu2exu_reg2_raddr_r  <= #DLY {`REG_ADDR_WIDTH{1'b0}};
        idu2exu_mem_wen_r     <= #DLY 1'b0;
        idu2exu_mem_ren_r     <= #DLY 1'b0;
        idu2exu_mem2reg_r     <= #DLY 1'b0;
        idu2exu_mem_op_r      <= #DLY {`MEM_OP_WIDTH{1'b0}};
        idu2exu_imm_r         <= #DLY {`CPU_WIDTH{1'b0}};
        idu2exu_alu_op_r      <= #DLY {`ALU_OP_WIDTH{1'b0}};
        idu2exu_alu_src_sel_r <= #DLY {`ALU_SRC_WIDTH{1'b0}};
    end
    else if (idu2exu_en) begin
        idu2exu_branch_r      <= #DLY idu2exu_branch;
        idu2exu_jump_r        <= #DLY idu2exu_jump;
        idu2exu_reg_wen_r     <= #DLY idu2exu_reg_wen;
        idu2exu_reg_waddr_r   <= #DLY idu2exu_reg_waddr;
        idu2exu_reg1_raddr_r  <= #DLY idu2exu_reg1_raddr;
        idu2exu_reg2_raddr_r  <= #DLY idu2exu_reg2_raddr;
        idu2exu_mem_wen_r     <= #DLY idu2exu_mem_wen;
        idu2exu_mem_ren_r     <= #DLY idu2exu_mem_ren;
        idu2exu_mem2reg_r     <= #DLY idu2exu_mem2reg;
        idu2exu_mem_op_r      <= #DLY idu2exu_mem_op;
        idu2exu_imm_r         <= #DLY idu2exu_imm;
        idu2exu_alu_op_r      <= #DLY idu2exu_alu_op;
        idu2exu_alu_src_sel_r <= #DLY idu2exu_alu_src_sel;
    end
end 


endmodule
