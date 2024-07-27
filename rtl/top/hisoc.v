// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : hisoc.v
// Author        : Rongye
// Created On    : 2024-07-26 09:23
// Last Modified : 2024-07-27 09:09
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module HISOC (
// Global 
    input  wire                   clk,
    input  wire                   rst_n,              
    input  wire                   enable              
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

RVSEED U_RVSEED (
    .clk                (clk                ),
    .rst_n              (rst_n              ),   
    .enable             (enable             ),   

    .ifu_mst_arvalid    (ifu_mst_arvalid    ),
    .ifu_mst_arready    (ifu_mst_arready    ),
    .ifu_mst_arid       (ifu_mst_arid       ),
    .ifu_mst_araddr     (ifu_mst_araddr     ),
    .ifu_mst_arlen      (ifu_mst_arlen      ),
    .ifu_mst_arsize     (ifu_mst_arsize     ),
    .ifu_mst_arburst    (ifu_mst_arburst    ),
    .ifu_mst_arlock     (ifu_mst_arlock     ),
    .ifu_mst_arcache    (ifu_mst_arcache    ),
    .ifu_mst_arprot     (ifu_mst_arprot     ),
    .ifu_mst_arqos      (ifu_mst_arqos      ),
    .ifu_mst_arregion   (ifu_mst_arregion   ),

    .ifu_mst_rvalid     (ifu_mst_rvalid     ),
    .ifu_mst_rready     (ifu_mst_rready     ),
    .ifu_mst_rid        (ifu_mst_rid        ),
    .ifu_mst_rdata      (ifu_mst_rdata      ),     
    .ifu_mst_rresp      (ifu_mst_rresp      ),
    .ifu_mst_rlast      (ifu_mst_rlast      )
);


AXI_ROM U_INST_ROM (
    .clk                (clk                ),
    .rst_n              (rst_n              ),   

    .axi_slv_arvalid    (ifu_mst_arvalid    ),     
    .axi_slv_arready    (ifu_mst_arready    ),   
    .axi_slv_arid       (ifu_mst_arid       ),  
    .axi_slv_araddr     (ifu_mst_araddr     ),  
    .axi_slv_arlen      (ifu_mst_arlen      ),    
    .axi_slv_arsize     (ifu_mst_arsize     ),   
    .axi_slv_arburst    (ifu_mst_arburst    ),  
    .axi_slv_arlock     (ifu_mst_arlock     ),   
    .axi_slv_arcache    (ifu_mst_arcache    ),  
    .axi_slv_arprot     (ifu_mst_arprot     ),   
    .axi_slv_arqos      (ifu_mst_arqos      ),    
    .axi_slv_arregion   (ifu_mst_arregion   ), 

    .axi_slv_rvalid     (ifu_mst_rvalid     ),   
    .axi_slv_rready     (ifu_mst_rready     ),    
    .axi_slv_rid        (ifu_mst_rid        ),      
    .axi_slv_rdata      (ifu_mst_rdata      ),    
    .axi_slv_rresp      (ifu_mst_rresp      ),    
    .axi_slv_rlast      (ifu_mst_rlast      )    
);

endmodule
