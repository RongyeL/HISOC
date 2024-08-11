// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : ro_reg.v
// Author        : Rongye
// Created On    : 2024-07-25 05:27
// Last Modified : 2024-08-06 09:13
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module RO_REG #(
    parameter DATA_W = 32,
    parameter DEFAULT_VALUE = 32'b0
)(
    input  wire              clk_reg,
    input  wire              rst_reg_n,

    input  wire [DATA_W-1:0] data_in,
    output wire [DATA_W-1:0] data_out
);
localparam DLY = 0.1;
reg [DATA_W-1:0] reg_data;
always @ (posedge clk_reg or negedge rst_reg_n) begin
    if(~rst_reg_n) begin
        reg_data <= #DLY DEFAULT_VALUE;
    end
end
assign data_out = reg_data;

endmodule
