// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : sync_fifo.v
// Author        : Rongye
// Created On    : 2024-07-30 08:53
// Last Modified : 2024-07-30 09:59
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module SYNC_FIFO #(
    parameter FIFO_DEEP   = 8,
    parameter FIFO_DEEP_W = 3,
    parameter FIFO_DATA_W = 32
)(
    input  wire                                     clk,
    input  wire                                     rst_n,
    input  wire                                     wr,
    input  wire                                     rd,
    input  wire [FIFO_DATA_W      -1:0]             wr_dat,
    output reg  [FIFO_DATA_W      -1:0]             rd_dat,
    output reg                                      rd_dat_vld,

    output wire                                     full,
    output wire                                     empty,
    input  wire [FIFO_DEEP_W      -1:0]             fifo_num

);
localparam DLY         = 0.1;

// ---------------------------------------------------------------------------------
// Inner Signal
// ---------------------------------------------------------------------------------
wire [FIFO_DEEP_W  -1:0] wr_ptr;
wire [FIFO_DEEP_W  -1:0] rd_ptr;
reg  [FIFO_DEEP_W    :0] wr_ptr_r; // MSB is wrap flg
reg  [FIFO_DEEP_W    :0] rd_ptr_r;

reg  [FIFO_DATA_W  -1:0] fifo_data [FIFO_DEEP-1:0];

assign wr_ptr = wr_ptr_r[FIFO_DEEP_W-1:0];
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        wr_ptr_r <= #DLY {(FIFO_DEEP_W+1){1'b0}};
    end
    else if (wr) begin
        wr_ptr_r <= #DLY wr_ptr_r + 1;
    end
end

assign rd_ptr = rd_ptr_r[FIFO_DEEP_W-1:0];
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        rd_ptr_r <= #DLY {(FIFO_DEEP_W+1){1'b0}};
    end
    else if (rd) begin
        rd_ptr_r <= #DLY rd_ptr_r + 1;
    end
end

assign fifo_num = wr_ptr_r - rd_ptr_r;

assign full  = (wr_ptr_r[FIFO_DEEP_W] != rd_ptr_r[FIFO_DEEP_W]) & (wr_ptr_r[FIFO_DEEP_W-1:0] == rd_ptr_r[FIFO_DEEP_W-1:0]);
assign empty = (wr_ptr_r[FIFO_DEEP_W] == rd_ptr_r[FIFO_DEEP_W]) & (wr_ptr_r[FIFO_DEEP_W-1:0] == rd_ptr_r[FIFO_DEEP_W-1:0]);

integer i;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        for (i=0;i<FIFO_DEEP;i=i+1) begin
            fifo_data[i] <= #DLY {(FIFO_DATA_W){1'b0}};
        end
    end
    else begin
        for (i=0;i<FIFO_DEEP;i=i+1) begin
            if(wr & (wr_ptr == i)) begin
                fifo_data[i] <= #DLY wr_dat;
            end
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        rd_dat <= #DLY {FIFO_DATA_W{1'b0}};
    end
    else if(rd) begin
        for (i=0;i<FIFO_DEEP;i=i+1) begin
            if(rd & (rd_ptr == i)) begin
                rd_dat <= #DLY fifo_data[i];
            end
        end
    end
end
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        rd_dat_vld <= #DLY 1'b0;
    end
    else begin
        rd_dat_vld <= #DLY rd;
    end
end

endmodule
