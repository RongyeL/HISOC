// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : hisoc.v
// Author        : Rongye
// Created On    : 2024-07-26 09:23
// Last Modified : 2024-07-26 09:38
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module HISOC (
// global 
    input  wire                   clk,
    input  wire                   rst_n,             // 
    input  wire                   enable             // 
);

wire                          rvseed_mst_arvalid;
wire                          rvseed_mst_arready;
wire [`AXI_ID_WIDTH     -1:0] rvseed_mst_arid;
wire [`AXI_ADDR_WIDTH   -1:0] rvseed_mst_araddr;
wire [`AXI_LEN_WIDTH    -1:0] rvseed_mst_arlen;
wire [`AXI_SIZE_WIDTH   -1:0] rvseed_mst_arsize;
wire [`AXI_BURST_WIDTH  -1:0] rvseed_mst_arburst;
wire                          rvseed_mst_arlock;
wire [`AXI_CACHE_WIDTH  -1:0] rvseed_mst_arcache;
wire [`AXI_PROT_WIDTH   -1:0] rvseed_mst_arprot;
wire [`AXI_QOS_WIDTH    -1:0] rvseed_mst_arqos;
wire [`AXI_REGION_WIDTH -1:0] rvseed_mst_arregion;

wire                          rvseed_mst_rvalid;
wire                          rvseed_mst_rready;
wire [`AXI_ID_WIDTH     -1:0] rvseed_mst_rid;
wire [`AXI_DATA_WIDTH   -1:0] rvseed_mst_rdata;
wire [`AXI_RESP_WIDTH   -1:0] rvseed_mst_rresp;
wire                          rvseed_mst_rlast;

RVSEED U_RVSEED (
// global 
    .clk                (clk                   ),
    .rst_n              (rst_n                 ),   
    .enable             (enable                ),   

    .rvseed_mst_arvalid (rvseed_mst_arvalid    ),
    .rvseed_mst_arready (rvseed_mst_arready    ),
    .rvseed_mst_arid    (rvseed_mst_arid       ),
    .rvseed_mst_araddr  (rvseed_mst_araddr     ),
    .rvseed_mst_arlen   (rvseed_mst_arlen      ),
    .rvseed_mst_arsize  (rvseed_mst_arsize     ),
    .rvseed_mst_arburst (rvseed_mst_arburst    ),
    .rvseed_mst_arlock  (rvseed_mst_arlock     ),
    .rvseed_mst_arcache (rvseed_mst_arcache    ),
    .rvseed_mst_arprot  (rvseed_mst_arprot     ),
    .rvseed_mst_arqos   (rvseed_mst_arqos      ),
    .rvseed_mst_arregion(rvseed_mst_arregion   ),

    .rvseed_mst_rvalid  (rvseed_mst_rvalid     ),
    .rvseed_mst_rready  (rvseed_mst_rready     ),
    .rvseed_mst_rid     (rvseed_mst_rid        ),
    .rvseed_mst_rdata   (rvseed_mst_rdata      ),     
    .rvseed_mst_rresp   (rvseed_mst_rresp      ),
    .rvseed_mst_rlast   (rvseed_mst_rlast      )
);


AXI_MEM U_INST_MEM (
// global 
    .clk                (clk                   ),
    .rst_n              (rst_n                 ),   
// AR channel 
    .axi_slv_arvalid    (rvseed_mst_arvalid    ),     
    .axi_slv_arready    (rvseed_mst_arready    ),   
    .axi_slv_arid       (rvseed_mst_arid       ),  
    .axi_slv_araddr     (rvseed_mst_araddr     ),  
    .axi_slv_arlen      (rvseed_mst_arlen      ),    
    .axi_slv_arsize     (rvseed_mst_arsize     ),   
    .axi_slv_arburst    (rvseed_mst_arburst    ),  
    .axi_slv_arlock     (rvseed_mst_arlock     ),   
    .axi_slv_arcache    (rvseed_mst_arcache    ),  
    .axi_slv_arprot     (rvseed_mst_arprot     ),   
    .axi_slv_arqos      (rvseed_mst_arqos      ),    
    .axi_slv_arregion   (rvseed_mst_arregion   ), 
// R channel            
    .axi_slv_rvalid     (rvseed_mst_rvalid     ),   
    .axi_slv_rready     (rvseed_mst_rready     ),    
    .axi_slv_rid        (rvseed_mst_rid        ),      
    .axi_slv_rdata      (rvseed_mst_rdata      ),    
    .axi_slv_rresp      (rvseed_mst_rresp      ),    
    .axi_slv_rlast      (rvseed_mst_rlast      )    
);

endmodule
