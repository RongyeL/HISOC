// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : pc_reg.v
// Author        : Rongye
// Created On    : 2022-03-21 20:17
// Last Modified : 2024-07-31 08:34
// ---------------------------------------------------------------------------------
// Description   : Update the current pc value 
//
// -FHDR----------------------------------------------------------------------------
module PC_REG (
    input wire                  clk,     // system clock
    input wire                  rst_n,   // active low reset
    input wire                  next_en, // 
    input wire [`CPU_WIDTH-1:0] next_pc, // next pc addr
    output reg [`CPU_WIDTH-1:0] curr_pc  // current pc addr
);

localparam DLY = 0.1;
   

endmodule
