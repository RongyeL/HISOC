// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : m_axi.v
// Author        : Rongye
// Created On    : 2022-12-25 03:08
// Last Modified : 2024-07-30 10:01
// ---------------------------------------------------------------------------------
// Description   :
//
//
// -FHDR----------------------------------------------------------------------------
module IFU(
// global 
    input  wire                              clk,
    input  wire                              rst_n,          // active low
    input  wire                              enable,          // rvseed enable ctrl

    input  wire [`BRAN_WIDTH           -1:0] branch,     // branch flag
    input  wire                              zero,       // jump flag
    input  wire [`JUMP_WIDTH           -1:0] jump,       // jump flag
    input  wire [`CPU_WIDTH            -1:0] imm,       // jump flag
    input  wire [`CPU_WIDTH            -1:0] reg1_rdata,       // jump flag


// AR channel
    output wire                              axi_mst_arvalid,
    input  wire                              axi_mst_arready,
    output wire [`AXI_ID_WIDTH         -1:0] axi_mst_arid,
    output wire [`AXI_ADDR_WIDTH       -1:0] axi_mst_araddr,
    output wire [`AXI_LEN_WIDTH        -1:0] axi_mst_arlen,
    output wire [`AXI_SIZE_WIDTH       -1:0] axi_mst_arsize,
    output wire [`AXI_BURST_WIDTH      -1:0] axi_mst_arburst,
    output wire                              axi_mst_arlock,
    output wire [`AXI_CACHE_WIDTH      -1:0] axi_mst_arcache,
    output wire [`AXI_PROT_WIDTH       -1:0] axi_mst_arprot,
    output wire [`AXI_QOS_WIDTH        -1:0] axi_mst_arqos,
    output wire [`AXI_REGION_WIDTH     -1:0] axi_mst_arregion,
// R channel
    input  wire                              axi_mst_rvalid,
    output wire                              axi_mst_rready,
    input  wire [`AXI_ID_WIDTH         -1:0] axi_mst_rid,
    input  wire [`AXI_DATA_WIDTH       -1:0] axi_mst_rdata,
    input  wire [`AXI_RESP_WIDTH       -1:0] axi_mst_rresp,
    input  wire                              axi_mst_rlast,

    output wire                              ifu_start_en,
    output wire                              ifu_done_en,
    output wire [`CPU_WIDTH            -1:0] ifu_inst_pc,
    output wire [`CPU_WIDTH            -1:0] ifu_inst,
    input  wire [`CPU_WIDTH            -1:0] idu_inst_pc
);

localparam DLY = 0.1;

wire                          branch_active = ((branch == `BRAN_TYPE_A) &&  zero) | ((branch == `BRAN_TYPE_B) && ~zero); 
wire                          next_en;
wire [`CPU_WIDTH        -1:0] curr_pc;    
wire [`CPU_WIDTH        -1:0] next_pc;    

wire                          rd_req_en;
wire [`AXI_ID_WIDTH     -1:0] rd_id        = curr_pc[`AXI_ID_WIDTH-1:0];
wire [`AXI_ADDR_WIDTH   -1:0] rd_base_addr = `INST_MEM_BASE_ADDR + curr_pc;
wire [`AXI_LEN_WIDTH    -1:0] rd_len       = `AXI_LEN_WIDTH'h0; // len = 1
wire [`AXI_SIZE_WIDTH   -1:0] rd_size      = `AXI_SIZE_4_BYTE;
wire [`AXI_BURST_WIDTH  -1:0] rd_burst     = `AXI_BURTS_INCR;
wire [`AXI_LOCK_WIDTH   -1:0] rd_lock      = `AXI_LOCK_WIDTH'b0;
wire [`AXI_CACHE_WIDTH  -1:0] rd_cache     = `AXI_CACHE_WIDTH'b0000;
wire [`AXI_PROT_WIDTH   -1:0] rd_prot      = `AXI_PROT_WIDTH'b000;
wire [`AXI_QOS_WIDTH    -1:0] rd_qos       = `AXI_QOS_WIDTH'h0;
wire [`AXI_REGION_WIDTH -1:0] rd_region    = `AXI_REGION_WIDTH'h0;

wire                          rd_result_en; 
wire [`AXI_DATA_WIDTH   -1:0] rd_result_data;

wire                          ifu_process   = rd_req_en;
reg                           ifu_process_r;
reg  [`CPU_WIDTH        -1:0] ifu_inst_pc_r;

wire                          full; 
wire                          empty; 
wire  [32        -1:0] rd_dat;
wire                          rd_dat_vld; 
wire [3        -1:0] fifo_num;
// PC REGISTER INST
assign next_en = enable & (ifu_done_en | branch_active);
PC_REG U_PC_REG(
    .clk                            ( clk                           ),
    .rst_n                          ( rst_n                         ),
    .next_en                        ( next_en                       ),
    .next_pc                        ( next_pc                       ),
    .curr_pc                        ( curr_pc                       )
);


MUX_PC U_MUX_PC(
    .ena                            ( next_en                       ),
    .branch                         ( branch                        ),
    .zero                           ( zero                          ),
    .jump                           ( jump                          ),
    .imm                            ( imm                           ),
    .reg1_rdata                     ( reg1_rdata                    ),
    .curr_pc                        ( curr_pc                       ),
    .idu_inst_pc                    ( idu_inst_pc                   ),
    .next_pc                        ( next_pc                       )
);

// AXI_MST_RD_CTRL INST
assign rd_req_en = enable & ~ifu_process_r;
AXI_MST_RD_CTRL U_AXI_MST_RD_CTRL(
    .clk                (clk                ),
    .rst_n              (rst_n              ), 
                        
    .rd_req_en          (rd_req_en          ), 
    .rd_id              (rd_id              ),
    .rd_base_addr       (rd_base_addr       ),
    .rd_len             (rd_len             ),
    .rd_size            (rd_size            ),
    .rd_burst           (rd_burst           ),
    .rd_lock            (rd_lock            ),
    .rd_cache           (rd_cache           ),
    .rd_prot            (rd_prot            ),
    .rd_qos             (rd_qos             ),
    .rd_region          (rd_region          ),

    .rd_result_en       (rd_result_en       ), 
    .rd_result_data     (rd_result_data     ),
                        
    .axi_mst_arvalid    (axi_mst_arvalid    ),
    .axi_mst_arready    (axi_mst_arready    ),
    .axi_mst_arid       (axi_mst_arid       ),
    .axi_mst_araddr     (axi_mst_araddr     ),
    .axi_mst_arlen      (axi_mst_arlen      ),
    .axi_mst_arsize     (axi_mst_arsize     ),
    .axi_mst_arburst    (axi_mst_arburst    ),
    .axi_mst_arlock     (axi_mst_arlock     ),
    .axi_mst_arcache    (axi_mst_arcache    ),
    .axi_mst_arprot     (axi_mst_arprot     ),
    .axi_mst_arqos      (axi_mst_arqos      ),
    .axi_mst_arregion   (axi_mst_arregion   ),
                        
    .axi_mst_rvalid     (axi_mst_rvalid     ),
    .axi_mst_rready     (axi_mst_rready     ),
    .axi_mst_rid        (axi_mst_rid        ),
    .axi_mst_rdata      (axi_mst_rdata      ),     
    .axi_mst_rresp      (axi_mst_rresp      ),
    .axi_mst_rlast      (axi_mst_rlast      )
);

SYNC_FIFO #(
    .FIFO_DEEP   (8 ),
    .FIFO_DEEP_W (3 ),
    .FIFO_DATA_W (32)
) U_INST_FIFO 
(
    .clk           (clk         ),
    .rst_n         (rst_n       ),
    .wr            (rd_result_en & ~branch_active          ),
    .rd            (rd_req_en & ~branch_active & ~empty           ),
    .wr_dat        (rd_result_data      ),
    .rd_dat        (rd_dat      ),
    .rd_dat_vld    (rd_dat_vld  ),

    .full          (full        ),
    .empty         (empty       ),
    .fifo_num      (fifo_num    )
);
// ---------------------------------------------------------------------------------
// IFU CTRL
// ---------------------------------------------------------------------------------
assign ifu_start_en  = rd_req_en & ~branch_active;
assign ifu_done_en   = rd_result_en & ~branch_active;
assign ifu_inst_pc   = ifu_inst_pc_r;
assign ifu_inst      = rd_result_data;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ifu_inst_pc_r <= #DLY `CPU_WIDTH'b0;
    end
    else if (ifu_start_en) begin
        ifu_inst_pc_r <= #DLY curr_pc;
    end
end
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ifu_process_r <= #DLY 1'b0;
    end
    else if (ifu_start_en) begin
        ifu_process_r <= #DLY ifu_process;
    end
    else if (ifu_done_en) begin
        ifu_process_r <= #DLY 1'b0;
    end
end
endmodule

