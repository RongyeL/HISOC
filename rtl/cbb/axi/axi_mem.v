// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : axi_mem.v
// Author        : Rongye
// Created On    : 2024-07-23 05:57
// Last Modified : 2024-07-25 08:40
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module AXI_MEM(
// Global 
    input wire                                 clk,
    input wire                                 rst_n,
// AR channel
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
    input  wire                                axi_slv_arvalid,
    output wire                                axi_slv_arready,
// R channel
    output wire [`AXI_ID_WIDTH     -1:0]       axi_slv_rid,
    output wire [`AXI_DATA_WIDTH   -1:0]       axi_slv_rdata,
    output wire [`AXI_RESP_WIDTH   -1:0]       axi_slv_rresp,
    output wire                                axi_slv_rlast,
    output wire                                axi_slv_rvalid,
    input  wire                                axi_slv_rready
);

localparam integer MEM_ADDR_DEEP  = 2048;
localparam integer MEM_ADDR_WIDTH = $clog2(MEM_ADDR_DEEP);
localparam integer ADDR_LSB       = 2;

// AXI READ CTRL INST
wire                        rd_req_en; 
wire                        rd_result_en; 

wire [`AXI_ADDR_WIDTH -1:0] rd_base_addr;
wire [`AXI_DATA_WIDTH -1:0] rd_result_data;


AXI_SLV_CTRL_RD U_AXI_SLV_CTRL_RD(
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



// implement Block RAM(s)
reg [`AXI_DATA_WIDTH-1:0] mem_data [0:MEM_ADDR_DEEP-1];
reg [`AXI_DATA_WIDTH-1:0] mem_data_out;
reg mem_data_out_en;

wire mem_rden = rd_req_en;
wire [MEM_ADDR_WIDTH-1:0] mem_address = (mem_rden ? rd_base_addr[ADDR_LSB+:MEM_ADDR_WIDTH]
                                                  : {MEM_ADDR_WIDTH{1'b0}});
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_data_out    <= {`AXI_DATA_WIDTH{1'b0}};
        mem_data_out_en <= 1'b0;
    end
    else if (mem_rden) begin
        mem_data_out    <= mem_data[mem_address];
        mem_data_out_en <= 1'b1;
    end
    else begin
        mem_data_out    <= {`AXI_DATA_WIDTH{1'b0}};
        mem_data_out_en <= 1'b0;
    end
end
assign rd_result_data = mem_data_out;
assign rd_result_en   = mem_data_out_en;

endmodule
