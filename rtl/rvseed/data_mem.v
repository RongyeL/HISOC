// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : data_mem.v
// Author        : Rongye
// Created On    : 2022-03-24 22:11
// Last Modified : 2024-08-12 06:37
// ---------------------------------------------------------------------------------
// Description   : Data memory 
//
//
// -FHDR----------------------------------------------------------------------------
module DATA_MEM (
    input                                       clk,

    input                                       mem_wen,   // memory write enable
    input                                       mem_ren,   // memory read enable

    input      [`DATA_MEM_ADDR_WIDTH    -1:0]   mem_addr,  // memory write/ read address
    input      [`DATA_MEM_DATA_WIDTH    -1:0]   mem_wdata, // memory write data input
    output reg [`DATA_MEM_DATA_WIDTH    -1:0]   mem_rdata  // memory read data output
);
    
reg [`DATA_MEM_DATA_WIDTH-1:0] data_mem_f [0:`DATA_MEM_ADDR_DEPTH-1];

// memory write
always @(posedge clk) begin
    if (mem_wen) 
        data_mem_f[mem_addr[`DATA_MEM_ADDR_WIDTH+2-1:2]][31:0] <= mem_wdata;
end

// memory read
always @(*) begin
    if (mem_ren) 
        mem_rdata = data_mem_f[mem_addr[`DATA_MEM_ADDR_WIDTH+2-1:2]];

end

endmodule
