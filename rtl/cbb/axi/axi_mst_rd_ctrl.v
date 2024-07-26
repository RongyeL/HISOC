// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : axi_mst_ctrl_rd.v
// Author        : Rongye
// Created On    : 2024-07-25 05:24
// Last Modified : 2024-07-26 09:36
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module AXI_MST_RD_CTRL #(

)(
    input  wire                              clk,
    input  wire                              rst_n, 

    input  wire                              rd_req_en, 
    input  wire [`AXI_ID_WIDTH         -1:0] rd_id,
    input  wire [`AXI_ADDR_WIDTH       -1:0] rd_base_addr,
    input  wire [`AXI_LEN_WIDTH        -1:0] rd_len,
    input  wire [`AXI_SIZE_WIDTH       -1:0] rd_size,
    input  wire [`AXI_BURST_WIDTH      -1:0] rd_burst,
    input  wire [`AXI_LOCK_WIDTH       -1:0] rd_lock,
    input  wire [`AXI_CACHE_WIDTH      -1:0] rd_cache,
    input  wire [`AXI_PROT_WIDTH       -1:0] rd_prot,
    input  wire [`AXI_QOS_WIDTH        -1:0] rd_qos,
    input  wire [`AXI_REGION_WIDTH     -1:0] rd_region,

    output wire                              rd_result_en, 
    output wire [`AXI_DATA_WIDTH       -1:0] rd_result_data,

// AR channel
    output wire                              axi_mst_arvalid,
    input  wire                              axi_mst_arready,
    output wire [`AXI_ID_WIDTH         -1:0] axi_mst_arid,
    output wire [`AXI_ADDR_WIDTH       -1:0] axi_mst_araddr,
    output wire [`AXI_LEN_WIDTH        -1:0] axi_mst_arlen,
    output wire [`AXI_SIZE_WIDTH       -1:0] axi_mst_arsize,
    output wire [`AXI_BURST_WIDTH      -1:0] axi_mst_arburst,
    output wire [`AXI_LOCK_WIDTH       -1:0] axi_mst_arlock,
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
    input  wire                              axi_mst_rlast
);
localparam DLY         = 0.1;
//--------------------------------------------------------------------------------
// inner signal
//--------------------------------------------------------------------------------
reg  [`AXI_LEN_WIDTH         :0] read_index; // read beat count in a burst
reg                              burst_read_active;

reg                              axi_mst_arvalid_r;

reg  [`AXI_ID_WIDTH        -1:0] axi_mst_arid_r;
reg  [`AXI_ADDR_WIDTH      -1:0] axi_mst_araddr_r;
reg  [`AXI_LEN_WIDTH       -1:0] axi_mst_arlen_r;
reg  [`AXI_SIZE_WIDTH      -1:0] axi_mst_arsize_r;
reg  [`AXI_BURST_WIDTH     -1:0] axi_mst_arburst_r;
reg  [`AXI_LOCK_WIDTH      -1:0] axi_mst_arlock_r;
reg  [`AXI_CACHE_WIDTH     -1:0] axi_mst_arcache_r;
reg  [`AXI_PROT_WIDTH      -1:0] axi_mst_arprot_r;
reg  [`AXI_QOS_WIDTH       -1:0] axi_mst_arqos_r;
reg  [`AXI_REGION_WIDTH    -1:0] axi_mst_arregion_r;

reg  [`AXI_RESP_WIDTH      -1:0] axi_mst_rresp_r;

//--------------------------------------------------------------------------------
// main 
//--------------------------------------------------------------------------------
// register ar payload
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_mst_arid_r    <= #DLY {`AXI_ID_WIDTH{1'b0}};
        axi_mst_arlen_r   <= #DLY {`AXI_LEN_WIDTH{1'b0}};
        axi_mst_arsize_r  <= #DLY {`AXI_SIZE_WIDTH{1'b0}};
        axi_mst_arburst_r <= #DLY {`AXI_BURST_WIDTH{1'b0}};
        axi_mst_arlock_r  <= #DLY {`AXI_LOCK_WIDTH{1'b0}};
        axi_mst_arcache_r <= #DLY {`AXI_CACHE_WIDTH{1'b0}};
        axi_mst_arprot_r  <= #DLY {`AXI_PROT_WIDTH{1'b0}};
        axi_mst_arqos_r   <= #DLY {`AXI_QOS_WIDTH{1'b0}};
        axi_mst_arregion_r<= #DLY {`AXI_REGION_WIDTH{1'b0}};
    end
    else if (rd_req_en) begin
        axi_mst_arid_r    <= #DLY rd_id;   
        axi_mst_arlen_r   <= #DLY rd_len;   // len=0
        axi_mst_arsize_r  <= #DLY rd_size; 
        axi_mst_arburst_r <= #DLY rd_burst;
        axi_mst_arlock_r  <= #DLY rd_lock; 
        axi_mst_arcache_r <= #DLY rd_cache;
        axi_mst_arprot_r  <= #DLY rd_prot; 
        axi_mst_arqos_r   <= #DLY rd_qos; 
        axi_mst_arregion_r<= #DLY rd_region; 
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_mst_araddr_r  <= #DLY {`AXI_ADDR_WIDTH{1'b0}};
    end
    else if (rd_req_en) begin
        axi_mst_araddr_r  <= rd_base_addr;
    end
end

assign axi_mst_arid    = axi_mst_arid_r    ;
assign axi_mst_arlen   = axi_mst_arlen_r   ;
assign axi_mst_arsize  = axi_mst_arsize_r  ;
assign axi_mst_arburst = axi_mst_arburst_r ;
assign axi_mst_arlock  = axi_mst_arlock_r  ;
assign axi_mst_arcache = axi_mst_arcache_r ;
assign axi_mst_arprot  = axi_mst_arprot_r  ;
assign axi_mst_arqos   = axi_mst_arqos_r   ;
assign axi_mst_arregion= axi_mst_arregion_r;
assign axi_mst_araddr  = axi_mst_araddr_r;

reg                       read_resp_error_r;
//----------------------------
//Read Address Channel
//----------------------------
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_mst_arvalid_r  <= #DLY 1'b0;
    end
    else if (rd_req_en) begin
        axi_mst_arvalid_r  <= #DLY 1'b1;
    end
    else if (axi_mst_arvalid && axi_mst_arready) begin
        axi_mst_arvalid_r  <= #DLY 1'b0;
    end
end
assign axi_mst_arvalid = burst_read_active && axi_mst_arvalid_r; 

//--------------------------------
//Read Data (and Response) Channel
//--------------------------------
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        read_index <= 0;
    end
    else if(rd_req_en) begin
        read_index <= 0;
    end
    else if (axi_mst_rvalid && axi_mst_rready && (read_index != axi_mst_arlen_r)) begin
        read_index <= read_index + 1;
    end
end

//Flag any read response errors
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        read_resp_error_r <= 0;
    end
    else if(rd_req_en) begin
        read_resp_error_r <= 0;
    end
    else if (axi_mst_rvalid && axi_mst_rready) begin
        read_resp_error_r <= read_resp_error_r | axi_mst_rresp[1];
    end
end

// burst_read_active signal is asserted when there is a burst write transaction
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        burst_read_active <= 1'b0;
    end
    else if (rd_req_en) begin
        burst_read_active <= 1'b1;
    end
    else if (axi_mst_rvalid && axi_mst_rready && axi_mst_rlast) begin
        burst_read_active <= 1'b0;
    end
end
assign axi_mst_rready = 1'b1; // ost = 1

// Check for last read completion.
assign rd_result_en   = axi_mst_rvalid && axi_mst_rready && axi_mst_rlast;
assign rd_result_data = axi_mst_rdata;

endmodule
