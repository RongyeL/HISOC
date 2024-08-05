// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : ifu2idu.v
// Author        : Rongye
// Created On    : 2024-08-05 06:09
// Last Modified : 2024-08-05 08:33
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module IFU2IDU (
    input  wire                             clk,
    input  wire                             rst_n,             
// ifu2idu
    input  wire                             ifu2idu_en,
    input  wire [`CPU_WIDTH         -1:0]   ifu2idu_pc,
    input  wire [`CPU_WIDTH         -1:0]   ifu2idu_inst,

    output reg                              ifu2idu_en_r,
    output reg  [`CPU_WIDTH         -1:0]   ifu2idu_pc_r,
    output reg  [`CPU_WIDTH         -1:0]   ifu2idu_inst_r
);
localparam DLY = 0.1;

// ifu2idu Register 
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        ifu2idu_en_r <= #DLY 1'b0;
    end
    else begin
        ifu2idu_en_r <= #DLY ifu2idu_en;
    end
end
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        ifu2idu_pc_r   <= #DLY `CPU_WIDTH'b0;
        ifu2idu_inst_r <= #DLY `CPU_WIDTH'b0;
    end
    else if (ifu2idu_en) begin
        ifu2idu_pc_r   <= #DLY ifu2idu_pc;
        ifu2idu_inst_r <= #DLY ifu2idu_inst;
    end
end 

endmodule
