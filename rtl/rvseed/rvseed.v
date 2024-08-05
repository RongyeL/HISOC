// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : rvseed.v
// Author        : Rongye
// Created On    : 2022-03-25 03:42
// Last Modified : 2024-08-05 09:03
// ---------------------------------------------------------------------------------
// Description   : rvseed cpu top module.
//                 
//
// -FHDR----------------------------------------------------------------------------
module RVSEED (
// global 
    input  wire                             clk,
    input  wire                             rst_n,              
    input  wire                             enable,     
// AR channel
    output wire                             ifu_arvalid,
    input  wire                             ifu_arready,
    output wire [`AXI_ID_WIDTH      -1:0]   ifu_arid,
    output wire [`AXI_ADDR_WIDTH    -1:0]   ifu_araddr,
    output wire [`AXI_LEN_WIDTH     -1:0]   ifu_arlen,
    output wire [`AXI_SIZE_WIDTH    -1:0]   ifu_arsize,
    output wire [`AXI_BURST_WIDTH   -1:0]   ifu_arburst,
    output wire                             ifu_arlock,
    output wire [`AXI_CACHE_WIDTH   -1:0]   ifu_arcache,
    output wire [`AXI_PROT_WIDTH    -1:0]   ifu_arprot,
    output wire [`AXI_QOS_WIDTH     -1:0]   ifu_arqos,
    output wire [`AXI_REGION_WIDTH  -1:0]   ifu_arregion,
// R channel
    input  wire                             ifu_rvalid,
    output wire                             ifu_rready,
    input  wire [`AXI_ID_WIDTH      -1:0]   ifu_rid,
    input  wire [`AXI_DATA_WIDTH    -1:0]   ifu_rdata,
    input  wire [`AXI_RESP_WIDTH    -1:0]   ifu_rresp,
    input  wire                             ifu_rlast
);
localparam DLY = 0.1;

wire                                ifu2idu_en;
wire [`CPU_WIDTH            -1:0]   ifu2idu_pc;
wire [`CPU_WIDTH            -1:0]   ifu2idu_inst;

wire                                idu2exu_en;
wire [`CPU_WIDTH            -1:0]   idu2exu_pc;
wire [`CPU_WIDTH            -1:0]   idu2exu_inst;

wire [`BRAN_WIDTH           -1:0]   idu2exu_branch;     // idu_branch flag
wire                                exu2ifu_zero;    // memory write enable
wire                                exu2idu_zero;    // memory write enable
wire [`JUMP_WIDTH           -1:0]   idu2exu_jump;       // idu_jump flag

wire                                idu2exu_reg_wen;    // register write enable
wire [`REG_ADDR_WIDTH       -1:0]   idu2exu_reg_waddr;  // register write address
wire [`REG_ADDR_WIDTH       -1:0]   idu2exu_reg1_raddr; // register 1 read address
wire [`REG_ADDR_WIDTH       -1:0]   idu2exu_reg2_raddr; // register 2 read address
wire [`CPU_WIDTH            -1:0]   reg2exu_reg1_rdata;       // idu_jump flag
wire [`CPU_WIDTH            -1:0]   reg2exu_reg2_rdata;       // idu_jump flag
wire [`CPU_WIDTH            -1:0]   idu2exu_reg_wdata;       // idu_jump flag
wire [`CPU_WIDTH            -1:0]   alu_src1;       // idu_jump flag
wire [`CPU_WIDTH            -1:0]   alu_src2;       // idu_jump flag
wire [`CPU_WIDTH            -1:0]   alu_res;       // idu_jump flag

wire                                idu2exu_mem_wen;    // memory write enable
wire                                idu2exu_mem_ren;    // memory read enable
wire                                idu2exu_mem2reg;    // memory to register flag
wire [`MEM_OP_WIDTH         -1:0]   idu2exu_mem_op;     // memory opcode

wire [`CPU_WIDTH            -1:0]   mem_addr;       // idu_jump flag
wire [`CPU_WIDTH            -1:0]   mem_rdata;       // idu_jump flag
wire [`CPU_WIDTH            -1:0]   mem_wdata;       // idu_jump flag

wire [`CPU_WIDTH            -1:0]   idu2exu_imm;        // immediate value

wire [`ALU_OP_WIDTH         -1:0]   idu2exu_alu_op;     // alu opcode
wire [`ALU_SRC_WIDTH        -1:0]   idu2exu_alu_src_sel; // alu source select flag

wire                                ifu2idu_en_r;
wire [`CPU_WIDTH            -1:0]   ifu2idu_pc_r;
wire [`CPU_WIDTH            -1:0]   ifu2idu_inst_r;

wire                                idu2exu_en_r;
wire [`CPU_WIDTH            -1:0]   idu2exu_pc_r;
wire [`CPU_WIDTH            -1:0]   idu2exu_inst_r;

wire                                idu2exu_reg_wen_r;    // register write enable
wire [`REG_ADDR_WIDTH       -1:0]   idu2exu_reg_waddr_r;  // register write address
wire [`REG_ADDR_WIDTH       -1:0]   idu2exu_reg1_raddr_r; // register 1 read address
wire [`REG_ADDR_WIDTH       -1:0]   idu2exu_reg2_raddr_r; // register 2 read address

wire [`CPU_WIDTH            -1:0]   idu2exu_reg_wdata_r;       // idu_jump flag

wire                                idu2exu_mem_wen_r;    // memory write enable
wire                                idu2exu_mem_ren_r;    // memory read enable
wire                                idu2exu_mem2reg_r;    // memory to register flag
wire [`MEM_OP_WIDTH         -1:0]   idu2exu_mem_op_r;     // memory opcode

wire [`CPU_WIDTH            -1:0]   idu2exu_imm_r;        // immediate value

wire [`ALU_OP_WIDTH         -1:0]   idu2exu_alu_op_r;     // alu opcode
wire [`ALU_SRC_WIDTH        -1:0]   idu2exu_alu_src_sel_r; // alu source select flag


IFU U_IFU(
    .clk                    (clk                    ),
    .rst_n                  (rst_n                  ),   
    .enable                 (enable                 ),   

    .idu_branch             (idu2exu_branch_r       ),
    .exu_zero               (exu2ifu_zero           ),
    .idu_jump               (idu2exu_jump_r         ),
    .idu_imm                (idu2exu_imm_r          ),
    .reg1_rdata             (reg2exu_reg1_rdata     ),

    .ifu2idu_en             (ifu2idu_en             ),
    .ifu2idu_pc             (ifu2idu_pc             ),
    .ifu2idu_inst           (ifu2idu_inst           ),

    .idu_pc                 (idu2exu_pc_r           ),

    .ifu_arvalid            (ifu_arvalid            ),
    .ifu_arready            (ifu_arready            ),
    .ifu_arid               (ifu_arid               ),
    .ifu_araddr             (ifu_araddr             ),
    .ifu_arlen              (ifu_arlen              ),
    .ifu_arsize             (ifu_arsize             ),
    .ifu_arburst            (ifu_arburst            ),
    .ifu_arlock             (ifu_arlock             ),
    .ifu_arcache            (ifu_arcache            ),
    .ifu_arprot             (ifu_arprot             ),
    .ifu_arqos              (ifu_arqos              ),
    .ifu_arregion           (ifu_arregion           ),

    .ifu_rvalid             (ifu_rvalid             ),
    .ifu_rready             (ifu_rready             ),
    .ifu_rid                (ifu_rid                ),
    .ifu_rdata              (ifu_rdata              ),     
    .ifu_rresp              (ifu_rresp              ),
    .ifu_rlast              (ifu_rlast              )

);

IFU2IDU U_IFU2IDU(
    .clk                    (clk                    ),
    .rst_n                  (rst_n                  ),

    .ifu2idu_en             (ifu2idu_en             ), 
    .ifu2idu_pc             (ifu2idu_pc             ),
    .ifu2idu_inst           (ifu2idu_inst           ),

    .ifu2idu_en_r           (ifu2idu_en_r           ),
    .ifu2idu_pc_r           (ifu2idu_pc_r           ),
    .ifu2idu_inst_r         (ifu2idu_inst_r         )
);

IDU U_IDU (
    .clk                    (clk                    ),
    .rst_n                  (rst_n                  ),
    .enable                 (enable                 ),

    .ifu2idu_en             (ifu2idu_en_r           ),
    .ifu2idu_pc             (ifu2idu_pc_r           ),
    .ifu2idu_inst           (ifu2idu_inst_r         ),

    .idu2exu_en             (idu2exu_en             ),
    .idu2exu_pc             (idu2exu_pc             ),
    .idu2exu_inst           (idu2exu_inst           ),

    .idu2exu_branch         (idu2exu_branch         ),
    .exu2idu_zero           (exu2idu_zero           ),
    .idu2exu_jump           (idu2exu_jump           ),

    .idu2exu_reg_wen        (idu2exu_reg_wen        ),
    .idu2exu_reg_waddr      (idu2exu_reg_waddr      ),
    .idu2exu_reg1_raddr     (idu2exu_reg1_raddr     ),
    .idu2exu_reg2_raddr     (idu2exu_reg2_raddr     ),
    .idu2exu_mem_wen        (idu2exu_mem_wen        ),
    .idu2exu_mem_ren        (idu2exu_mem_ren        ),
    .idu2exu_mem2reg        (idu2exu_mem2reg        ),
    .idu2exu_mem_op         (idu2exu_mem_op         ),
    .idu2exu_imm            (idu2exu_imm            ),
    .idu2exu_alu_op         (idu2exu_alu_op         ),
    .idu2exu_alu_src_sel    (idu2exu_alu_src_sel    )
);
IDU2EXU U_IDU2EXU(
    .clk                    (clk                    ),
    .rst_n                  (rst_n                  ),
//input
    .idu2exu_en             (idu2exu_en             ), 
    .idu2exu_pc             (idu2exu_pc             ),
    .idu2exu_inst           (idu2exu_inst           ),

    .idu2exu_branch         (idu2exu_branch         ),
    .idu2exu_jump           (idu2exu_jump           ),

    .idu2exu_reg_wen        (idu2exu_reg_wen        ),
    .idu2exu_reg_waddr      (idu2exu_reg_waddr      ),
    .idu2exu_reg1_raddr     (idu2exu_reg1_raddr     ),
    .idu2exu_reg2_raddr     (idu2exu_reg2_raddr     ),

    .idu2exu_mem_wen        (idu2exu_mem_wen        ),
    .idu2exu_mem_ren        (idu2exu_mem_ren        ),
    .idu2exu_mem2reg        (idu2exu_mem2reg        ),
    .idu2exu_mem_op         (idu2exu_mem_op         ),

    .idu2exu_imm            (idu2exu_imm            ),

    .idu2exu_alu_op         (idu2exu_alu_op         ),
    .idu2exu_alu_src_sel    (idu2exu_alu_src_sel    ),
//output
    .idu2exu_en_r           (idu2exu_en_r           ),
    .idu2exu_pc_r           (idu2exu_pc_r           ),
    .idu2exu_inst_r         (idu2exu_inst_r         ),

    .idu2exu_branch_r       (idu2exu_branch_r       ),
    .idu2exu_jump_r         (idu2exu_jump_r         ),

    .idu2exu_reg_wen_r      (idu2exu_reg_wen_r      ),
    .idu2exu_reg_waddr_r    (idu2exu_reg_waddr_r    ),
    .idu2exu_reg1_raddr_r   (idu2exu_reg1_raddr_r   ),
    .idu2exu_reg2_raddr_r   (idu2exu_reg2_raddr_r   ),

    .idu2exu_mem_wen_r      (idu2exu_mem_wen_r      ),
    .idu2exu_mem_ren_r      (idu2exu_mem_ren_r      ),
    .idu2exu_mem2reg_r      (idu2exu_mem2reg_r      ),
    .idu2exu_mem_op_r       (idu2exu_mem_op_r       ),

    .idu2exu_imm_r          (idu2exu_imm_r          ),
    
    .idu2exu_alu_op_r       (idu2exu_alu_op_r       ),
    .idu2exu_alu_src_sel_r  (idu2exu_alu_src_sel_r  ) 
);

REG_RVSEED U_REG_RVSEED(
    .clk                    (clk                    ),
    .rst_n                  (rst_n                  ),
    .reg_wen                (idu2exu_reg_wen_r      ),
    .reg_waddr              (idu2exu_reg_waddr_r    ),
    .reg_wdata              (idu2exu_reg_wdata_r    ),
    .reg1_raddr             (idu2exu_reg1_raddr_r   ),
    .reg2_raddr             (idu2exu_reg2_raddr_r   ),
    .reg1_rdata             (reg2exu_reg1_rdata     ),
    .reg2_rdata             (reg2exu_reg2_rdata     )
);


MUX_ALU U_MUX_ALU(
    .alu_src_sel                    ( idu2exu_alu_src_sel_r                   ),
    .reg1_rdata                     ( reg2exu_reg1_rdata                    ),
    .reg2_rdata                     ( reg2exu_reg2_rdata                    ),
    .imm                            ( idu2exu_imm_r                           ),
    .curr_pc                        ( idu2exu_pc_r                   ),
    .alu_src1                       ( alu_src1                      ),
    .alu_src2                       ( alu_src2                      )
);

ALU U_ALU(
    .alu_op                         ( idu2exu_alu_op_r                        ),
    .alu_src1                       ( alu_src1                      ),
    .alu_src2                       ( alu_src2                      ),
    .zero                           ( exu2ifu_zero                          ),
    .alu_res                        ( alu_res                       )
);
assign exu2idu_zero = exu2ifu_zero;
assign mem_addr = alu_res; 
MUX_MEM U_MUX_MEM(
    .mem_op                         ( idu2exu_mem_op_r                        ),
    .mem_addr                       ( mem_addr                      ),
    .reg2_rdata                     ( reg2exu_reg2_rdata                    ),
    .mem_rdata                      ( mem_rdata                     ),
    .mem_wdata                      ( mem_wdata                     )
);

DATA_MEM U_DATA_MEM(
    .clk                            ( clk                           ),
    .mem_wen                        ( idu2exu_mem_wen_r                       ),
    .mem_ren                        ( idu2exu_mem_ren_r                       ),
    .mem_addr                       ( mem_addr                      ),
    .mem_wdata                      ( mem_wdata                     ),
    .mem_rdata                      ( mem_rdata                     )
);

MUX_REG U_MUX_REG(
    .mem2reg                        ( idu2exu_mem2reg_r                       ),
    .alu_res                        ( alu_res                       ),
    .mem_op                         ( idu2exu_mem_op_r                        ),
    .mem_addr                       ( mem_addr                      ),
    .mem_rdata                      ( mem_rdata                     ),
    .reg_wdata                      ( idu2exu_reg_wdata_r                     )
);
endmodule
