// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : pc_reg.v
// Author        : Rongye
// Created On    : 2022-03-21 20:17
// Last Modified : 2024-08-12 08:08
// ---------------------------------------------------------------------------------
// Description   : Update the current pc value 
//
// -FHDR----------------------------------------------------------------------------
module PC_REG (
    input  wire                                 clk,     // system clock
    input  wire                                 rst_n,   // active low reset
    input  wire                                 enable,   // active low reset

    input  wire                                 branch_en,       
    input  wire [`CPU_WIDTH             -1:0]   branch_pc,       
    input  wire                                 jump_en,       
    input  wire [`CPU_WIDTH             -1:0]   jump_pc,    

    output reg  [`CPU_WIDTH             -1:0]   curr_pc,  // current pc addr

    input  wire                                 ifu2idu_en       
);

localparam DLY = 0.1;
   
// PC REGISTER 
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        curr_pc <= #DLY `CPU_WIDTH'b0;
    end
    else if (enable) begin
        if (branch_en) begin
            curr_pc <= #DLY branch_pc;
        end
        else if (jump_en) begin
            curr_pc <= #DLY jump_pc;
        end
        else if (ifu2idu_en) begin
            curr_pc <= #DLY curr_pc + `CPU_WIDTH'h4; 
        end
    end
end 
endmodule
