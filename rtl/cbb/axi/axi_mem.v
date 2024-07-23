// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : axi_mem.v
// Author        : Rongye
// Created On    : 2024-07-23 05:57
// Last Modified : 2024-07-23 10:01
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module AXI_MEM(
// Global 
    input                                   clk,
    input                                   rst_n,
// AW channel
    input [`AXI_ID_WIDTH       -1:0]       mem_axi_awid,
    input [`AXI_ADDR_WIDTH     -1:0]       mem_axi_awaddr,
    input [`AXI_BURST_LEN_WIDTH -1:0]       mem_axi_awlen,
    input [`AXI_BURST_SIZE_WIDTH-1:0]       mem_axi_awsize,
    input [`AXI_BURST_TYPE_WIDTH-1:0]       mem_axi_awburst,
    input                                   mem_axi_awlock,
    input [`AXI_CACHE_WIDTH     -1:0]       mem_axi_awcache,
    input [`AXI_PROT_WIDTH      -1:0]       mem_axi_awprot,
    input [`AXI_QOS_WIDTH       -1:0]       mem_axi_awqos,
    input [`AXI_REGION_WIDTH    -1:0]       mem_axi_awregion,
    input                                   mem_axi_awvalid,
    output                                  mem_axi_awready,
// W channel
    input [`AXI_DATA_WIDTH     -1:0]       mem_axi_wdata,
    input [(`AXI_DATA_WIDTH/8) -1:0]       mem_axi_wstrb,
    input                                   mem_axi_wlast,
    input                                   mem_axi_wvalid,
    output                                  mem_axi_wready,
// B channel
    output [`AXI_ID_WIDTH      -1:0]       mem_axi_bid,
    output [`AXI_RESP_WIDTH     -1:0]       mem_axi_bresp,
    output                                  mem_axi_bvalid,
    input                                   mem_axi_bready,
// AR channel
    input [`AXI_ID_WIDTH       -1:0]       mem_axi_arid,
    input [`AXI_ADDR_WIDTH     -1:0]       mem_axi_araddr,
    input [`AXI_BURST_LEN_WIDTH -1:0]       mem_axi_arlen,
    input [`AXI_BURST_SIZE_WIDTH-1:0]       mem_axi_arsize,
    input [`AXI_BURST_TYPE_WIDTH-1:0]       mem_axi_arburst,
    input                                   mem_axi_arlock,
    input [`AXI_CACHE_WIDTH     -1:0]       mem_axi_arcache,
    input [`AXI_PROT_WIDTH      -1:0]       mem_axi_arprot,
    input [`AXI_QOS_WIDTH       -1:0]       mem_axi_arqos,
    input [`AXI_REGION_WIDTH    -1:0]       mem_axi_arregion,
    input                                   mem_axi_arvalid,
    output                                  mem_axi_arready,
// R channel
    output [`AXI_ID_WIDTH      -1:0]       mem_axi_rid,
    output [`AXI_DATA_WIDTH    -1:0]       mem_axi_rdata,
    output [`AXI_RESP_WIDTH     -1:0]       mem_axi_rresp,
    output                                  mem_axi_rlast,
    output                                  mem_axi_rvalid,
    input                                   mem_axi_rready
);

reg  [`AXI_ADDR_WIDTH -1:0] 	 axi_awaddr;
reg                              axi_awready;
reg                              axi_wready;
reg  [`AXI_RESP_WIDTH  -1:0] 	 axi_bresp;
reg                              axi_bvalid;
reg  [`AXI_ADDR_WIDTH -1:0] 	 axi_araddr;
reg                              axi_arready;
reg  [`AXI_DATA_WIDTH -1:0] 	 axi_rdata;
reg  [`AXI_RESP_WIDTH  -1:0] 	 axi_rresp;
reg                              axi_rlast;
reg                              axi_rvalid;
wire                             aw_wrap_en;
wire                             ar_wrap_en;
wire [31:0]                      aw_wrap_size ;
wire [31:0]                      ar_wrap_size ;
reg                              burst_write_active;
reg                              burst_read_active;
reg  [7:0]                       write_index;
reg  [7:0]                       read_index;
reg  [`AXI_BURST_TYPE_WIDTH-1:0] axi_arburst;
reg  [`AXI_BURST_TYPE_WIDTH-1:0] axi_awburst;
reg  [`AXI_BURST_LEN_WIDTH -1:0] axi_arlen;
reg  [`AXI_BURST_LEN_WIDTH -1:0] axi_awlen;

// Determine the counter bit width by calculating log2.
function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
            bit_depth = bit_depth >> 1;
    end
endfunction

localparam integer ADDR_LSB       = (`AXI_DATA_WIDTH/32)+ 1;
localparam integer MEM_ADDR_DEEP  = 1024;
localparam integer MEM_ADDR_WIDTH = clogb2(MEM_ADDR_DEEP);
localparam integer MEM_NUM        = 1;
localparam integer MEM_BYTE_NUM   = 64; // Maximum number of bytes that can be written
assign mem_axi_awready = axi_awready;
assign mem_axi_wready  = axi_wready;
assign mem_axi_bresp   = axi_bresp;
assign mem_axi_bvalid  = axi_bvalid;
assign mem_axi_arready = axi_arready;
assign mem_axi_rdata   = axi_rdata;
assign mem_axi_rresp   = axi_rresp;
assign mem_axi_rlast   = axi_rlast;
assign mem_axi_rvalid  = axi_rvalid;
assign mem_axi_bid     = mem_axi_awid;
assign mem_axi_rid     = mem_axi_arid;

assign aw_wrap_size  = (`AXI_DATA_WIDTH/8 * (axi_awlen));
assign ar_wrap_size  = (`AXI_DATA_WIDTH/8 * (axi_arlen));
assign aw_wrap_en    = ((axi_awaddr & aw_wrap_size) == aw_wrap_size)? 1'b1: 1'b0;
assign ar_wrap_en    = ((axi_araddr & ar_wrap_size) == ar_wrap_size)? 1'b1: 1'b0;

// start write transaction when assert awvalid
always @(posedge clk) begin
    if (rst_n == 1'b0) begin
        axi_awready        <= 1'b0;
        burst_write_active <= 1'b0;
    end
    else begin
        if (~axi_awready && mem_axi_awvalid && ~burst_write_active && ~burst_read_active) begin
            axi_awready        <= 1'b1;
            burst_write_active <= 1'b1;
        end
        else if (mem_axi_wlast && axi_wready) begin
            burst_write_active  <= 1'b0;
        end
        else begin
            axi_awready <= 1'b0;
        end
    end
end

//--------------------
// Write transaction
//--------------------

always @(posedge clk) begin
    if (rst_n == 1'b0) begin
        axi_awaddr  <= 0;
        write_index <= 0;
        axi_awburst <= 0;
        axi_awlen   <= 0;
    end
    else begin
        if (~axi_awready && mem_axi_awvalid && ~burst_write_active) begin
            axi_awaddr  <= mem_axi_awaddr;
            axi_awburst <= mem_axi_awburst;
            axi_awlen   <= mem_axi_awlen;
            write_index <= 0;
        end
        else if((write_index <= axi_awlen) && axi_wready && mem_axi_wvalid) begin
            write_index <= write_index + 1;
            case (axi_awburst)
                2'b00: // fixed burst
                    begin
                        axi_awaddr <= axi_awaddr;
                    end
                2'b01: //incremental burst
                    begin
                        axi_awaddr[`AXI_ADDR_WIDTH - 1:ADDR_LSB] <= axi_awaddr[`AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
                        axi_awaddr[ADDR_LSB-1:0]                  <= {ADDR_LSB{1'b0}};
                    end
                2'b10: //Wrapping burst
                    if (aw_wrap_en) begin
                        axi_awaddr <= (axi_awaddr - aw_wrap_size);
                    end
                    else begin
                        axi_awaddr[`AXI_ADDR_WIDTH - 1:ADDR_LSB] <= axi_awaddr[`AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
                        axi_awaddr[ADDR_LSB-1:0]                  <= {ADDR_LSB{1'b0}};
                    end
                default: 
                    begin
                        axi_awaddr <= axi_awaddr[`AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
                    end
            endcase
        end
    end
end



always @(posedge clk) begin
    if (rst_n == 1'b0) begin
        axi_wready <= 1'b0;
    end
    else begin
        if (~axi_wready && mem_axi_wvalid && burst_write_active) begin
            axi_wready <= 1'b1;
        end
        else if (mem_axi_wlast && axi_wready) begin
            axi_wready <= 1'b0;
        end
    end
end

always @(posedge clk) begin
    if (rst_n == 1'b0) begin
        axi_bvalid <= 1'b0;
        axi_bresp  <= 2'b0;
    end
    else begin
        if (burst_write_active && axi_wready && mem_axi_wvalid && ~axi_bvalid && mem_axi_wlast ) begin
            axi_bvalid <= 1'b1;
            axi_bresp  <= 2'b0; // OK
        end
        else begin
            if (mem_axi_bready && axi_bvalid) begin
                axi_bvalid <= 1'b0;
            end
        end
    end
end

//--------------------
// Read transaction
//--------------------

always @(posedge clk) begin
    if (rst_n == 1'b0) begin
        axi_arready       <= 1'b0;
        burst_read_active <= 1'b0;
    end
    else begin
        if (~axi_arready && mem_axi_arvalid && ~burst_write_active && ~burst_read_active) begin
            axi_arready       <= 1'b1;
            burst_read_active <= 1'b1;
        end
        else if (axi_rvalid && mem_axi_rready && read_index == axi_arlen) begin
            burst_read_active  <= 1'b0;
        end
        else begin
            axi_arready <= 1'b0;
        end
    end
end


always @(posedge clk) begin
    if (rst_n == 1'b0) begin
        axi_araddr  <= 0;
        read_index  <= 0;
        axi_arburst <= 0;
        axi_arlen   <= 0;
        axi_rlast   <= 1'b0;
    end
    else begin
        if (~axi_arready && mem_axi_arvalid && ~burst_read_active) begin
            axi_araddr  <= mem_axi_araddr[`AXI_ADDR_WIDTH - 1:0];
            axi_arburst <= mem_axi_arburst;
            axi_arlen   <= mem_axi_arlen;
            read_index  <= 0;
            axi_rlast   <= 1'b0;
        end
        else if((read_index <= axi_arlen) && axi_rvalid && mem_axi_rready) begin
            read_index <= read_index + 1;
            axi_rlast  <= 1'b0;
            case (axi_arburst)
                2'b00: // fixed burst
                    begin
                        axi_araddr <= axi_araddr;
                    end
                2'b01: //incremental burst
                    begin
                        axi_araddr[`AXI_ADDR_WIDTH - 1:ADDR_LSB] <= axi_araddr[`AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
                        axi_araddr[ADDR_LSB-1:0]  <= {ADDR_LSB{1'b0}};
                    end
                2'b10: //Wrapping burst
                    if (ar_wrap_en) begin
                        axi_araddr <= (axi_araddr - ar_wrap_size);
                    end
                    else begin
                        axi_araddr[`AXI_ADDR_WIDTH - 1:ADDR_LSB] <= axi_araddr[`AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
                        axi_araddr[ADDR_LSB-1:0]  <= {ADDR_LSB{1'b0}};
                    end
                default: 
                    begin
                        axi_araddr <= axi_araddr[`AXI_ADDR_WIDTH - 1:ADDR_LSB]+1;
                    end
            endcase
        end
        else if((read_index == axi_arlen) && ~axi_rlast && burst_read_active) begin
            axi_rlast <= 1'b1;
        end
        else if (mem_axi_rready) begin
            axi_rlast <= 1'b0;
        end
    end
end


always @(posedge clk) begin
    if (rst_n == 1'b0) begin
        axi_rvalid <= 0;
        axi_rresp  <= 0;
    end
    else begin
        if (burst_read_active && ~axi_rvalid) begin
            axi_rvalid <= 1'b1;
            axi_rresp  <= 2'b0;
        end
        else if (axi_rvalid && mem_axi_rready) begin
            axi_rvalid <= 1'b0;
        end
    end
end


// implement Block RAM(s)
assign mem_address = (burst_read_active  ? axi_araddr[MEM_ADDR_WIDTH-1:ADDR_LSB] 
                   : (burst_write_active ? axi_awaddr[MEM_ADDR_WIDTH-1:ADDR_LSB] 
                   : 0));

reg  [`AXI_DATA_WIDTH-1:0] mem_data [0 : MEM_ADDR_DEEP-1];

wire mem_rden;
wire mem_wren;

assign mem_wren = axi_wready && mem_axi_wvalid;
assign mem_rden = burst_read_active; 

always @(posedge clk) begin
    if (mem_wren) begin
        mem_data[mem_address] <= mem_axi_wdata;
    end
end
always @(posedge clk) begin
    if (mem_rden) begin
        axi_rdata <= mem_data[mem_address];
    end
    else begin
        axi_rdata <= 32'h00000000;
    end
end

endmodule
