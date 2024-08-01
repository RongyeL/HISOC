// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : rvseed.v
// Author        : Rongye
// Created On    : 2022-03-25 03:42
// Last Modified : 2024-07-31 09:18
// ---------------------------------------------------------------------------------
// Description   : rvseed cpu top module.
//                 
//
// -FHDR----------------------------------------------------------------------------
module RVSEED (
// global 
    input  wire                          clk,
    input  wire                          rst_n,             // 
    input  wire                          enable,            // 
// AR channel
    output wire                          ifu_mst_arvalid,
    input  wire                          ifu_mst_arready,
    output wire [`AXI_ID_WIDTH     -1:0] ifu_mst_arid,
    output wire [`AXI_ADDR_WIDTH   -1:0] ifu_mst_araddr,
    output wire [`AXI_LEN_WIDTH    -1:0] ifu_mst_arlen,
    output wire [`AXI_SIZE_WIDTH   -1:0] ifu_mst_arsize,
    output wire [`AXI_BURST_WIDTH  -1:0] ifu_mst_arburst,
    output wire                          ifu_mst_arlock,
    output wire [`AXI_CACHE_WIDTH  -1:0] ifu_mst_arcache,
    output wire [`AXI_PROT_WIDTH   -1:0] ifu_mst_arprot,
    output wire [`AXI_QOS_WIDTH    -1:0] ifu_mst_arqos,
    output wire [`AXI_REGION_WIDTH -1:0] ifu_mst_arregion,
// R channel
    input  wire                          ifu_mst_rvalid,
    output wire                          ifu_mst_rready,
    input  wire [`AXI_ID_WIDTH     -1:0] ifu_mst_rid,
    input  wire [`AXI_DATA_WIDTH   -1:0] ifu_mst_rdata,
    input  wire [`AXI_RESP_WIDTH   -1:0] ifu_mst_rresp,
    input  wire                          ifu_mst_rlast
);


wire                              ifu_done_en;
wire [`CPU_WIDTH            -1:0] ifu_inst_pc;
wire [`CPU_WIDTH            -1:0] ifu_inst;

wire                              idu_done_en;
wire [`CPU_WIDTH            -1:0] idu_inst_pc;
wire [`CPU_WIDTH            -1:0] idu_inst;

wire [`BRAN_WIDTH           -1:0] branch;     // branch flag
wire                              zero;    // memory write enable
wire [`JUMP_WIDTH           -1:0] jump;       // jump flag

wire                              reg_wen;    // register write enable
wire [`REG_ADDR_WIDTH       -1:0] reg_waddr;  // register write address
wire [`REG_ADDR_WIDTH       -1:0] reg1_raddr; // register 1 read address
wire [`REG_ADDR_WIDTH       -1:0] reg2_raddr; // register 2 read address
wire [`CPU_WIDTH            -1:0] reg1_rdata;       // jump flag
wire [`CPU_WIDTH            -1:0] reg2_rdata;       // jump flag
wire [`CPU_WIDTH            -1:0] reg_wdata;       // jump flag
wire [`CPU_WIDTH            -1:0] alu_src1;       // jump flag
wire [`CPU_WIDTH            -1:0] alu_src2;       // jump flag
wire [`CPU_WIDTH            -1:0] alu_res;       // jump flag

wire                              mem_wen;    // memory write enable
wire                              mem_ren;    // memory read enable
wire                              mem2reg;    // memory to register flag
wire [`MEM_OP_WIDTH         -1:0] mem_op;     // memory opcode

wire [`CPU_WIDTH            -1:0] mem_addr;       // jump flag
wire [`CPU_WIDTH            -1:0] mem_rdata;       // jump flag
wire [`CPU_WIDTH            -1:0] mem_wdata;       // jump flag

wire [`CPU_WIDTH            -1:0] imm;        // immediate value

wire [`ALU_OP_WIDTH         -1:0] alu_op;     // alu opcode
wire [`ALU_SRC_WIDTH        -1:0] alu_src_sel; // alu source select flag

IFU U_IFU (
    .clk                (clk                ),
    .rst_n              (rst_n              ),   
    .enable             (enable             ),   

    .branch             (branch      ),
    .zero               (zero        ),
    .jump               (jump        ),
    .imm                (imm        ),
    .reg1_rdata         (reg1_rdata        ),


    .axi_mst_arvalid    (ifu_mst_arvalid    ),
    .axi_mst_arready    (ifu_mst_arready    ),
    .axi_mst_arid       (ifu_mst_arid       ),
    .axi_mst_araddr     (ifu_mst_araddr     ),
    .axi_mst_arlen      (ifu_mst_arlen      ),
    .axi_mst_arsize     (ifu_mst_arsize     ),
    .axi_mst_arburst    (ifu_mst_arburst    ),
    .axi_mst_arlock     (ifu_mst_arlock     ),
    .axi_mst_arcache    (ifu_mst_arcache    ),
    .axi_mst_arprot     (ifu_mst_arprot     ),
    .axi_mst_arqos      (ifu_mst_arqos      ),
    .axi_mst_arregion   (ifu_mst_arregion   ),
                        
    .axi_mst_rvalid     (ifu_mst_rvalid     ),
    .axi_mst_rready     (ifu_mst_rready     ),
    .axi_mst_rid        (ifu_mst_rid        ),
    .axi_mst_rdata      (ifu_mst_rdata      ),     
    .axi_mst_rresp      (ifu_mst_rresp      ),
    .axi_mst_rlast      (ifu_mst_rlast      ),

    .ifu_done_en        (ifu_done_en        ),
    .ifu_inst_pc        (ifu_inst_pc        ),
    .ifu_inst           (ifu_inst           ),

    .idu_inst_pc        (idu_inst_pc        )
);

IDU U_IDU (
// global 
    .clk                  (clk                  ),
    .rst_n                (rst_n                ),   
    .enable               (enable               ),   

    .ifu_done_en          (ifu_done_en          ),
    .ifu_inst_pc          (ifu_inst_pc          ),
    .ifu_inst             (ifu_inst             ),

    .idu_done_en          (idu_done_en          ),
    .idu_inst_pc          (idu_inst_pc          ),
    .idu_inst             (idu_inst             ),

    .idu_inst_branch      (branch      ),
    .zero                 (zero        ),
    .idu_inst_jump        (jump        ),

    .idu_inst_reg_wen     (reg_wen     ),
    .idu_inst_reg_waddr   (reg_waddr   ),
    .idu_inst_reg1_raddr  (reg1_raddr  ),
    .idu_inst_reg2_raddr  (reg2_raddr  ),
    .idu_inst_mem_wen     (mem_wen     ),
    .idu_inst_mem_ren     (mem_ren     ),
    .idu_inst_mem2reg     (mem2reg     ),
    .idu_inst_mem_op      (mem_op      ),
    .idu_inst_imm         (imm         ),
    .idu_inst_alu_op      (alu_op      ),
    .idu_inst_alu_src_sel (alu_src_sel )
);

REG_RVSEED U_REG_RVSEED(
    .clk                            ( clk                           ),
    .rst_n                          ( rst_n                         ),
    .reg_wen                        ( reg_wen                       ),
    .reg_waddr                      ( reg_waddr                     ),
    .reg_wdata                      ( reg_wdata                     ),
    .reg1_raddr                     ( reg1_raddr                    ),
    .reg2_raddr                     ( reg2_raddr                    ),
    .reg1_rdata                     ( reg1_rdata                    ),
    .reg2_rdata                     ( reg2_rdata                    )
);


MUX_ALU U_MUX_ALU(
    .alu_src_sel                    ( alu_src_sel                   ),
    .reg1_rdata                     ( reg1_rdata                    ),
    .reg2_rdata                     ( reg2_rdata                    ),
    .imm                            ( imm                           ),
    .curr_pc                        ( idu_inst_pc                   ),
    .alu_src1                       ( alu_src1                      ),
    .alu_src2                       ( alu_src2                      )
);

ALU U_ALU(
    .alu_op                         ( alu_op                        ),
    .alu_src1                       ( alu_src1                      ),
    .alu_src2                       ( alu_src2                      ),
    .zero                           ( zero                          ),
    .alu_res                        ( alu_res                       )
);

assign mem_addr = alu_res; 
MUX_MEM U_MUX_MEM(
    .mem_op                         ( mem_op                        ),
    .mem_addr                       ( mem_addr                      ),
    .reg2_rdata                     ( reg2_rdata                    ),
    .mem_rdata                      ( mem_rdata                     ),
    .mem_wdata                      ( mem_wdata                     )
);

DATA_MEM U_DATA_MEM(
    .clk                            ( clk                           ),
    .mem_wen                        ( mem_wen                       ),
    .mem_ren                        ( mem_ren                       ),
    .mem_addr                       ( mem_addr                      ),
    .mem_wdata                      ( mem_wdata                     ),
    .mem_rdata                      ( mem_rdata                     )
);

MUX_REG U_MUX_REG(
    .mem2reg                        ( mem2reg                       ),
    .alu_res                        ( alu_res                       ),
    .mem_op                         ( mem_op                        ),
    .mem_addr                       ( mem_addr                      ),
    .mem_rdata                      ( mem_rdata                     ),
    .reg_wdata                      ( reg_wdata                     )
);
endmodule
