// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : idu.v
// Author        : Rongye
// Created On    : 2022-12-25 03:08
// Last Modified : 2024-07-28 00:29
// ---------------------------------------------------------------------------------
// Description   :
//
//
// -FHDR----------------------------------------------------------------------------
module IDU(
// global 
    input  wire                              clk,
    input  wire                              rst_n,          // active low
    input  wire                              enable,          // rvseed enable ctrl
// IFU2IDU
    input  wire                              ifu_start_en,
    input  wire                              ifu_done_en,
    input  wire [`CPU_WIDTH            -1:0] ifu_inst_pc,
    input  wire [`CPU_WIDTH            -1:0] ifu_inst,
// IDU2EXU
    output wire                              idu_done_en,
    output wire [`CPU_WIDTH            -1:0] idu_inst_pc,
    output wire [`CPU_WIDTH            -1:0] idu_inst,
    output wire [`CPU_WIDTH            -1:0] idu_inst_parse
);

localparam DLY = 0.1;

wire [`BRAN_WIDTH-1:0]       branch;     
wire [`JUMP_WIDTH-1:0]       jump;       
 
wire                         reg_wen;    
wire [`REG_ADDR_WIDTH-1:0]   reg_waddr;  
wire [`REG_ADDR_WIDTH-1:0]   reg1_raddr; 
wire [`REG_ADDR_WIDTH-1:0]   reg2_raddr; 
 
wire                         mem_wen;    
wire                         mem_ren;    
wire                         mem2reg;    
wire [`MEM_OP_WIDTH-1:0]     mem_op;     
 
wire [`IMM_GEN_OP_WIDTH-1:0] imm_gen_op; 
 
wire [`ALU_OP_WIDTH-1:0]     alu_op;     
wire [`ALU_SRC_WIDTH-1:0]    alu_src_sel;

// INST DECODER 
INST_DEC U_INST_DEC(
    .inst          (ifu_inst    ), // instruction input

    .branch        (branch      ), // branch flag
    .jump          (jump        ), // jump flag
    .reg_wen       (reg_wen     ), // register write enable
    .reg_waddr     (reg_waddr   ), // register write address
    .reg1_raddr    (reg1_raddr  ), // register 1 read address
    .reg2_raddr    (reg2_raddr  ), // register 2 read address
    .mem_wen       (mem_wen     ), // memory write enable
    .mem_ren       (mem_ren     ), // memory read enable
    .mem2reg       (mem2reg     ), // memory to register flag
    .mem_op        (mem_op      ), // memory opcode
    .imm_gen_op    (imm_gen_op  ), // immediate extend opcode
    .alu_op        (alu_op      ), // alu opcode
    .alu_src_sel   (alu_src_sel )  // alu source select flag
);
//--------------------------------------------------------------------------------
// Register Payload 
//--------------------------------------------------------------------------------
reg  [`BRAN_WIDTH-1:0]       ifu_inst_pc_r;     
reg  [`BRAN_WIDTH-1:0]       ifu_inst_r;     

reg  [`BRAN_WIDTH-1:0]       branch_r;     
reg  [`JUMP_WIDTH-1:0]       jump_r;       

reg                          reg_wen_r;    
reg  [`REG_ADDR_WIDTH-1:0]   reg_waddr_r;  
reg  [`REG_ADDR_WIDTH-1:0]   reg1_raddr_r; 
reg  [`REG_ADDR_WIDTH-1:0]   reg2_raddr_r; 

reg                          mem_wen_r;    
reg                          mem_ren_r;    
reg                          mem2reg_r;    
reg  [`MEM_OP_WIDTH-1:0]     mem_op_r;     

reg  [`IMM_GEN_OP_WIDTH-1:0] imm_gen_op_r; 

reg  [`ALU_OP_WIDTH-1:0]     alu_op_r;     
reg  [`ALU_SRC_WIDTH-1:0]    alu_src_sel_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ifu_inst_pc_r <= #DLY {`CPU_WIDTH{1'b0}};
        ifu_inst_r    <= #DLY {`CPU_WIDTH{1'b0}};
    end
    else if (ifu_done_en) begin
        ifu_inst_pc_r <= #DLY ifu_inst_pc;      
        ifu_inst_r    <= #DLY ifu_inst;      
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        branch_r      <= #DLY {`BRAN_WIDTH{1'b0}};
        jump_r        <= #DLY {`JUMP_WIDTH{1'b0}};
        reg_wen_r     <= #DLY 1'b0;
        reg_waddr_r   <= #DLY {`REG_ADDR_WIDTH{1'b0}};
        reg1_raddr_r  <= #DLY {`REG_ADDR_WIDTH{1'b0}};
        reg2_raddr_r  <= #DLY {`REG_ADDR_WIDTH{1'b0}};
        mem_wen_r     <= #DLY 1'b0;
        mem_ren_r     <= #DLY 1'b0;
        mem2reg_r     <= #DLY 1'b0;
        mem_op_r      <= #DLY {`MEM_OP_WIDTH{1'b0}};
        imm_gen_op_r  <= #DLY {`IMM_GEN_OP_WIDTH{1'b0}};
        alu_op_r      <= #DLY {`ALU_OP_WIDTH{1'b0}};
        alu_src_sel_r <= #DLY {`ALU_SRC_WIDTH{1'b0}};
    end
    else if (ifu_done_en) begin
        branch_r      <= #DLY branch;      
        jump_r        <= #DLY jump;        
        reg_wen_r     <= #DLY reg_wen;     
        reg_waddr_r   <= #DLY reg_waddr;   
        reg1_raddr_r  <= #DLY reg1_raddr;  
        reg2_raddr_r  <= #DLY reg2_raddr;  
        mem_wen_r     <= #DLY mem_wen;     
        mem_ren_r     <= #DLY mem_ren;     
        mem2reg_r     <= #DLY mem2reg;     
        mem_op_r      <= #DLY mem_op;      
        imm_gen_op_r  <= #DLY imm_gen_op;  
        alu_op_r      <= #DLY alu_op;      
        alu_src_sel_r <= #DLY alu_src_sel; 
    end
end

//--------------------------------------------------------------------------------
// Output Signal
//--------------------------------------------------------------------------------



endmodule

