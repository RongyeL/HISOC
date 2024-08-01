// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : sync_fifo.v
// Author        : Rongye
// Created On    : 2024-07-30 08:53
// Last Modified : 2024-07-31 10:04
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

    input  wire                                     push,
    input  wire [FIFO_DATA_W      -1:0]             push_dat,

    input  wire                                     pop,
    output reg  [FIFO_DATA_W      -1:0]             pop_dat,
    output reg                                      pop_dat_vld,

    output wire                                     full,
    output wire                                     empty,
    output wire [FIFO_DEEP_W        :0]             fifo_num

);
localparam DLY         = 0.1;

// ---------------------------------------------------------------------------------
// Inner Signal
// ---------------------------------------------------------------------------------
wire [FIFO_DEEP_W  -1:0] push_ptr;
wire [FIFO_DEEP_W  -1:0] pop_ptr;
reg  [FIFO_DEEP_W    :0] push_ptr_r; // MSB is pushap flg
reg  [FIFO_DEEP_W    :0] pop_ptr_r;

reg  [FIFO_DATA_W  -1:0] fifo_data [FIFO_DEEP-1:0];

assign push_ptr = push_ptr_r[FIFO_DEEP_W-1:0];
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        push_ptr_r <= #DLY {(FIFO_DEEP_W+1){1'b0}};
    end
    else if (push) begin
        push_ptr_r <= #DLY push_ptr_r + 2'h1;
    end
end

assign pop_ptr = pop_ptr_r[FIFO_DEEP_W-1:0];
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        pop_ptr_r <= #DLY {(FIFO_DEEP_W+1){1'b0}};
    end
    else if (pop) begin
        pop_ptr_r <= #DLY pop_ptr_r + 2'h1;
    end
end

assign fifo_num = push_ptr_r - pop_ptr_r;

assign full  = (push_ptr_r[FIFO_DEEP_W] != pop_ptr_r[FIFO_DEEP_W]) & (push_ptr_r[FIFO_DEEP_W-1:0] == pop_ptr_r[FIFO_DEEP_W-1:0]);
assign empty = (push_ptr_r[FIFO_DEEP_W] == pop_ptr_r[FIFO_DEEP_W]) & (push_ptr_r[FIFO_DEEP_W-1:0] == pop_ptr_r[FIFO_DEEP_W-1:0]);

integer i;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        for (i=0;i<FIFO_DEEP;i=i+1) begin
            fifo_data[i] <= #DLY {(FIFO_DATA_W){1'b0}};
        end
    end
    else begin
        for (i=0;i<FIFO_DEEP;i=i+1) begin
            if(push & (push_ptr == i)) begin
                fifo_data[i] <= #DLY push_dat;
            end
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        pop_dat <= #DLY {FIFO_DATA_W{1'b0}};
    end
    else if(pop) begin
        for (i=0;i<FIFO_DEEP;i=i+1) begin
            if(pop & (pop_ptr == i)) begin
                pop_dat <= #DLY fifo_data[i];
            end
        end
    end
end
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        pop_dat_vld <= #DLY 1'b0;
    end
    else begin
        pop_dat_vld <= #DLY pop;
    end
end

endmodule
