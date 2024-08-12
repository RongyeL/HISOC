// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : mux_mem.v
// Author        : Rongye
// Created On    : 2022-03-28 22:35
// Last Modified : 2024-08-12 05:09
// ---------------------------------------------------------------------------------
// Description   : Select the data source of mem.  
//
//
// -FHDR----------------------------------------------------------------------------
module MUX_MEM (
    input      [`MEM_OP_WIDTH-1:0] mem_op, // memory opcode
    input      [`CPU_WIDTH-1:0]    mem_addr, // memory write/read address
    input      [`CPU_WIDTH-1:0]    reg2_rdata,
    input      [`CPU_WIDTH-1:0]    mem_rdata,

    output reg [`CPU_WIDTH-1:0]    mem_wdata
);



endmodule
