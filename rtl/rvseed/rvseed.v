// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : rvseed.v
// Author        : Rongye
// Created On    : 2022-03-25 03:42
// Last Modified : 2024-07-24 09:22
// ---------------------------------------------------------------------------------
// Description   : rvseed cpu top module.
//                 
//
// -FHDR----------------------------------------------------------------------------
module RVSEED (
// global 
    input  wire                                  clk,
    input  wire                                  rst_n,             // 
    input  wire                                  enable,             // 
// AW channel
    output wire [`AXI_ID_WIDTH        -1:0]      ifu_axi_awid,     // 
    output wire [`AXI_ADDR_WIDTH      -1:0]      ifu_axi_awaddr,   // 
    output wire [`AXI_BURST_LEN_WIDTH  -1:0]      ifu_axi_awlen,    // 
    output wire [`AXI_BURST_SIZE_WIDTH -1:0]      ifu_axi_awsize,   // 
    output wire [`AXI_BURST_TYPE_WIDTH -1:0]      ifu_axi_awburst,  // 
    output wire                                   ifu_axi_awlock,   // 
    output wire [`AXI_CACHE_WIDTH      -1:0]      ifu_axi_awcache,  // 
    output wire [`AXI_PROT_WIDTH       -1:0]      ifu_axi_awprot,   // 
    output wire [`AXI_QOS_WIDTH        -1:0]      ifu_axi_awqos,    // 
    output wire [`AXI_REGION_WIDTH     -1:0]      ifu_axi_awregion, // 
    output wire                                   ifu_axi_awvalid,  // 
    input  wire                                   ifu_axi_awready,  // 
// W channel
    output wire [`AXI_DATA_WIDTH      -1 : 0]    ifu_axi_wdata,    // 
    output wire [(`AXI_DATA_WIDTH/8)  -1 : 0]    ifu_axi_wstrb,    // 
    output wire                                   ifu_axi_wlast,    //
    output wire                                   ifu_axi_wvalid,   //
    input  wire                                   ifu_axi_wready,   //
// B channel
    input  wire [`AXI_ID_WIDTH-1 : 0]             ifu_axi_bid,      //
    input  wire [`AXI_RESP_WIDTH-1 : 0]            ifu_axi_bresp,    //
    input  wire                                    ifu_axi_bvalid,   //
    output wire                                  ifu_axi_bready,    // 
// AR channel 
    output wire [`AXI_ID_WIDTH-1 : 0]            ifu_axi_arid,     // 
    output wire [`AXI_ADDR_WIDTH-1 : 0]          ifu_axi_araddr,   // 
    output wire [`AXI_BURST_LEN_WIDTH-1 : 0]      ifu_axi_arlen,    // 
    output wire [`AXI_BURST_SIZE_WIDTH-1 : 0]     ifu_axi_arsize,   // 
    output wire [`AXI_BURST_TYPE_WIDTH-1 : 0]     ifu_axi_arburst,  // 
    output wire                                   ifu_axi_arlock,   // 
    output wire [`AXI_CACHE_WIDTH-1 : 0]          ifu_axi_arcache,  // 
    output wire [`AXI_PROT_WIDTH-1 : 0]           ifu_axi_arprot,   // 
    output wire [`AXI_QOS_WIDTH-1 : 0]            ifu_axi_arqos,    // 
    output wire [`AXI_REGION_WIDTH-1 : 0]         ifu_axi_arregion, // 
    output wire                                   ifu_axi_arvalid,  // 
    input  wire                                   ifu_axi_arready,  // 
// R channel
    input  wire [`AXI_ID_WIDTH-1 : 0]             ifu_axi_rid,      // 
    input  wire [`AXI_DATA_WIDTH-1 : 0]           ifu_axi_rdata,    // 
    input  wire [`AXI_RESP_WIDTH-1 : 0]            ifu_axi_rresp,    // 
    input  wire                                    ifu_axi_rlast,    // 
    input  wire                                    ifu_axi_rvalid,   // 
    output wire                                    ifu_axi_rready    // 

);

IFU #(
    .INST_MEM_BASE_ADDR (32'h40000000),
    .BURST_LEN          (1           )
) U_IFU (
// global 
    .clk                         (clk                  ),
    .rst_n                       (rst_n                ),   
    .enable                      (enable               ),   
// AW channel
    .ifu_axi_awid                (ifu_axi_awid         ),   
    .ifu_axi_awaddr              (ifu_axi_awaddr       ),   
    .ifu_axi_awlen               (ifu_axi_awlen        ),   
    .ifu_axi_awsize              (ifu_axi_awsize       ),  
    .ifu_axi_awburst             (ifu_axi_awburst      ),  
    .ifu_axi_awlock              (ifu_axi_awlock       ),   
    .ifu_axi_awcache             (ifu_axi_awcache      ),  
    .ifu_axi_awprot              (ifu_axi_awprot       ),   
    .ifu_axi_awqos               (ifu_axi_awqos        ),    
    .ifu_axi_awregion            (ifu_axi_awregion     ), 
    .ifu_axi_awvalid             (ifu_axi_awvalid      ),  
    .ifu_axi_awready             (ifu_axi_awready      ),  
// W channel
    .ifu_axi_wdata               (ifu_axi_wdata        ),    
    .ifu_axi_wstrb               (ifu_axi_wstrb        ),    
    .ifu_axi_wlast               (ifu_axi_wlast        ),    
    .ifu_axi_wvalid              (ifu_axi_wvalid       ),   
    .ifu_axi_wready              (ifu_axi_wready       ),   
// B channel
    .ifu_axi_bid                 (ifu_axi_bid          ),      
    .ifu_axi_bresp               (ifu_axi_bresp        ),    
    .ifu_axi_bvalid              (ifu_axi_bvalid       ),   
    .ifu_axi_bready              (ifu_axi_bready       ),   
// AR channel 
    .ifu_axi_arid                (ifu_axi_arid         ),     
    .ifu_axi_araddr              (ifu_axi_araddr       ),   
    .ifu_axi_arlen               (ifu_axi_arlen        ),    
    .ifu_axi_arsize              (ifu_axi_arsize       ),   
    .ifu_axi_arburst             (ifu_axi_arburst      ),  
    .ifu_axi_arlock              (ifu_axi_arlock       ),   
    .ifu_axi_arcache             (ifu_axi_arcache      ),  
    .ifu_axi_arprot              (ifu_axi_arprot       ),   
    .ifu_axi_arqos               (ifu_axi_arqos        ),    
    .ifu_axi_arregion            (ifu_axi_arregion     ), 
    .ifu_axi_arvalid             (ifu_axi_arvalid      ),  
    .ifu_axi_arready             (ifu_axi_arready      ),  
// R channel
    .ifu_axi_rid                 (ifu_axi_rid          ),      
    .ifu_axi_rdata               (ifu_axi_rdata        ),    
    .ifu_axi_rresp               (ifu_axi_rresp        ),    
    .ifu_axi_rlast               (ifu_axi_rlast        ),    
    .ifu_axi_rvalid              (ifu_axi_rvalid       ),   
    .ifu_axi_rready              (ifu_axi_rready       )    

);

AXI_MEM U_INST_MEM (
// global 
    .clk                         (clk                  ),
    .rst_n                       (rst_n                ),   
// AW channel
    .mem_axi_awid                (ifu_axi_awid         ),   
    .mem_axi_awaddr              (ifu_axi_awaddr       ),   
    .mem_axi_awlen               (ifu_axi_awlen        ),   
    .mem_axi_awsize              (ifu_axi_awsize       ),  
    .mem_axi_awburst             (ifu_axi_awburst      ),  
    .mem_axi_awlock              (ifu_axi_awlock       ),   
    .mem_axi_awcache             (ifu_axi_awcache      ),  
    .mem_axi_awprot              (ifu_axi_awprot       ),   
    .mem_axi_awqos               (ifu_axi_awqos        ),    
    .mem_axi_awregion            (ifu_axi_awregion     ), 
    .mem_axi_awvalid             (ifu_axi_awvalid      ),  
    .mem_axi_awready             (ifu_axi_awready      ),  
// W channel
    .mem_axi_wdata               (ifu_axi_wdata        ),    
    .mem_axi_wstrb               (ifu_axi_wstrb        ),    
    .mem_axi_wlast               (ifu_axi_wlast        ),    
    .mem_axi_wvalid              (ifu_axi_wvalid       ),   
    .mem_axi_wready              (ifu_axi_wready       ),   
// B channel
    .mem_axi_bid                 (ifu_axi_bid          ),      
    .mem_axi_bresp               (ifu_axi_bresp        ),    
    .mem_axi_bvalid              (ifu_axi_bvalid       ),   
    .mem_axi_bready              (ifu_axi_bready       ),   
// AR channel 
    .mem_axi_arid                (ifu_axi_arid         ),     
    .mem_axi_araddr              (ifu_axi_araddr       ),   
    .mem_axi_arlen               (ifu_axi_arlen        ),    
    .mem_axi_arsize              (ifu_axi_arsize       ),   
    .mem_axi_arburst             (ifu_axi_arburst      ),  
    .mem_axi_arlock              (ifu_axi_arlock       ),   
    .mem_axi_arcache             (ifu_axi_arcache      ),  
    .mem_axi_arprot              (ifu_axi_arprot       ),   
    .mem_axi_arqos               (ifu_axi_arqos        ),    
    .mem_axi_arregion            (ifu_axi_arregion     ), 
    .mem_axi_arvalid             (ifu_axi_arvalid      ),  
    .mem_axi_arready             (ifu_axi_arready      ),  
// R channel
    .mem_axi_rid                 (ifu_axi_rid          ),      
    .mem_axi_rdata               (ifu_axi_rdata        ),    
    .mem_axi_rresp               (ifu_axi_rresp        ),    
    .mem_axi_rlast               (ifu_axi_rlast        ),    
    .mem_axi_rvalid              (ifu_axi_rvalid       ),   
    .mem_axi_rready              (ifu_axi_rready       )    

);



endmodule
