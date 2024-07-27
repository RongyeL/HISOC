// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : rvseed.v
// Author        : Rongye
// Created On    : 2022-03-25 03:42
// Last Modified : 2024-07-27 10:05
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


wire                              ifu_start_en;
wire                              ifu_done_en;
wire [`CPU_WIDTH            -1:0] ifu_inst_pc;
wire [`CPU_WIDTH            -1:0] ifu_inst;

IFU U_IFU (
    .clk                (clk                ),
    .rst_n              (rst_n              ),   
    .enable             (enable             ),   

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

    .ifu_start_en       (ifu_start_en       ),
    .ifu_done_en        (ifu_done_en        ),
    .ifu_inst_pc        (ifu_inst_pc        ),
    .ifu_inst           (ifu_inst           )
);

IDU U_IDU (
// global 
    .clk                (clk                ),
    .rst_n              (rst_n              ),   
    .enable             (enable             ),   

    .ifu_start_en       (ifu_start_en       ),
    .ifu_done_en        (ifu_done_en        ),
    .ifu_inst_pc        (ifu_inst_pc        ),
    .ifu_inst           (ifu_inst           )

);

endmodule
