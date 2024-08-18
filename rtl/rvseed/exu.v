// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : exu.v
// Author        : Rongye
// Created On    : 2022-12-25 03:08
// Last Modified : 2024-08-18 07:20
// ---------------------------------------------------------------------------------
// Description   :
//
//
// -FHDR----------------------------------------------------------------------------
module EXU(
// GLOBAL 
    input  wire                             clk,
    input  wire                             rst_n,          
    input  wire                             enable,          
// IDU2EXU
    input  wire                             idu2exu_en,
    input  wire [`CPU_WIDTH           -1:0] idu2exu_pc,
    input  wire [`CPU_WIDTH           -1:0] idu2exu_inst,

    input  wire [`BRAN_WIDTH          -1:0] idu2exu_branch,
    input  wire [`JUMP_WIDTH          -1:0] idu2exu_jump,

    input  wire                             idu2exu_reg_wen,    
    input  wire [`REG_ADDR_WIDTH      -1:0] idu2exu_reg_waddr,
    input  wire [`REG_DATA_WIDTH      -1:0] idu2exu_reg1_rdata,
    input  wire [`REG_DATA_WIDTH      -1:0] idu2exu_reg2_rdata,
    input  wire [`CPU_WIDTH           -1:0] idu2exu_imm,

    input  wire                             idu2exu_mem_wen,    
    input  wire [`DATA_MEM_ADDR_WIDTH -1:0] idu2exu_mem_waddr,
    input  wire                             idu2exu_mem_ren,    
    input  wire [`DATA_MEM_ADDR_WIDTH -1:0] idu2exu_mem_raddr,

    input  wire                             idu2exu_mem2reg,    
    input  wire [`MEM_OP_WIDTH        -1:0] idu2exu_mem_op,

    input  wire [`ALU_OP_WIDTH        -1:0] idu2exu_alu_op,
    input  wire [`CPU_WIDTH           -1:0] idu2exu_alu_src1,
    input  wire [`CPU_WIDTH           -1:0] idu2exu_alu_src2,

    output wire                             exu2mem_en,
    output wire [`CPU_WIDTH           -1:0] exu2mem_pc,
    output wire [`CPU_WIDTH           -1:0] exu2mem_inst,

    output wire                             exu2mem_mem_wen,    
    output wire [`DATA_MEM_ADDR_WIDTH -1:0] exu2mem_mem_waddr,
    output wire [`DATA_MEM_DATA_WIDTH -1:0] exu2mem_mem_wdata,

    output wire                             exu2mem_mem_ren,    
    output wire [`DATA_MEM_ADDR_WIDTH -1:0] exu2mem_mem_raddr,
    input  wire [`DATA_MEM_DATA_WIDTH -1:0] mem2exu_mem_rdata,

    output wire                             exu2reg_reg_wen,    
    output wire [`REG_ADDR_WIDTH      -1:0] exu2reg_reg_waddr,
    output wire [`REG_DATA_WIDTH      -1:0] exu2reg_reg_wdata,


    output wire                             branch_en,
    output wire [`CPU_WIDTH           -1:0] branch_pc,
    output wire                             jump_en,
    output wire [`CPU_WIDTH           -1:0] jump_pc
);

localparam DLY = 0.1;

wire [`ALU_OP_WIDTH        -1:0] alu_op   = idu2exu_alu_op;     // default select reg2 data
wire [`CPU_WIDTH           -1:0] alu_src1 = idu2exu_alu_src1;     // defalut select reg1 data
wire [`CPU_WIDTH           -1:0] alu_src2 = idu2exu_alu_src2;     // default select reg2 data

reg  [`CPU_WIDTH           -1:0] alu_res;
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

//--------------------------------------------------------------------------------
// mem
//--------------------------------------------------------------------------------
wire [`DATA_MEM_ADDR_WIDTH            -1:0]   mem_raddr;       // idu_jump flag
wire [`DATA_MEM_ADDR_WIDTH            -1:0]   mem_waddr;       // idu_jump flag
wire [`DATA_MEM_DATA_WIDTH            -1:0]   mem_rdata;       // idu_jump flag
reg  [`DATA_MEM_DATA_WIDTH            -1:0]   mem_wdata;       // idu_jump flag

assign mem_waddr = idu2exu_mem_waddr;
assign mem_raddr = idu2exu_mem_raddr;
assign mem2reg   = idu2exu_mem2reg;

wire [`MEM_OP_WIDTH-1:0] mem_op     = idu2exu_mem_op;
wire [`CPU_WIDTH   -1:0] reg2_rdata = idu2exu_reg2_rdata;

always @(*) begin
    case (mem_op)
        `MEM_SB:
            case (mem_waddr[1:0])
                2'h0: mem_wdata = {mem_rdata[31:8], reg2_rdata[7:0]};
                2'h1: mem_wdata = {mem_rdata[31:16],reg2_rdata[7:0], mem_rdata[7:0]};
                2'h2: mem_wdata = {mem_rdata[31:24],reg2_rdata[7:0], mem_rdata[15:0]};
                2'h3: mem_wdata = {reg2_rdata[7:0], mem_rdata[23:0]};
            endcase
        `MEM_SH:
            case (mem_waddr[1])
                1'h0: mem_wdata = {mem_rdata[31:16],reg2_rdata[15:0]};
                1'h1: mem_wdata = {reg2_rdata[15:0],mem_rdata[15:0]};
            endcase
        `MEM_SW:
                mem_wdata = reg2_rdata;
        default:  
                mem_wdata = reg2_rdata;
    endcase
end


//--------------------------------------------------------------------------------
// reg_wdata
//--------------------------------------------------------------------------------
reg [7:0]  mem_byte;     //memory read byte
reg [15:0] mem_halfword; // memory read half word
reg [31:0] mem_word;     // memory read word
    
reg [`REG_DATA_WIDTH -1:0]   reg_wdata;       
always @(*) begin
    if (mem2reg == `ALU2REG)
        reg_wdata = alu_res;
    else
        case (mem_op)
            `MEM_LB: begin
                case (mem_raddr[1:0])
                    2'h0: mem_byte = mem_rdata[7:0];
                    2'h1: mem_byte = mem_rdata[15:8];
                    2'h2: mem_byte = mem_rdata[23:16];
                    2'h3: mem_byte = mem_rdata[31:24];
                endcase
                reg_wdata = {{24{mem_byte[7]}},mem_byte};
            end
            `MEM_LH: begin
                case (mem_raddr[1])
                    1'h0: mem_halfword = mem_rdata[15:0];
                    1'h1: mem_halfword = mem_rdata[31:16];
                endcase
                reg_wdata = {{16{mem_halfword[15]}},mem_halfword};
            end
            `MEM_LW: begin
                mem_word  = mem_rdata[31:0];
                reg_wdata = mem_word;
            end 
            `MEM_LBU: begin
                case (mem_raddr[1:0])
                    2'h0: mem_byte = mem_rdata[7:0];
                    2'h1: mem_byte = mem_rdata[15:8];
                    2'h2: mem_byte = mem_rdata[23:16];
                    2'h3: mem_byte = mem_rdata[31:24];                
                endcase
                reg_wdata = {24'b0,mem_byte};
            end
            `MEM_LHU: begin
                case (mem_raddr[1])
                    1'h0: mem_halfword = mem_rdata[15:0];
                    1'h1: mem_halfword = mem_rdata[31:16];
                endcase
                reg_wdata = {16'b0,mem_halfword};
            end
            default:
                reg_wdata = mem_rdata;
        endcase
end
//--------------------------------------------------------------------------------
// Output Signal
//--------------------------------------------------------------------------------
assign exu2mem_en        = idu2exu_en;
assign exu2mem_pc        = idu2exu_pc;
assign exu2mem_inst      = idu2exu_inst;

assign exu2mem_mem_wen   = idu2exu_mem_wen;
assign exu2mem_mem_waddr = idu2exu_mem_waddr;
assign exu2mem_mem_wdata = mem_wdata;

assign exu2mem_mem_ren   = idu2exu_mem_ren;
assign exu2mem_mem_raddr = idu2exu_mem_raddr;

assign exu2reg_reg_wen   = idu2exu_reg_wen;
assign exu2reg_reg_waddr = idu2exu_reg_waddr;
assign exu2reg_reg_wdata = reg_wdata;

assign branch_en = ((idu2exu_branch == `BRAN_TYPE_A) &&  (alu_res==1)) 
                 | ((idu2exu_branch == `BRAN_TYPE_B) && ~(alu_res==1)); 
assign branch_pc = idu2exu_pc + idu2exu_imm;

assign jump_en   = (idu2exu_jump == `JUMP_JAL) | (idu2exu_jump == `JUMP_JALR);
assign jump_pc   = (idu2exu_jump == `JUMP_JAL) ? idu2exu_pc + idu2exu_imm
                                               : idu2exu_reg1_rdata + idu2exu_imm;

endmodule

