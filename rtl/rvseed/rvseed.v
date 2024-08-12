// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : rvseed.v
// Author        : Rongye
// Created On    : 2022-03-25 03:42
// Last Modified : 2024-08-12 08:14
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

wire [`BRAN_WIDTH           -1:0]   idu2exu_branch;     // idu_branch flag
wire [`JUMP_WIDTH           -1:0]   idu2exu_jump;       // idu_jump flag

wire [`REG_ADDR_WIDTH       -1:0]   idu2reg_reg1_raddr; // register 1 read address
wire [`REG_ADDR_WIDTH       -1:0]   idu2reg_reg2_raddr; // register 2 read address
wire [`REG_DATA_WIDTH       -1:0]   reg2idu_reg1_rdata;       // idu_jump flag
wire [`REG_DATA_WIDTH       -1:0]   reg2idu_reg2_rdata;       // idu_jump flag

wire                                idu2exu_reg_wen;    // register write enable
wire [`REG_ADDR_WIDTH       -1:0]   idu2exu_reg_waddr;  // register write address
wire [`REG_DATA_WIDTH       -1:0]   idu2exu_reg_wdata;  // register write address

wire                                idu2exu_mem_wen;    // memory write enable
wire [`DATA_MEM_ADDR_WIDTH  -1:0]   idu2exu_mem_waddr;  // register write address
wire                                idu2exu_mem_ren;    // memory read enable
wire [`DATA_MEM_ADDR_WIDTH  -1:0]   idu2exu_mem_raddr;  // register write address

wire                                idu2exu_mem2reg;    // memory to register flag
wire [`MEM_OP_WIDTH         -1:0]   idu2exu_mem_op;     // memory opcode

wire [`ALU_OP_WIDTH         -1:0]   idu2exu_alu_op;     // alu opcode
wire [`CPU_WIDTH            -1:0]   idu2exu_alu_src1;     // alu opcode
wire [`CPU_WIDTH            -1:0]   idu2exu_alu_src2; // alu source select flag

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

assign idu2exu_reg_wdata = {`REG_DATA_WIDTH{1'b0}};
REGS_RVSEED U_REGS_RVSEED(
    .clk_reg                (clk                    ),
    .rst_reg_n              (rst_n                  ),

    .reg1_raddr             (idu2reg_reg1_raddr     ),
    .reg2_raddr             (idu2reg_reg2_raddr     ),
    .reg1_rdata             (reg2idu_reg1_rdata     ),
    .reg2_rdata             (reg2idu_reg2_rdata     ),

    .reg_wen                (idu2exu_reg_wen      ),
    .reg_waddr              (idu2exu_reg_waddr    ),
    .reg_wdata              (idu2exu_reg_wdata    )

);

// MUX_ALU U_MUX_ALU(
    // .alu_src_sel                    ( idu2exu_alu_src_sel_r        ),
    // .reg1_rdata                     ( reg2idu_reg1_rdata           ),
    // .reg2_rdata                     ( reg2idu_reg2_rdata           ),
    // .imm                            ( idu2exu_imm_r                ),
    // .curr_pc                        ( idu2exu_pc_r                 ),
    // .alu_src1                       ( alu_src1                     ),
    // .alu_src2                       ( alu_src2                     )
// );

// ALU U_ALU(
    // .alu_op                         ( idu2exu_alu_op_r             ),
    // .alu_src1                       ( alu_src1                     ),
    // .alu_src2                       ( alu_src2                     ),
    // .alu_res                        ( alu_res                      )
// );
// assign branch_en = ((idu2exu_branch_r == `BRAN_TYPE_A) &&  (alu_res==1)) 
                         // | ((idu2exu_branch_r == `BRAN_TYPE_B) && ~(alu_res==1)); 
// assign branch_pc = idu2exu_pc_r + idu2exu_imm_r;
// assign jump_en   = (idu2exu_jump_r == `JUMP_JAL) | (idu2exu_jump_r == `JUMP_JALR);
// assign jump_pc   = (idu2exu_jump_r == `JUMP_JAL) ? idu2exu_pc_r + idu2exu_imm_r
                                                         // : reg2idu_reg1_rdata + idu2exu_imm_r;
assign branch_en = 1'b0;
assign jump_en   = 1'b0;
    
wire [`DATA_MEM_ADDR_WIDTH            -1:0]   mem_addr;       // idu_jump flag
wire [`DATA_MEM_DATA_WIDTH            -1:0]   mem_rdata;       // idu_jump flag
wire [`DATA_MEM_DATA_WIDTH            -1:0]   mem_wdata;       // idu_jump flag

// assign mem_addr   = alu_res;

// wire [`MEM_OP_WIDTH-1:0] mem_op     = idu2exu_mem_op_r;
// wire [`CPU_WIDTH   -1:0] reg2_rdata = reg2idu_reg2_rdata;

// always @(*) begin
    // case (idu2exu_mem_op_r)
        // `MEM_SB:
            // case (mem_addr[1:0])
                // 2'h0: mem_wdata = {mem_rdata[31:8],  reg2_rdata[7:0]};
                // 2'h1: mem_wdata = {mem_rdata[31:16], reg2_rdata[7:0], mem_rdata[7:0]};
                // 2'h2: mem_wdata = {mem_rdata[31:24], reg2_rdata[7:0], mem_rdata[15:0]};
                // 2'h3: mem_wdata = {reg2_rdata[7:0],  mem_rdata[23:0]};
            // endcase
        // `MEM_SH:
            // case (mem_addr[1])
                // 1'h0: mem_wdata = {mem_rdata[31:16], reg2_rdata[15:0]};
                // 1'h1: mem_wdata = {reg2_rdata[15:0], mem_rdata[15:0]};
            // endcase
        // `MEM_SW:
                // mem_wdata = reg2_rdata;
        // default:; // ? 
    // endcase
// end

DATA_MEM U_DATA_MEM(
    .clk                            ( clk                           ),
    .mem_wen                        ( idu2exu_mem_wen               ),
    .mem_ren                        ( idu2exu_mem_ren               ),
    .mem_addr                       ( mem_addr                      ),
    .mem_wdata                      ( mem_wdata                     ),
    .mem_rdata                      ( mem_rdata                     )
);

// MUX_REG U_MUX_REG(
    // .mem2reg                        ( idu2exu_mem2reg_r             ),
    // .alu_res                        ( alu_res                       ),
    // .mem_op                         ( idu2exu_mem_op_r              ),
    // .mem_addr                       ( mem_addr                      ),
    // .mem_rdata                      ( mem_rdata                     ),
    // .reg_wdata                      ( idu2exu_reg_wdata_r           )
// );
endmodule
