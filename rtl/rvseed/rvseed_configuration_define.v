// +FHDR------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// -----------------------------------------------------------------------
// Filename      : rvseed_defines.v
// Author        : Rongye
// Created On    : 2022-03-21 20:17
// Last Modified : 2024-07-28 08:57
// -----------------------------------------------------------------------
// Description   : 
//
//
// -FHDR------------------------------------------------------------------

// simulation clock period
`define SIM_PERIOD 20 // 20ns -> 50MHz 

// processor numbers
`define CPU_WIDTH 32 // rv32

// instruction memory
`define INST_MEM_ADDR_DEPTH 2048

// register 
`define REG_DATA_DEPTH 32
`define REG_ADDR_WIDTH 5 // 2^5 = 32

// data memory 
`define DATA_MEM_ADDR_DEPTH 1024
`define DATA_MEM_ADDR_WIDTH 10 // 2^10 = 1024