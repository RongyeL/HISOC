// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : idu.v
// Author        : Rongye
// Created On    : 2022-12-25 03:08
// Last Modified : 2024-07-31 09:18
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
    input  wire                            ifu_done_en,
    input  wire [`CPU_WIDTH          -1:0] ifu_inst_pc,
    input  wire [`CPU_WIDTH          -1:0] ifu_inst,
// IDU2EXU
    output wire                            idu_done_en,
    output wire [`CPU_WIDTH          -1:0] idu_inst_pc,
    output wire [`CPU_WIDTH          -1:0] idu_inst,

    output reg [`BRAN_WIDTH          -1:0] idu_inst_branch,     // branch flag
    input wire                             zero,
    output reg [`JUMP_WIDTH          -1:0] idu_inst_jump,       // jump flag

    output reg                             idu_inst_reg_wen,    // register write enable
    output reg [`REG_ADDR_WIDTH      -1:0] idu_inst_reg_waddr,  // register write address
    output reg [`REG_ADDR_WIDTH      -1:0] idu_inst_reg1_raddr, // register 1 read address
    output reg [`REG_ADDR_WIDTH      -1:0] idu_inst_reg2_raddr, // register 2 read address
       
    output reg                             idu_inst_mem_wen,    // memory write enable
    output reg                             idu_inst_mem_ren,    // memory read enable
    output reg                             idu_inst_mem2reg,    // memory to register flag
    output reg [`MEM_OP_WIDTH        -1:0] idu_inst_mem_op,     // memory opcode
     
    output reg [`CPU_WIDTH           -1:0] idu_inst_imm,        // immediate value

    output reg [`ALU_OP_WIDTH        -1:0] idu_inst_alu_op,     // alu opcode
    output reg [`ALU_SRC_WIDTH       -1:0] idu_inst_alu_src_sel // alu source select flag
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
 
wire [`CPU_WIDTH-1:0]        imm; 
 
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
    .imm           (imm         ), // immediate extend opcode
    .alu_op        (alu_op      ), // alu opcode
    .alu_src_sel   (alu_src_sel )  // alu source select flag
);

//--------------------------------------------------------------------------------
// Register Payload 
//--------------------------------------------------------------------------------
reg                          ifu_done_en_r;     
reg  [`CPU_WIDTH-1:0]        ifu_inst_pc_r;     
reg  [`CPU_WIDTH-1:0]        ifu_inst_r;     

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

reg  [`CPU_WIDTH-1:0]        imm_r; 

reg  [`ALU_OP_WIDTH-1:0]     alu_op_r;     
reg  [`ALU_SRC_WIDTH-1:0]    alu_src_sel_r;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ifu_done_en_r <= #DLY 1'b0;
    end
    else begin
        ifu_done_en_r <= #DLY ifu_done_en;      
    end
end
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
// assign idu_done_en = ifu_done_en_r & ~((branch_r == `BRAN_TYPE_A) &&  zero) & ~((branch_r == `BRAN_TYPE_B) && ~zero);
assign idu_done_en = ifu_done_en_r;
assign idu_inst_pc = ifu_inst_pc_r;
assign idu_inst    = ifu_inst_r;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_waddr_r   <= #DLY {`REG_ADDR_WIDTH{1'b0}};
        reg1_raddr_r  <= #DLY {`REG_ADDR_WIDTH{1'b0}};
        reg2_raddr_r  <= #DLY {`REG_ADDR_WIDTH{1'b0}};
        mem2reg_r     <= #DLY 1'b0;
        mem_op_r      <= #DLY {`MEM_OP_WIDTH{1'b0}};
        imm_r         <= #DLY {`CPU_WIDTH{1'b0}};
        alu_op_r      <= #DLY {`ALU_OP_WIDTH{1'b0}};
        alu_src_sel_r <= #DLY {`ALU_SRC_WIDTH{1'b0}};
    end
    else if (ifu_done_en) begin
        reg_waddr_r   <= #DLY reg_waddr;   
        reg1_raddr_r  <= #DLY reg1_raddr;  
        reg2_raddr_r  <= #DLY reg2_raddr;  
        mem2reg_r     <= #DLY mem2reg;     
        mem_op_r      <= #DLY mem_op;      
        imm_r         <= #DLY imm;  
        alu_op_r      <= #DLY alu_op;      
        alu_src_sel_r <= #DLY alu_src_sel; 
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        branch_r      <= #DLY {`BRAN_WIDTH{1'b0}};
        jump_r        <= #DLY {`JUMP_WIDTH{1'b0}};
        reg_wen_r     <= #DLY 1'b0;
        mem_wen_r     <= #DLY 1'b0;
        mem_ren_r     <= #DLY 1'b0;
    end
    else if (ifu_done_en) begin
        branch_r      <= #DLY branch;      
        jump_r        <= #DLY jump;        
        reg_wen_r     <= #DLY reg_wen;     
        mem_wen_r     <= #DLY mem_wen;     
        mem_ren_r     <= #DLY mem_ren;     
    end
    else begin
        branch_r      <= #DLY {`BRAN_WIDTH{1'b0}};
        jump_r        <= #DLY {`JUMP_WIDTH{1'b0}};
        reg_wen_r     <= #DLY 1'b0;     
        mem_wen_r     <= #DLY 1'b0;     
        mem_ren_r     <= #DLY 1'b0;     
    end
end
//--------------------------------------------------------------------------------
// Output Signal
//--------------------------------------------------------------------------------
always @(*) begin
    idu_inst_branch      = branch_r;
    idu_inst_jump        = jump_r;
    idu_inst_reg_wen     = reg_wen_r;
    idu_inst_reg_waddr   = reg_waddr_r;
    idu_inst_reg1_raddr  = reg1_raddr_r;
    idu_inst_reg2_raddr  = reg2_raddr_r;
    idu_inst_mem_wen     = mem_wen_r;
    idu_inst_mem_ren     = mem_ren_r;
    idu_inst_mem2reg     = mem2reg_r;
    idu_inst_mem_op      = mem_op_r;
    idu_inst_imm         = imm_r;
    idu_inst_alu_op      = alu_op_r;
    idu_inst_alu_src_sel = alu_src_sel_r;
end
endmodule

