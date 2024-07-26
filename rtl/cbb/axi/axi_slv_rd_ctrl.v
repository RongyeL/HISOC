// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : axi_slv_ctrl_rd.v
// Author        : Rongye
// Created On    : 2024-07-25 05:24
// Last Modified : 2024-07-26 08:32
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module AXI_SLV_RD_CTRL #(

)(
    input  wire                              clk,
    input  wire                              rst_n, 

    output wire                              rd_req_en, 
    output wire [`AXI_ADDR_WIDTH       -1:0] rd_base_addr,
    input  wire                              rd_result_en, 
    input  wire [`AXI_DATA_WIDTH       -1:0] rd_result_data,

// AR channel
    input  wire                              axi_slv_arvalid,
    output wire                              axi_slv_arready,
    input  wire [`AXI_ID_WIDTH         -1:0] axi_slv_arid,
    input  wire [`AXI_ADDR_WIDTH       -1:0] axi_slv_araddr,
    input  wire [`AXI_LEN_WIDTH        -1:0] axi_slv_arlen,
    input  wire [`AXI_SIZE_WIDTH       -1:0] axi_slv_arsize,
    input  wire [`AXI_BURST_WIDTH      -1:0] axi_slv_arburst,
    input  wire                              axi_slv_arlock,
    input  wire [`AXI_CACHE_WIDTH      -1:0] axi_slv_arcache,
    input  wire [`AXI_PROT_WIDTH       -1:0] axi_slv_arprot,
    input  wire [`AXI_QOS_WIDTH        -1:0] axi_slv_arqos,
    input  wire [`AXI_REGION_WIDTH     -1:0] axi_slv_arregion,
// R channel
    output wire                              axi_slv_rvalid,
    input  wire                              axi_slv_rready,
    output wire [`AXI_ID_WIDTH         -1:0] axi_slv_rid,
    output wire [`AXI_DATA_WIDTH       -1:0] axi_slv_rdata,
    output wire [`AXI_RESP_WIDTH       -1:0] axi_slv_rresp,
    output wire                              axi_slv_rlast
);
localparam DLY      = 0.1;
localparam ADDR_LSB = (`AXI_DATA_WIDTH/32)+ 1;
//--------------------------------------------------------------------------------
// inner signal
//--------------------------------------------------------------------------------
reg  [`AXI_LEN_WIDTH         :0] read_index;
reg                              burst_read_active; 

reg                              axi_slv_rvalid_r;

reg  [`AXI_ID_WIDTH        -1:0] axi_slv_arid_r;
reg  [`AXI_ADDR_WIDTH      -1:0] axi_slv_araddr_r;
reg  [`AXI_LEN_WIDTH       -1:0] axi_slv_arlen_r;
reg  [`AXI_SIZE_WIDTH      -1:0] axi_slv_arsize_r;
reg  [`AXI_BURST_WIDTH     -1:0] axi_slv_arburst_r;
reg  [`AXI_LOCK_WIDTH      -1:0] axi_slv_arlock_r;
reg  [`AXI_CACHE_WIDTH     -1:0] axi_slv_arcache_r;
reg  [`AXI_PROT_WIDTH      -1:0] axi_slv_arprot_r;
reg  [`AXI_QOS_WIDTH       -1:0] axi_slv_arqos_r;
reg  [`AXI_REGION_WIDTH    -1:0] axi_slv_arregion_r;

reg  [`AXI_DATA_WIDTH      -1:0] axi_slv_rdata_r;
reg  [`AXI_RESP_WIDTH      -1:0] axi_slv_rresp_r;

//--------------------------------------------------------------------------------
// main
//--------------------------------------------------------------------------------
// register ar payload
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_slv_arid_r    <= #DLY {`AXI_ID_WIDTH{1'b0}};
        axi_slv_arlen_r   <= #DLY {`AXI_LEN_WIDTH{1'b0}};
        axi_slv_arsize_r  <= #DLY {`AXI_SIZE_WIDTH{1'b0}};
        axi_slv_arburst_r <= #DLY {`AXI_BURST_WIDTH{1'b0}};
        axi_slv_arlock_r  <= #DLY {`AXI_LOCK_WIDTH{1'b0}};
        axi_slv_arcache_r <= #DLY {`AXI_CACHE_WIDTH{1'b0}};
        axi_slv_arprot_r  <= #DLY {`AXI_PROT_WIDTH{1'b0}};
        axi_slv_arqos_r   <= #DLY {`AXI_QOS_WIDTH{1'b0}};
        axi_slv_arregion_r<= #DLY {`AXI_REGION_WIDTH{1'b0}};
    end
    else if (axi_slv_arvalid && axi_slv_arready) begin
        axi_slv_arid_r    <= #DLY axi_slv_arid;   
        axi_slv_arlen_r   <= #DLY axi_slv_arlen;  
        axi_slv_arsize_r  <= #DLY axi_slv_arsize; 
        axi_slv_arburst_r <= #DLY axi_slv_arburst;
        axi_slv_arlock_r  <= #DLY axi_slv_arlock; 
        axi_slv_arcache_r <= #DLY axi_slv_arcache;
        axi_slv_arprot_r  <= #DLY axi_slv_arprot; 
        axi_slv_arqos_r   <= #DLY axi_slv_arqos; 
        axi_slv_arregion_r<= #DLY axi_slv_arregion; 
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        burst_read_active <= #DLY 1'b0;
    end
    else if (axi_slv_arvalid && axi_slv_arready && ~burst_read_active) begin
        burst_read_active <= #DLY 1'b1;
    end
    else if (axi_slv_rvalid && axi_slv_rready && axi_slv_rlast) begin
        burst_read_active <= #DLY 1'b0;
    end
end
assign axi_slv_arready = ~burst_read_active; // ost = 1

assign rd_req_en = burst_read_active && (read_index <= axi_slv_arlen_r); 

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        read_index <= #DLY {(`AXI_LEN_WIDTH+1){1'b0}};
    end
    else if (axi_slv_arvalid && axi_slv_arready && ~burst_read_active) begin
        read_index <= #DLY {(`AXI_LEN_WIDTH+1){1'b0}};
    end
    else if((read_index <= axi_slv_arlen_r) && rd_req_en) begin
        read_index <= #DLY read_index + `AXI_LEN_WIDTH'b1;
    end
end

wire [`AXI_ADDR_WIDTH-1:0] ar_wrap_size = (`AXI_DATA_WIDTH/8 * (axi_slv_arlen_r));
wire                       ar_wrap_en   = ((axi_slv_araddr_r & ar_wrap_size) == ar_wrap_size) ? 1'b1: 1'b0;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_slv_araddr_r  <= #DLY {`AXI_ADDR_WIDTH{1'b0}};
    end
    else if (axi_slv_arvalid && axi_slv_arready && ~burst_read_active) begin
            axi_slv_araddr_r  <= axi_slv_araddr;
    end
    else if((read_index <= axi_slv_arlen_r) && axi_slv_rvalid && axi_slv_rready) begin
        case (axi_slv_arburst_r)
            2'b00: // fixed burst
                begin
                    axi_slv_araddr_r <= axi_slv_araddr;
                end
            2'b01: //incremental burst
                begin
                    axi_slv_araddr_r[`AXI_ADDR_WIDTH-1:ADDR_LSB] <= axi_slv_araddr[`AXI_ADDR_WIDTH-1:ADDR_LSB]+1;
                    axi_slv_araddr_r[ADDR_LSB-1:0] <= {ADDR_LSB{1'b0}};
                end
            2'b10: //Wrapping burst
                begin
                if (ar_wrap_en) begin
                    axi_slv_araddr_r <= (axi_slv_araddr_r - ar_wrap_size);
                end
                else begin
                    axi_slv_araddr_r[`AXI_ADDR_WIDTH-1:ADDR_LSB] <= axi_slv_araddr_r[`AXI_ADDR_WIDTH-1:ADDR_LSB]+1;
                    axi_slv_araddr_r[ADDR_LSB-1:0] <= {ADDR_LSB{1'b0}};
                end
                end
            default: 
                begin
                    axi_slv_araddr_r[`AXI_ADDR_WIDTH-1:ADDR_LSB] <= axi_slv_araddr[`AXI_ADDR_WIDTH-1:ADDR_LSB]+1;
                    axi_slv_araddr_r[ADDR_LSB-1:0] <= {ADDR_LSB{1'b0}};
                end
        endcase
    end
end
assign rd_base_addr = axi_slv_araddr_r;

// r channel
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_slv_rresp_r  <= #DLY {`AXI_RESP_WIDTH{1'b0}};
    end
    else if (axi_slv_arvalid && axi_slv_arready) begin
        axi_slv_rresp_r  <= #DLY `AXI_RESP_WIDTH'b0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_slv_rvalid_r  <= #DLY 1'b0;
    end
    else if (rd_result_en) begin
        axi_slv_rvalid_r  <= #DLY 1'b1;
    end
    else if (axi_slv_rvalid && axi_slv_rready) begin
        axi_slv_rvalid_r  <= #DLY 1'b0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_slv_rdata_r  <= #DLY {`AXI_DATA_WIDTH{1'b0}};
    end
    else if (rd_result_en) begin
        axi_slv_rdata_r  <= #DLY rd_result_data;
    end
end

assign axi_slv_rvalid = burst_read_active && axi_slv_rvalid_r; 
assign axi_slv_rlast  = burst_read_active && axi_slv_rvalid && axi_slv_rready && (read_index == axi_slv_arlen_r+1);
assign axi_slv_rdata  = axi_slv_rdata_r; 

endmodule
