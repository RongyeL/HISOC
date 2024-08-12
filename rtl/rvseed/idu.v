// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : idu.v
// Author        : Rongye
// Created On    : 2022-12-25 03:08
// Last Modified : 2024-08-12 07:56
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

    output reg [`REG_ADDR_WIDTH      -1:0] idu2reg_reg1_raddr, // register 1 read address
    output reg [`REG_ADDR_WIDTH      -1:0] idu2reg_reg2_raddr, // register 2 read address
    input  wire [`REG_DATA_WIDTH     -1:0] reg2idu_reg1_rdata, // register 1 read address
    input  wire [`REG_DATA_WIDTH     -1:0] reg2idu_reg2_rdata, // register 2 read address

    output reg                             idu2exu_reg_wen,    // register write enable
    output reg [`REG_ADDR_WIDTH      -1:0] idu2exu_reg_waddr,  // register write address

    output reg                             idu2exu_mem_wen,    // memory write enable
    output reg [`DATA_MEM_ADDR_WIDTH -1:0] idu2exu_mem_waddr,  // register write address
    output reg                             idu2exu_mem_ren,    // memory read enable
    output reg [`DATA_MEM_ADDR_WIDTH -1:0] idu2exu_mem_raddr,  // register write address

    output reg                             idu2exu_mem2reg,    // memory to register flag
    output reg [`MEM_OP_WIDTH        -1:0] idu2exu_mem_op,     // memory opcode
     
    output reg [`ALU_OP_WIDTH        -1:0] idu2exu_alu_op,     // alu opcode
    output reg [`CPU_WIDTH           -1:0] idu2exu_alu_src1,// alu source select flag
    output reg [`CPU_WIDTH           -1:0] idu2exu_alu_src2 // alu source select flag

);

localparam DLY = 0.1;

wire [`CPU_WIDTH        -1:0]   inst; 
wire [`CPU_WIDTH        -1:0]   curr_pc; 

reg [`BRAN_WIDTH       -1:0]   branch;     
reg [`JUMP_WIDTH       -1:0]   jump;       
 
reg [`REG_ADDR_WIDTH   -1:0]   reg1_raddr; 
reg [`REG_ADDR_WIDTH   -1:0]   reg2_raddr; 

wire [`REG_DATA_WIDTH   -1:0]   reg1_rdata; 
wire [`REG_DATA_WIDTH   -1:0]   reg2_rdata; 

reg                            reg_wen;    
reg [`REG_ADDR_WIDTH   -1:0]   reg_waddr;  

reg                               mem_wen;    
reg [`DATA_MEM_ADDR_WIDTH   -1:0] mem_waddr;  
reg                               mem_ren;    
reg [`DATA_MEM_ADDR_WIDTH   -1:0] mem_raddr;  

reg                            mem2reg;    
reg [`MEM_OP_WIDTH     -1:0]   mem_op;     

reg [`CPU_WIDTH        -1:0]   imm; 

reg [`ALU_OP_WIDTH     -1:0]   alu_op;     
reg [`CPU_WIDTH         -1:0]   alu_src1;
reg [`CPU_WIDTH         -1:0]   alu_src2;

// INST DECODER 
assign inst       = ifu2idu_inst;
assign curr_pc    = ifu2idu_pc;
assign reg1_rdata = reg2idu_reg1_rdata;
assign reg2_rdata = reg2idu_reg2_rdata;

wire [`OPCODE_WIDTH         -1:0] opcode = inst[`OPCODE_WIDTH-1:0];
wire [`FUNCT3_WIDTH         -1:0] funct3 = inst[`FUNCT3_WIDTH+`FUNCT3_BASE-1:`FUNCT3_BASE];
wire [`FUNCT7_WIDTH         -1:0] funct7 = inst[`FUNCT7_WIDTH+`FUNCT7_BASE-1:`FUNCT7_BASE];
wire [`RISCV_INST_R_RD_W    -1:0] rd     = inst[`RISCV_INST_R_RD_W+`RD_BASE-1:`RD_BASE];
wire [`RISCV_INST_R_RS1_W   -1:0] rs1    = inst[`RISCV_INST_R_RS1_W+`RS1_BASE-1:`RS1_BASE];
wire [`RISCV_INST_R_RS2_W   -1:0] rs2    = inst[`RISCV_INST_R_RS2_W+`RS2_BASE-1:`RS2_BASE];


always @(*) begin
    branch      = `BRAN_OFF;
    jump        = `JUMP_OFF;
    reg_wen     = 1'b0;
    reg1_raddr  = `REG_ADDR_WIDTH'b0;
    reg2_raddr  = `REG_ADDR_WIDTH'b0;
    reg_waddr   = `REG_ADDR_WIDTH'b0;
    mem_wen     = 1'b0;
    mem_waddr   = `DATA_MEM_ADDR_WIDTH'b0;
    mem_ren     = 1'b0;
    mem_raddr   = `DATA_MEM_ADDR_WIDTH'b0;
    mem2reg     = `ALU2REG;
    mem_op      = `MEM_LW;
    imm         = `CPU_WIDTH'b0;
    alu_op      = `ALU_AND;
    alu_src1    = `REG_DATA_WIDTH'b0;     // defalut select reg1 data
    alu_src2    = `REG_DATA_WIDTH'b0;     // defalut select reg1 data
    case (opcode)
        `INST_TYPE_R: begin
            reg_wen     = 1'b1;
            reg1_raddr  = rs1 << 2;
            reg2_raddr  = rs2 << 2;
            reg_waddr   = rd  << 2;
            alu_src1    = reg1_rdata;     // defalut select reg1 data
            alu_src2    = reg2_rdata;     // defalut select reg1 data
            case (funct3)
                `INST_ADD_SUB: 
                    alu_op = (funct7 == `FUNCT7_INST_A) ? `ALU_ADD : `ALU_SUB; // A:add B:sub 
                `INST_XOR: 
                    alu_op = `ALU_XOR;  
                `INST_OR: 
                    alu_op = `ALU_OR;  
                `INST_AND: 
                    alu_op = `ALU_AND;  
                `INST_SLL: 
                    alu_op = `ALU_SLL;
                `INST_SRL_SRA: 
                    alu_op = (funct7 == `FUNCT7_INST_A) ? `ALU_SRL : `ALU_SRA; // A:srl     B:sra
                `INST_SLT: 
                    alu_op = `ALU_SLT;           
                `INST_SLTU: 
                    alu_op = `ALU_SLTU;
            endcase
        end
        `INST_TYPE_I: begin
            reg_wen     = 1'b1;
            reg1_raddr  = rs1 << 2;
            reg_waddr   = rd << 2;
            imm         = {{20{inst[31]}},inst[31:20]};
            alu_src1    = reg1_rdata;     // defalut select reg1 data
            alu_src2    = imm;     // default select reg2 data
            case (funct3)
                `INST_ADDI: 
                    alu_op = `ALU_ADD; 
                `INST_XORI: 
                    alu_op = `ALU_XOR;  
                `INST_ORI: 
                    alu_op = `ALU_OR;  
                `INST_ANDI: 
                    alu_op = `ALU_AND;  
                `INST_SLLI:  
                    alu_op = `ALU_SLL;
                `INST_SRLI_SRAI:  
                    alu_op = (funct7 == `FUNCT7_INST_A) ? `ALU_SRL : `ALU_SRA; // A:srli    B:srai
                `INST_SLTI: 
                    alu_op = `ALU_SLT;           
                `INST_SLTIU: 
                    alu_op = `ALU_SLTU;
            endcase
        end
        `INST_TYPE_IL: begin
            reg_wen     = 1'b1;
            reg1_raddr  = rs1 << 2;
            reg_waddr   = rd << 2;
            mem_ren     = 1'b1;
            imm         = {{20{inst[31]}},inst[31:20]};
            mem_raddr   = reg1_rdata+imm;
            mem2reg     = `MEM2REG;
            alu_op      = `ALU_ADD;
            alu_src1    = reg1_rdata;     // defalut select reg1 data
            alu_src2    = imm;     // default select reg2 data
            case (funct3)
                `INST_LB: 
                    mem_op = `MEM_LB; 
                `INST_LH: 
                    mem_op = `MEM_LH;
                `INST_LW: 
                    mem_op = `MEM_LW;
                `INST_LBU: 
                    mem_op = `MEM_LBU;        
                `INST_LHU: 
                    mem_op = `MEM_LHU;
            endcase
        end
        `INST_TYPE_S: begin
            reg1_raddr  = rs1 << 2;
            reg2_raddr  = rs2 << 2;                    
            mem_wen     = 1'b1;
            imm         = {{20{inst[31]}},inst[31:25],inst[11:7]};
            mem_waddr   = reg1_rdata+imm;
            alu_op      = `ALU_ADD;
            alu_src1    = reg1_rdata;     // defalut select reg1 data
            alu_src2    = imm;     // default select reg2 data
            case (funct3)
                `INST_SB: 
                    mem_op = `MEM_SB;
                `INST_SH: 
                    mem_op = `MEM_SH;           
                `INST_SW: 
                    mem_op = `MEM_SW;   
            endcase
        end
        `INST_TYPE_B: begin
            reg1_raddr  = rs1 << 2;
            reg2_raddr  = rs2 << 2;
            imm         = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8], 1'b0};
            alu_src1    = reg1_rdata;     // defalut select reg1 data
            alu_src2    = reg2_rdata;     // defalut select reg1 data
            case (funct3)
                `INST_BEQ: begin
                    branch     = `BRAN_TYPE_A;
                    alu_op     = `ALU_EQU;
                end
                `INST_BNE: begin
                    branch     = `BRAN_TYPE_B;
                    alu_op     = `ALU_EQU;
                end
                `INST_BLT: begin
                    branch     = `BRAN_TYPE_A;
                    alu_op     = `ALU_SLT;
                end
                `INST_BGE: begin
                    branch     = `BRAN_TYPE_B;
                    alu_op     = `ALU_SLT;
                end
                `INST_BLTU: begin
                    branch     = `BRAN_TYPE_A;
                    alu_op     = `ALU_SLTU;
                end
                `INST_BGEU: begin
                    branch     = `BRAN_TYPE_B;
                    alu_op     = `ALU_SLTU;               
                end
            endcase
        end
        `INST_JAL: begin // only jal
            jump        = `JUMP_JAL;
            reg_wen     = 1'b1;
            reg_waddr   = rd << 2;
            imm         = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21], 1'b0};
            alu_op      = `ALU_ADD;
            alu_src1    = `CPU_WIDTH'h4; // pc + 4 
            alu_src2    = curr_pc;       //
        end
        `INST_JALR: begin // only jalr 
            jump        = `JUMP_JALR;
            reg_wen     = 1'b1;
            reg1_raddr  = rs1 << 2;  
            reg_waddr   = rd << 2;
            imm         = {{20{inst[31]}},inst[31:20]};
            alu_op      = `ALU_ADD;
            alu_src1    = `CPU_WIDTH'h4; // pc + 4 
            alu_src2    = curr_pc;       //
        end
        `INST_LUI: begin // only lui
                reg_wen     = 1'b1;
                reg1_raddr  = `REG_ADDR_WIDTH'b0; // x0 = 0
                reg_waddr   = rd << 2;
                imm         = {inst[31:12],12'b0};
                alu_op      = `ALU_ADD;
                alu_src1    = reg1_rdata;     // defalut select reg1 data
                alu_src2    = imm;        // select immediate 
        end
        `INST_AUIPC: begin // only auipc
                reg_wen     = 1'b1;
                reg_waddr   = rd << 2;
                imm         = {inst[31:12],12'b0};
                alu_op      = `ALU_ADD;
                alu_src1    = imm;
                alu_src2    = curr_pc;
        end
    endcase 
end

//--------------------------------------------------------------------------------
// Output Signal
//--------------------------------------------------------------------------------
assign idu2exu_en       = ifu2idu_en;
assign idu2exu_pc       = ifu2idu_pc;
assign idu2exu_inst     = ifu2idu_inst;
always @(*) begin
    idu2exu_branch      = branch;
    idu2exu_jump        = jump;

    idu2reg_reg1_raddr  = reg1_raddr;
    idu2reg_reg2_raddr  = reg2_raddr;

    idu2exu_reg_wen     = reg_wen;
    idu2exu_reg_waddr   = reg_waddr;

    idu2exu_mem_wen     = mem_wen;
    idu2exu_mem_waddr   = mem_waddr;
    idu2exu_mem_ren     = mem_ren;
    idu2exu_mem_raddr   = mem_raddr;

    idu2exu_mem2reg     = mem2reg;
    idu2exu_mem_op      = mem_op;

    idu2exu_alu_op      = alu_op;
    idu2exu_alu_src1    = alu_src1;
    idu2exu_alu_src2    = alu_src2;
end
endmodule

