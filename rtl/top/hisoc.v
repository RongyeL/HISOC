// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : hisoc.v
// Author        : Rongye
// Created On    : 2024-07-26 09:23
// Last Modified : 2024-08-05 05:24
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

wire                          ifu_arvalid;
wire                          ifu_arready;
wire [`AXI_ID_WIDTH     -1:0] ifu_arid;
wire [`AXI_ADDR_WIDTH   -1:0] ifu_araddr;
wire [`AXI_LEN_WIDTH    -1:0] ifu_arlen;
wire [`AXI_SIZE_WIDTH   -1:0] ifu_arsize;
wire [`AXI_BURST_WIDTH  -1:0] ifu_arburst;
wire                          ifu_arlock;
wire [`AXI_CACHE_WIDTH  -1:0] ifu_arcache;
wire [`AXI_PROT_WIDTH   -1:0] ifu_arprot;
wire [`AXI_QOS_WIDTH    -1:0] ifu_arqos;
wire [`AXI_REGION_WIDTH -1:0] ifu_arregion;

wire                          ifu_rvalid;
wire                          ifu_rready;
wire [`AXI_ID_WIDTH     -1:0] ifu_rid;
wire [`AXI_DATA_WIDTH   -1:0] ifu_rdata;
wire [`AXI_RESP_WIDTH   -1:0] ifu_rresp;
wire                          ifu_rlast;

RVSEED U_RVSEED (
    .clk                (clk                ),
    .rst_n              (rst_n              ),   
    .enable             (enable             ),   

    .ifu_arvalid    (ifu_arvalid    ),
    .ifu_arready    (ifu_arready    ),
    .ifu_arid       (ifu_arid       ),
    .ifu_araddr     (ifu_araddr     ),
    .ifu_arlen      (ifu_arlen      ),
    .ifu_arsize     (ifu_arsize     ),
    .ifu_arburst    (ifu_arburst    ),
    .ifu_arlock     (ifu_arlock     ),
    .ifu_arcache    (ifu_arcache    ),
    .ifu_arprot     (ifu_arprot     ),
    .ifu_arqos      (ifu_arqos      ),
    .ifu_arregion   (ifu_arregion   ),

    .ifu_rvalid     (ifu_rvalid     ),
    .ifu_rready     (ifu_rready     ),
    .ifu_rid        (ifu_rid        ),
    .ifu_rdata      (ifu_rdata      ),     
    .ifu_rresp      (ifu_rresp      ),
    .ifu_rlast      (ifu_rlast      )
);


AXI_ROM U_INST_ROM (
    .clk                (clk                ),
    .rst_n              (rst_n              ),   

    .axi_slv_arvalid    (ifu_arvalid    ),     
    .axi_slv_arready    (ifu_arready    ),   
    .axi_slv_arid       (ifu_arid       ),  
    .axi_slv_araddr     (ifu_araddr     ),  
    .axi_slv_arlen      (ifu_arlen      ),    
    .axi_slv_arsize     (ifu_arsize     ),   
    .axi_slv_arburst    (ifu_arburst    ),  
    .axi_slv_arlock     (ifu_arlock     ),   
    .axi_slv_arcache    (ifu_arcache    ),  
    .axi_slv_arprot     (ifu_arprot     ),   
    .axi_slv_arqos      (ifu_arqos      ),    
    .axi_slv_arregion   (ifu_arregion   ), 

    .axi_slv_rvalid     (ifu_rvalid     ),   
    .axi_slv_rready     (ifu_rready     ),    
    .axi_slv_rid        (ifu_rid        ),      
    .axi_slv_rdata      (ifu_rdata      ),    
    .axi_slv_rresp      (ifu_rresp      ),    
    .axi_slv_rlast      (ifu_rlast      )    
);

endmodule
