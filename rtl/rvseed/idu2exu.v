// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : idu2exu.v
// Author        : Rongye
// Created On    : 2024-08-05 06:09
// Last Modified : 2024-08-18 07:13
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

    input  wire [`BRAN_WIDTH        -1:0]   idu2exu_branch,     
    input  wire [`JUMP_WIDTH        -1:0]   idu2exu_jump,       

    input  wire                             idu2exu_reg_wen,    
    input  wire [`REG_ADDR_WIDTH    -1:0]   idu2exu_reg_waddr,  
    input  wire [`REG_DATA_WIDTH    -1:0]   idu2exu_reg1_rdata,  
    input  wire [`REG_DATA_WIDTH    -1:0]   idu2exu_reg2_rdata,  
    input  wire [`CPU_WIDTH         -1:0]   idu2exu_imm,  

    input  wire                             idu2exu_mem_wen,    
    input  wire [`DATA_MEM_ADDR_WIDTH-1:0]  idu2exu_mem_waddr,     
    input  wire                             idu2exu_mem_ren,    
    input  wire [`DATA_MEM_ADDR_WIDTH-1:0]  idu2exu_mem_raddr,     

    input  wire                             idu2exu_mem2reg,    
    input  wire [`MEM_OP_WIDTH      -1:0]   idu2exu_mem_op,     

    input  wire [`ALU_OP_WIDTH      -1:0]   idu2exu_alu_op,     
    input  wire [`CPU_WIDTH         -1:0]   idu2exu_alu_src1,
    input  wire [`CPU_WIDTH         -1:0]   idu2exu_alu_src2,

    output reg                              idu2exu_en_r,
    output reg  [`CPU_WIDTH         -1:0]   idu2exu_pc_r,
    output reg  [`CPU_WIDTH         -1:0]   idu2exu_inst_r,

    output reg  [`BRAN_WIDTH        -1:0]   idu2exu_branch_r,     
    output reg  [`JUMP_WIDTH        -1:0]   idu2exu_jump_r,       

    output reg                              idu2exu_reg_wen_r,    
    output reg  [`REG_ADDR_WIDTH    -1:0]   idu2exu_reg_waddr_r,  
    output reg  [`REG_DATA_WIDTH    -1:0]   idu2exu_reg1_rdata_r,  
    output reg  [`REG_DATA_WIDTH    -1:0]   idu2exu_reg2_rdata_r,  
    output reg  [`CPU_WIDTH         -1:0]   idu2exu_imm_r,  

    output reg                              idu2exu_mem_wen_r,    
    output reg  [`DATA_MEM_ADDR_WIDTH-1:0]  idu2exu_mem_waddr_r,     
    output reg                              idu2exu_mem_ren_r,    
    output reg  [`DATA_MEM_ADDR_WIDTH-1:0]  idu2exu_mem_raddr_r,     

    output reg                              idu2exu_mem2reg_r,    
    output reg  [`MEM_OP_WIDTH      -1:0]   idu2exu_mem_op_r,     

    output reg  [`ALU_OP_WIDTH      -1:0]   idu2exu_alu_op_r,     
    output reg  [`CPU_WIDTH         -1:0]   idu2exu_alu_src1_r,
    output reg  [`CPU_WIDTH         -1:0]   idu2exu_alu_src2_r,

    input  reg                              branch_en,
    input  reg                              jump_en
);
localparam DLY = 0.1;

// IDU2EXU Register 
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        idu2exu_en_r <= #DLY 1'b0;
    end
    else if (branch_en | jump_en) begin
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
    else if (branch_en | jump_en) begin
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
        idu2exu_branch_r        <= #DLY {`BRAN_WIDTH{1'b0}};
        idu2exu_jump_r          <= #DLY {`JUMP_WIDTH{1'b0}};

        idu2exu_reg_wen_r       <= #DLY 1'b0;
        idu2exu_reg_waddr_r     <= #DLY {`REG_ADDR_WIDTH{1'b0}};
        idu2exu_reg1_rdata_r    <= #DLY {`REG_DATA_WIDTH{1'b0}};
        idu2exu_reg2_rdata_r    <= #DLY {`REG_DATA_WIDTH{1'b0}};
        idu2exu_imm_r           <= #DLY {`CPU_WIDTH{1'b0}};

        idu2exu_mem_wen_r       <= #DLY 1'b0;
        idu2exu_mem_waddr_r     <= #DLY {`DATA_MEM_ADDR_WIDTH{1'b0}};
        idu2exu_mem_ren_r       <= #DLY 1'b0;
        idu2exu_mem_raddr_r     <= #DLY {`DATA_MEM_ADDR_WIDTH{1'b0}};

        idu2exu_mem2reg_r       <= #DLY 1'b0;
        idu2exu_mem_op_r        <= #DLY {`MEM_OP_WIDTH{1'b0}};

        idu2exu_alu_op_r        <= #DLY {`ALU_OP_WIDTH{1'b0}};
        idu2exu_alu_src1_r      <= #DLY {`CPU_WIDTH{1'b0}};
        idu2exu_alu_src2_r      <= #DLY {`CPU_WIDTH{1'b0}};
    end
    else if(branch_en | jump_en) begin
        idu2exu_branch_r        <= #DLY {`BRAN_WIDTH{1'b0}};
        idu2exu_jump_r          <= #DLY {`JUMP_WIDTH{1'b0}};

        idu2exu_reg_wen_r       <= #DLY 1'b0;
        idu2exu_reg_waddr_r     <= #DLY {`REG_ADDR_WIDTH{1'b0}};
        idu2exu_reg1_rdata_r    <= #DLY {`REG_DATA_WIDTH{1'b0}};
        idu2exu_reg2_rdata_r    <= #DLY {`REG_DATA_WIDTH{1'b0}};
        idu2exu_imm_r           <= #DLY {`CPU_WIDTH{1'b0}};

        idu2exu_mem_wen_r       <= #DLY 1'b0;
        idu2exu_mem_waddr_r     <= #DLY {`DATA_MEM_ADDR_WIDTH{1'b0}};
        idu2exu_mem_ren_r       <= #DLY 1'b0;
        idu2exu_mem_raddr_r     <= #DLY {`DATA_MEM_ADDR_WIDTH{1'b0}};

        idu2exu_mem2reg_r       <= #DLY 1'b0;
        idu2exu_mem_op_r        <= #DLY {`MEM_OP_WIDTH{1'b0}};

        idu2exu_alu_op_r        <= #DLY {`ALU_OP_WIDTH{1'b0}};
        idu2exu_alu_src1_r      <= #DLY {`CPU_WIDTH{1'b0}};
        idu2exu_alu_src2_r      <= #DLY {`CPU_WIDTH{1'b0}};
    end
    else if (idu2exu_en) begin
        idu2exu_branch_r        <= #DLY idu2exu_branch; 
        idu2exu_jump_r          <= #DLY idu2exu_jump;        

        idu2exu_reg_wen_r       <= #DLY idu2exu_reg_wen;     
        idu2exu_reg_waddr_r     <= #DLY idu2exu_reg_waddr;   
        idu2exu_reg1_rdata_r    <= #DLY idu2exu_reg1_rdata;
        idu2exu_reg2_rdata_r    <= #DLY idu2exu_reg2_rdata;
        idu2exu_imm_r           <= #DLY idu2exu_imm;

        idu2exu_mem_wen_r       <= #DLY idu2exu_mem_wen;     
        idu2exu_mem_waddr_r     <= #DLY idu2exu_mem_waddr;   
        idu2exu_mem_ren_r       <= #DLY idu2exu_mem_ren;     
        idu2exu_mem_raddr_r     <= #DLY idu2exu_mem_raddr;   

        idu2exu_mem2reg_r       <= #DLY idu2exu_mem2reg;     
        idu2exu_mem_op_r        <= #DLY idu2exu_mem_op;      

        idu2exu_alu_op_r        <= #DLY idu2exu_alu_op;      
        idu2exu_alu_src1_r      <= #DLY idu2exu_alu_src1;    
        idu2exu_alu_src2_r      <= #DLY idu2exu_alu_src2;    
    end
end 


endmodule
