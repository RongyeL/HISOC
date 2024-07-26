// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : rvseed.v
// Author        : Rongye
// Created On    : 2022-03-25 03:42
// Last Modified : 2024-07-26 09:38
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
    output wire                          rvseed_mst_arvalid,
    input  wire                          rvseed_mst_arready,
    output wire [`AXI_ID_WIDTH     -1:0] rvseed_mst_arid,
    output wire [`AXI_ADDR_WIDTH   -1:0] rvseed_mst_araddr,
    output wire [`AXI_LEN_WIDTH    -1:0] rvseed_mst_arlen,
    output wire [`AXI_SIZE_WIDTH   -1:0] rvseed_mst_arsize,
    output wire [`AXI_BURST_WIDTH  -1:0] rvseed_mst_arburst,
    output wire                          rvseed_mst_arlock,
    output wire [`AXI_CACHE_WIDTH  -1:0] rvseed_mst_arcache,
    output wire [`AXI_PROT_WIDTH   -1:0] rvseed_mst_arprot,
    output wire [`AXI_QOS_WIDTH    -1:0] rvseed_mst_arqos,
    output wire [`AXI_REGION_WIDTH -1:0] rvseed_mst_arregion,
// R channel
    input  wire                          rvseed_mst_rvalid,
    output wire                          rvseed_mst_rready,
    input  wire [`AXI_ID_WIDTH     -1:0] rvseed_mst_rid,
    input  wire [`AXI_DATA_WIDTH   -1:0] rvseed_mst_rdata,
    input  wire [`AXI_RESP_WIDTH   -1:0] rvseed_mst_rresp,
    input  wire                          rvseed_mst_rlast
);
wire                          ifu_mst_arvalid;
wire                          ifu_mst_arready;
wire [`AXI_ID_WIDTH     -1:0] ifu_mst_arid;
wire [`AXI_ADDR_WIDTH   -1:0] ifu_mst_araddr;
wire [`AXI_LEN_WIDTH    -1:0] ifu_mst_arlen;
wire [`AXI_SIZE_WIDTH   -1:0] ifu_mst_arsize;
wire [`AXI_BURST_WIDTH  -1:0] ifu_mst_arburst;
wire                          ifu_mst_arlock;
wire [`AXI_CACHE_WIDTH  -1:0] ifu_mst_arcache;
wire [`AXI_PROT_WIDTH   -1:0] ifu_mst_arprot;
wire [`AXI_QOS_WIDTH    -1:0] ifu_mst_arqos;
wire [`AXI_REGION_WIDTH -1:0] ifu_mst_arregion;

wire                          ifu_mst_rvalid;
wire                          ifu_mst_rready;
wire [`AXI_ID_WIDTH     -1:0] ifu_mst_rid;
wire [`AXI_DATA_WIDTH   -1:0] ifu_mst_rdata;
wire [`AXI_RESP_WIDTH   -1:0] ifu_mst_rresp;
wire                          ifu_mst_rlast;
IFU U_IFU (
// global 
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
    .axi_mst_rlast      (ifu_mst_rlast      )
);
// output port
assign rvseed_mst_arvalid  = ifu_mst_arvalid   ;
assign ifu_mst_arready     = rvseed_mst_arready;

assign rvseed_mst_arid     = ifu_mst_arid      ;
assign rvseed_mst_araddr   = ifu_mst_araddr    ;
assign rvseed_mst_arlen    = ifu_mst_arlen     ;
assign rvseed_mst_arsize   = ifu_mst_arsize    ;
assign rvseed_mst_arburst  = ifu_mst_arburst   ;
assign rvseed_mst_arlock   = ifu_mst_arlock    ;
assign rvseed_mst_arcache  = ifu_mst_arcache   ;
assign rvseed_mst_arprot   = ifu_mst_arprot    ;
assign rvseed_mst_arqos    = ifu_mst_arqos     ;
assign rvseed_mst_arregion = ifu_mst_arregion  ;

assign ifu_mst_rvalid      = rvseed_mst_rvalid ;
assign rvseed_mst_rready   = ifu_mst_rready    ;
assign ifu_mst_rid         = rvseed_mst_rid    ;
assign ifu_mst_rdata       = rvseed_mst_rdata  ;
assign ifu_mst_rresp       = rvseed_mst_rresp  ;
assign ifu_mst_rlast       = rvseed_mst_rlast  ;

endmodule
