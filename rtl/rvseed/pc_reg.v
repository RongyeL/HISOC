// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : pc_reg.v
// Author        : Rongye
// Created On    : 2022-03-21 20:17
// Last Modified : 2024-07-24 09:11
// ---------------------------------------------------------------------------------
// Description   : Update the current pc value 
//
// -FHDR----------------------------------------------------------------------------
module PC_REG (
    input wire                  clk,     // system clock
    input wire                  rst_n,   // active low reset
    input wire                  next_en, // 
    input wire [`CPU_WIDTH-1:0] next_pc, // next pc addr
    output reg [`CPU_WIDTH-1:0] curr_pc,  // current pc addr
    output reg                  pc_update // pc update flag for ifu 
);

always @ (posedge clk or negedge rst_n) begin
    if(~rst_n)
        curr_pc <= `CPU_WIDTH'b0;
    else if (next_en)
        curr_pc <= next_pc;
end    
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n)
        pc_update <= 1'b0;
    else if (next_en)
        pc_update <= 1'b1;
    else
        pc_update <= 1'b0;
end 
endmodule
