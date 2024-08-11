// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : idu.v
// Author        : Rongye
// Created On    : 2022-12-25 03:08
// Last Modified : 2024-08-11 06:45
// ---------------------------------------------------------------------------------
// Description   :
//
//
// -FHDR----------------------------------------------------------------------------
module IDU(
// global 
    input  wire                            clk,
    input  wire                            rst_n,          // active low
    input  wire                            enable,          // rvseed enable ctrl

// IFU2IDU
    input  wire                            ifu2idu_en,
    input  wire [`CPU_WIDTH          -1:0] ifu2idu_pc,
    input  wire [`CPU_WIDTH          -1:0] ifu2idu_inst,
// IDU2EXU
    output wire                            idu2exu_en,
    output wire [`CPU_WIDTH          -1:0] idu2exu_pc,
    output wire [`CPU_WIDTH          -1:0] idu2exu_inst,

    output reg [`BRAN_WIDTH          -1:0] idu2exu_branch,     // branch flag
    output reg [`JUMP_WIDTH          -1:0] idu2exu_jump,       // jump flag

    output reg                             idu2exu_reg_wen,    // register write enable
    output reg [`REG_ADDR_WIDTH      -1:0] idu2exu_reg_waddr,  // register write address
    output reg [`REG_ADDR_WIDTH      -1:0] idu2exu_reg1_raddr, // register 1 read address
    output reg [`REG_ADDR_WIDTH      -1:0] idu2exu_reg2_raddr, // register 2 read address
       
    output reg                             idu2exu_mem_wen,    // memory write enable
    output reg                             idu2exu_mem_ren,    // memory read enable
    output reg                             idu2exu_mem2reg,    // memory to register flag
    output reg [`MEM_OP_WIDTH        -1:0] idu2exu_mem_op,     // memory opcode
     
    output reg [`CPU_WIDTH           -1:0] idu2exu_imm,        // immediate value

    output reg [`ALU_OP_WIDTH        -1:0] idu2exu_alu_op,     // alu opcode
    output reg [`ALU_SRC_WIDTH       -1:0] idu2exu_alu_src_sel,// alu source select flag
    input  wire                            exu2idu_branch_en,
    input  wire                            exu2idu_jump_en
);

localparam DLY = 0.1;

wire [`CPU_WIDTH        -1:0]   inst; 
wire [`BRAN_WIDTH       -1:0]   branch;     
wire [`JUMP_WIDTH       -1:0]   jump;       
 
wire                            reg_wen;    
wire [`REG_ADDR_WIDTH   -1:0]   reg_waddr;  
wire [`REG_ADDR_WIDTH   -1:0]   reg1_raddr; 
wire [`REG_ADDR_WIDTH   -1:0]   reg2_raddr; 
 
wire                            mem_wen;    
wire                            mem_ren;    
wire                            mem2reg;    
wire [`MEM_OP_WIDTH     -1:0]   mem_op;     
 
wire [`CPU_WIDTH        -1:0]   imm; 
 
wire [`ALU_OP_WIDTH     -1:0]   alu_op;     
wire [`ALU_SRC_WIDTH    -1:0]   alu_src_sel;

// INST DECODER 
assign inst = ifu2idu_inst;
INST_DEC U_INST_DEC(
    .inst           (inst            ), // instruction input

    .branch         (branch          ), // branch flag
    .jump           (jump            ), // jump flag
    .reg_wen        (reg_wen         ), // register write enable
    .reg_waddr      (reg_waddr       ), // register write address
    .reg1_raddr     (reg1_raddr      ), // register 1 read address
    .reg2_raddr     (reg2_raddr      ), // register 2 read address
    .mem_wen        (mem_wen         ), // memory write enable
    .mem_ren        (mem_ren         ), // memory read enable
    .mem2reg        (mem2reg         ), // memory to register flag
    .mem_op         (mem_op          ), // memory opcode
    .imm            (imm             ), // immediate extend opcode
    .alu_op         (alu_op          ), // alu opcode
    .alu_src_sel    (alu_src_sel     )  // alu source select flag
);

//--------------------------------------------------------------------------------
// Output Signal
//--------------------------------------------------------------------------------
assign idu2exu_en       = ifu2idu_en;
assign idu2exu_pc       = ifu2idu_pc;
assign idu2exu_inst     = ifu2idu_inst;
always @(*) begin
    idu2exu_branch      = branch;
    idu2exu_jump        = jump;
    idu2exu_reg_wen     = reg_wen;
    idu2exu_reg_waddr   = reg_waddr;
    idu2exu_reg1_raddr  = reg1_raddr;
    idu2exu_reg2_raddr  = reg2_raddr;
    idu2exu_mem_wen     = mem_wen;
    idu2exu_mem_ren     = mem_ren;
    idu2exu_mem2reg     = mem2reg;
    idu2exu_mem_op      = mem_op;
    idu2exu_imm         = imm;
    idu2exu_alu_op      = alu_op;
    idu2exu_alu_src_sel = alu_src_sel;
end
endmodule

