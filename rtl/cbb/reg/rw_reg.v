// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : rw_reg.v
// Author        : Rongye
// Created On    : 2024-07-25 05:27
// Last Modified : 2024-08-18 07:37
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module RW_REG #(
    parameter DATA_W = 32,
    parameter DEFAULT_VALUE = 32'b0
)(
    input  wire              clk_reg,
    input  wire              rst_reg_n,

    input  wire              wen,
    input  wire [DATA_W-1:0] data_in,
    output wire [DATA_W-1:0] data_out
);
localparam DLY = 0.1;
reg [DATA_W-1:0] reg_data;
always @ (posedge clk_reg or negedge rst_reg_n) begin
    if(~rst_reg_n) begin
        reg_data <= #DLY DEFAULT_VALUE;
    end
    else if (wen) begin
        reg_data <= #DLY data_in;
    end
end
assign data_out = wen ? data_in : reg_data;

endmodule
