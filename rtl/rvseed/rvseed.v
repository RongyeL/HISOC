// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : rvseed.v
// Author        : Rongye
// Created On    : 2022-03-25 03:42
// Last Modified : 2024-08-18 07:28
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

wire                                branch_en;       
wire [`CPU_WIDTH            -1:0]   branch_pc;       
wire                                jump_en;       
wire [`CPU_WIDTH            -1:0]   jump_pc;       

wire                                ifu2idu_en;
wire [`CPU_WIDTH            -1:0]   ifu2idu_pc;
wire [`CPU_WIDTH            -1:0]   ifu2idu_inst;

wire [`CPU_WIDTH            -1:0]   curr_pc;       
PC_REG U_PC_REG(
    .clk                    (clk                    ),
    .rst_n                  (rst_n                  ),   
    .enable                 (enable                 ),   

    .branch_en              (branch_en              ),
    .branch_pc              (branch_pc              ),
    .jump_en                (jump_en                ),
    .jump_pc                (jump_pc                ),

    .curr_pc                (curr_pc                ),

    .ifu2idu_en             (ifu2idu_en             )
);

IFU U_IFU(
    .clk                    (clk                    ),
    .rst_n                  (rst_n                  ),   
    .enable                 (enable                 ),   

    .curr_pc                (curr_pc                ),   

    .branch_en              (branch_en              ),
    .branch_pc              (branch_pc              ),
    .jump_en                (jump_en                ),
    .jump_pc                (jump_pc                ),

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
    .ifu_rlast              (ifu_rlast              ),

    .ifu2idu_en             (ifu2idu_en             ),
    .ifu2idu_pc             (ifu2idu_pc             ),
    .ifu2idu_inst           (ifu2idu_inst           )

);

wire                                ifu2idu_en_r;
wire [`CPU_WIDTH            -1:0]   ifu2idu_pc_r;
wire [`CPU_WIDTH            -1:0]   ifu2idu_inst_r;

IFU2IDU U_IFU2IDU(
    .clk                    (clk                    ),
    .rst_n                  (rst_n                  ),

    .ifu2idu_en             (ifu2idu_en             ), 
    .ifu2idu_pc             (ifu2idu_pc             ),
    .ifu2idu_inst           (ifu2idu_inst           ),

    .ifu2idu_en_r           (ifu2idu_en_r           ),
    .ifu2idu_pc_r           (ifu2idu_pc_r           ),
    .ifu2idu_inst_r         (ifu2idu_inst_r         ),

    .branch_en              (branch_en              ),
    .jump_en                (jump_en                )
);

wire                                idu2exu_en;
wire [`CPU_WIDTH            -1:0]   idu2exu_pc;
wire [`CPU_WIDTH            -1:0]   idu2exu_inst;

wire [`BRAN_WIDTH           -1:0]   idu2exu_branch;    
wire [`JUMP_WIDTH           -1:0]   idu2exu_jump;      

wire [`REG_ADDR_WIDTH       -1:0]   idu2reg_reg1_raddr;
wire [`REG_ADDR_WIDTH       -1:0]   idu2reg_reg2_raddr;
wire [`REG_DATA_WIDTH       -1:0]   reg2idu_reg1_rdata;
wire [`REG_DATA_WIDTH       -1:0]   reg2idu_reg2_rdata;

wire                                idu2exu_reg_wen;   
wire [`REG_ADDR_WIDTH       -1:0]   idu2exu_reg_waddr; 
wire [`REG_DATA_WIDTH       -1:0]   idu2exu_reg1_rdata;
wire [`REG_DATA_WIDTH       -1:0]   idu2exu_reg2_rdata;
wire [`CPU_WIDTH            -1:0]   idu2exu_imm;
wire [`REG_DATA_WIDTH       -1:0]   idu2exu_reg_wdata; 

wire                                idu2exu_mem_wen;   
wire [`DATA_MEM_ADDR_WIDTH  -1:0]   idu2exu_mem_waddr; 
wire                                idu2exu_mem_ren;   
wire [`DATA_MEM_ADDR_WIDTH  -1:0]   idu2exu_mem_raddr; 

wire                                idu2exu_mem2reg;   
wire [`MEM_OP_WIDTH         -1:0]   idu2exu_mem_op;    

wire [`ALU_OP_WIDTH         -1:0]   idu2exu_alu_op;    
wire [`CPU_WIDTH            -1:0]   idu2exu_alu_src1;  
wire [`CPU_WIDTH            -1:0]   idu2exu_alu_src2; 

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
    .idu2exu_jump           (idu2exu_jump           ),

    .idu2reg_reg1_raddr     (idu2reg_reg1_raddr     ),
    .idu2reg_reg2_raddr     (idu2reg_reg2_raddr     ),
    .reg2idu_reg1_rdata     (reg2idu_reg1_rdata     ),
    .reg2idu_reg2_rdata     (reg2idu_reg2_rdata     ),

    .idu2exu_reg_wen        (idu2exu_reg_wen        ),
    .idu2exu_reg_waddr      (idu2exu_reg_waddr      ),
    .idu2exu_reg1_rdata     (idu2exu_reg1_rdata     ),
    .idu2exu_reg2_rdata     (idu2exu_reg2_rdata     ),
    .idu2exu_imm            (idu2exu_imm            ),

    .idu2exu_mem_wen        (idu2exu_mem_wen        ),
    .idu2exu_mem_waddr      (idu2exu_mem_waddr      ),
    .idu2exu_mem_ren        (idu2exu_mem_ren        ),
    .idu2exu_mem_raddr      (idu2exu_mem_raddr      ),

    .idu2exu_mem2reg        (idu2exu_mem2reg        ),
    .idu2exu_mem_op         (idu2exu_mem_op         ),

    .idu2exu_alu_op         (idu2exu_alu_op         ),
    .idu2exu_alu_src1       (idu2exu_alu_src1       ),
    .idu2exu_alu_src2       (idu2exu_alu_src2       )
);

wire                                idu2exu_en_r;
wire [`CPU_WIDTH            -1:0]   idu2exu_pc_r;
wire [`CPU_WIDTH            -1:0]   idu2exu_inst_r;

wire [`BRAN_WIDTH           -1:0]   idu2exu_branch_r;     // idu_branch flag
wire [`JUMP_WIDTH           -1:0]   idu2exu_jump_r;       // idu_jump flag

wire                                idu2exu_reg_wen_r;    // register write enable
wire [`REG_ADDR_WIDTH       -1:0]   idu2exu_reg_waddr_r;  // register write address
wire [`REG_DATA_WIDTH       -1:0]   idu2exu_reg1_rdata_r; // register write address
wire [`REG_DATA_WIDTH       -1:0]   idu2exu_reg2_rdata_r; // register write address
wire [`CPU_WIDTH            -1:0]   idu2exu_imm_r;

wire [`REG_DATA_WIDTH       -1:0]   idu2exu_reg_wdata_r;  // register write address

wire                                idu2exu_mem_wen_r;    // memory write enable
wire [`DATA_MEM_ADDR_WIDTH  -1:0]   idu2exu_mem_waddr_r;  // register write address
wire                                idu2exu_mem_ren_r;    // memory read enable
wire [`DATA_MEM_ADDR_WIDTH  -1:0]   idu2exu_mem_raddr_r;  // register write address

wire                                idu2exu_mem2reg_r;    // memory to register flag
wire [`MEM_OP_WIDTH         -1:0]   idu2exu_mem_op_r;     // memory opcode

wire [`ALU_OP_WIDTH         -1:0]   idu2exu_alu_op_r;     // alu opcode
wire [`CPU_WIDTH            -1:0]   idu2exu_alu_src1_r;     // alu opcode
wire [`CPU_WIDTH            -1:0]   idu2exu_alu_src2_r; // alu source select flag

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
    .idu2exu_reg1_rdata     (idu2exu_reg1_rdata     ),
    .idu2exu_reg2_rdata     (idu2exu_reg2_rdata     ),
    .idu2exu_imm            (idu2exu_imm            ),

    .idu2exu_mem_wen        (idu2exu_mem_wen        ),
    .idu2exu_mem_waddr      (idu2exu_mem_waddr      ),
    .idu2exu_mem_ren        (idu2exu_mem_ren        ),
    .idu2exu_mem_raddr      (idu2exu_mem_raddr      ),

    .idu2exu_mem2reg        (idu2exu_mem2reg        ),
    .idu2exu_mem_op         (idu2exu_mem_op         ),

    .idu2exu_alu_op         (idu2exu_alu_op         ),
    .idu2exu_alu_src1       (idu2exu_alu_src1       ),
    .idu2exu_alu_src2       (idu2exu_alu_src2       ),
//output
    .idu2exu_en_r           (idu2exu_en_r           ),
    .idu2exu_pc_r           (idu2exu_pc_r           ),
    .idu2exu_inst_r         (idu2exu_inst_r         ),

    .idu2exu_branch_r       (idu2exu_branch_r       ),
    .idu2exu_jump_r         (idu2exu_jump_r         ),

    .idu2exu_reg_wen_r      (idu2exu_reg_wen_r      ),
    .idu2exu_reg_waddr_r    (idu2exu_reg_waddr_r    ),
    .idu2exu_reg1_rdata_r   (idu2exu_reg1_rdata_r   ),
    .idu2exu_reg2_rdata_r   (idu2exu_reg2_rdata_r   ),
    .idu2exu_imm_r          (idu2exu_imm_r          ),

    .idu2exu_mem_wen_r      (idu2exu_mem_wen_r      ),
    .idu2exu_mem_waddr_r    (idu2exu_mem_waddr_r    ),
    .idu2exu_mem_ren_r      (idu2exu_mem_ren_r      ),
    .idu2exu_mem_raddr_r    (idu2exu_mem_raddr_r    ),

    .idu2exu_mem2reg_r      (idu2exu_mem2reg_r      ),
    .idu2exu_mem_op_r       (idu2exu_mem_op_r       ),

    .idu2exu_alu_op_r       (idu2exu_alu_op_r       ),
    .idu2exu_alu_src1_r     (idu2exu_alu_src1_r     ),
    .idu2exu_alu_src2_r     (idu2exu_alu_src2_r     ),

    .branch_en              (branch_en              ),
    .jump_en                (jump_en                )
);


wire                             exu2mem_en;
wire [`CPU_WIDTH           -1:0] exu2mem_pc;
wire [`CPU_WIDTH           -1:0] exu2mem_inst;

wire                             exu2mem_mem_wen;    
wire [`DATA_MEM_ADDR_WIDTH -1:0] exu2mem_mem_waddr;
wire [`DATA_MEM_DATA_WIDTH -1:0] exu2mem_mem_wdata;

wire                             exu2mem_mem_ren;    
wire [`DATA_MEM_ADDR_WIDTH -1:0] exu2mem_mem_raddr;
wire [`DATA_MEM_DATA_WIDTH -1:0] mem2exu_mem_rdata;

wire                             exu2reg_reg_wen;    
wire [`REG_ADDR_WIDTH      -1:0] exu2reg_reg_waddr;
wire [`REG_DATA_WIDTH      -1:0] exu2reg_reg_wdata;


EXU U_EXU (
    .clk               ( clk                  ),
    .rst_n             ( rst_n                ),
    .enable            ( enable               ),

    .idu2exu_en        ( idu2exu_en_r         ),
    .idu2exu_pc        ( idu2exu_pc_r         ),
    .idu2exu_inst      ( idu2exu_inst_r       ),

    .idu2exu_branch    ( idu2exu_branch_r     ),
    .idu2exu_jump      ( idu2exu_jump_r       ),

    .idu2exu_reg_wen   ( idu2exu_reg_wen_r    ),
    .idu2exu_reg_waddr ( idu2exu_reg_waddr_r  ),
    .idu2exu_reg1_rdata( idu2exu_reg1_rdata_r ),
    .idu2exu_reg2_rdata( idu2exu_reg2_rdata_r ),
    .idu2exu_imm       ( idu2exu_imm_r        ),

    .idu2exu_mem_wen   ( idu2exu_mem_wen_r    ),
    .idu2exu_mem_waddr ( idu2exu_mem_waddr_r  ),
    .idu2exu_mem_ren   ( idu2exu_mem_ren_r    ),
    .idu2exu_mem_raddr ( idu2exu_mem_raddr_r  ),

    .idu2exu_mem2reg   ( idu2exu_mem2reg_r    ),
    .idu2exu_mem_op    ( idu2exu_mem_op_r     ),

    .idu2exu_alu_op    ( idu2exu_alu_op_r     ),
    .idu2exu_alu_src1  ( idu2exu_alu_src1_r   ),
    .idu2exu_alu_src2  ( idu2exu_alu_src2_r   ),

    .exu2mem_en        ( exu2mem_en           ),
    .exu2mem_pc        ( exu2mem_pc           ),
    .exu2mem_inst      ( exu2mem_inst         ),

    .exu2mem_mem_wen   ( exu2mem_mem_wen      ),
    .exu2mem_mem_waddr ( exu2mem_mem_waddr    ),
    .exu2mem_mem_wdata ( exu2mem_mem_wdata    ),

    .exu2mem_mem_ren   ( exu2mem_mem_ren      ),
    .exu2mem_mem_raddr ( exu2mem_mem_raddr    ),
    .mem2exu_mem_rdata ( mem2exu_mem_rdata    ),

    .exu2reg_reg_wen   ( exu2reg_reg_wen      ),
    .exu2reg_reg_waddr ( exu2reg_reg_waddr    ),
    .exu2reg_reg_wdata ( exu2reg_reg_wdata    ),

    .branch_en         ( branch_en            ),
    .branch_pc         ( branch_pc            ),
    .jump_en           ( jump_en              ),
    .jump_pc           ( jump_pc              )
);

REGS_RVSEED U_REGS_RVSEED(
    .clk_reg           ( clk                ),
    .rst_reg_n         ( rst_n              ),

    .reg1_raddr        ( idu2reg_reg1_raddr ),
    .reg2_raddr        ( idu2reg_reg2_raddr ),
    .reg1_rdata        ( reg2idu_reg1_rdata ),
    .reg2_rdata        ( reg2idu_reg2_rdata ),

    .reg_wen           ( exu2reg_reg_wen    ),
    .reg_waddr         ( exu2reg_reg_waddr  ),
    .reg_wdata         ( exu2reg_reg_wdata  )

);

DATA_MEM U_DATA_MEM(
    .clk                            ( clk                           ),

    .mem_wen                        ( exu2mem_mem_wen               ),
    .mem_waddr                      ( exu2mem_mem_waddr             ),
    .mem_wdata                      ( exu2mem_mem_wdata             ),

    .mem_ren                        ( exu2mem_mem_ren               ),
    .mem_raddr                      ( exu2mem_mem_raddr             ),
    .mem_rdata                      ( mem2exu_mem_rdata             )
);

endmodule
