// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : axi_mem.v
// Author        : Rongye
// Created On    : 2024-07-23 05:57
// Last Modified : 2024-08-01 07:46
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module AXI_ROM(
// Global 
    input wire                                 clk,
    input wire                                 rst_n,
// AR channel
    input  wire                                axi_slv_arvalid,
    output wire                                axi_slv_arready,
    input  wire [`AXI_ID_WIDTH     -1:0]       axi_slv_arid,
    input  wire [`AXI_ADDR_WIDTH   -1:0]       axi_slv_araddr,
    input  wire [`AXI_LEN_WIDTH    -1:0]       axi_slv_arlen,
    input  wire [`AXI_SIZE_WIDTH   -1:0]       axi_slv_arsize,
    input  wire [`AXI_BURST_WIDTH  -1:0]       axi_slv_arburst,
    input  wire [`AXI_LOCK_WIDTH   -1:0]       axi_slv_arlock,
    input  wire [`AXI_CACHE_WIDTH  -1:0]       axi_slv_arcache,
    input  wire [`AXI_PROT_WIDTH   -1:0]       axi_slv_arprot,
    input  wire [`AXI_QOS_WIDTH    -1:0]       axi_slv_arqos,
    input  wire [`AXI_REGION_WIDTH -1:0]       axi_slv_arregion,
// R channel
    output wire                                axi_slv_rvalid,
    input  wire                                axi_slv_rready,
    output wire [`AXI_ID_WIDTH     -1:0]       axi_slv_rid,
    output wire [`AXI_DATA_WIDTH   -1:0]       axi_slv_rdata,
    output wire [`AXI_RESP_WIDTH   -1:0]       axi_slv_rresp,
    output wire                                axi_slv_rlast
);

localparam integer MEM_ADDR_DEEP  = 2048;
localparam integer MEM_ADDR_WIDTH = $clog2(MEM_ADDR_DEEP);
localparam integer ADDR_LSB       = 2;

// AXI READ CTRL INST
wire                        rd_req_en; 
wire                        rd_result_en; 

wire [`AXI_ADDR_WIDTH -1:0] rd_base_addr;
wire [`AXI_DATA_WIDTH -1:0] rd_result_data;


AXI_SLV_RD_CTRL #(
    .AXI_RD_OST_NUM     (8                  )
)U_AXI_SLV_RD_CTRL(
    .clk                (clk                ),
    .rst_n              (rst_n              ), 
                        
    .rd_req_en          (rd_req_en          ), 
    .rd_base_addr       (rd_base_addr       ),
    .rd_result_en       (rd_result_en       ), 
    .rd_result_data     (rd_result_data     ),
                        
    .axi_slv_arvalid    (axi_slv_arvalid    ),
    .axi_slv_arready    (axi_slv_arready    ),
    .axi_slv_arid       (axi_slv_arid       ),
    .axi_slv_araddr     (axi_slv_araddr     ),
    .axi_slv_arlen      (axi_slv_arlen      ),
    .axi_slv_arsize     (axi_slv_arsize     ),
    .axi_slv_arburst    (axi_slv_arburst    ),
    .axi_slv_arlock     (axi_slv_arlock     ),
    .axi_slv_arcache    (axi_slv_arcache    ),
    .axi_slv_arprot     (axi_slv_arprot     ),
    .axi_slv_arqos      (axi_slv_arqos      ),
    .axi_slv_arregion   (axi_slv_arregion   ),
                        
    .axi_slv_rvalid     (axi_slv_rvalid     ),
    .axi_slv_rready     (axi_slv_rready     ),
    .axi_slv_rid        (axi_slv_rid        ),
    .axi_slv_rdata      (axi_slv_rdata      ),     
    .axi_slv_rresp      (axi_slv_rresp      ),
    .axi_slv_rlast      (axi_slv_rlast      )
);



// implement Block ROM(s) read only
reg [`AXI_DATA_WIDTH-1:0] mem_data [0:MEM_ADDR_DEEP-1];
wire [`AXI_DATA_WIDTH-1:0] mem_data_out;
reg mem_data_out_en;

wire mem_rden = rd_req_en;
wire [MEM_ADDR_WIDTH-1:0] mem_address = mem_rden ? rd_base_addr[ADDR_LSB+:MEM_ADDR_WIDTH]
                                                 : {MEM_ADDR_WIDTH{1'b0}};

assign mem_data_out = mem_rden ? mem_data[mem_address] : {`AXI_DATA_WIDTH{1'b0}};

assign rd_result_data = mem_data_out;
assign rd_result_en   = mem_rden;

endmodule
