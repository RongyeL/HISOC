// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : alu.v
// Author        : Rongye
// Created On    : 2022-03-24 23:36
// Last Modified : 2024-08-11 08:39
// ---------------------------------------------------------------------------------
// Description   : Only simple operations:
//                 Integer Arithmetic Operations 
//                 Bit logic operation
//                 Shift operation 
//
// -FHDR----------------------------------------------------------------------------
module ALU(
    input      [`ALU_OP_WIDTH-1:0] alu_op,   // alu opcode
    input      [`CPU_WIDTH-1:0]    alu_src1, // alu source 1
    input      [`CPU_WIDTH-1:0]    alu_src2, // alu source 2
    output reg [`CPU_WIDTH-1:0]    alu_res   // alu result
);


always @(*) begin
    alu_res = `CPU_WIDTH'b0;
    case (alu_op)
        `ALU_AND: 
            alu_res = alu_src1 & alu_src2;
        `ALU_OR: 
            alu_res = alu_src1 | alu_src2;
        `ALU_XOR: 
            alu_res = alu_src1 ^ alu_src2;
        `ALU_ADD: 
            alu_res = alu_src1 + alu_src2;
        `ALU_SUB: 
            alu_res = alu_src1 - alu_src2;
        `ALU_SLL: 
            alu_res = alu_src1 << alu_src2[4:0];
        `ALU_SRL: 
            alu_res = alu_src1 >> alu_src2[4:0];
        `ALU_SRA: 
            alu_res = $signed(alu_src1) >>> alu_src2[4:0];
        `ALU_SLT:
            alu_res = {{(`CPU_WIDTH-1){1'b0}},($signed(alu_src1) < $signed(alu_src2))};
        `ALU_SLTU:
            alu_res = {{(`CPU_WIDTH-1){1'b0}},($unsigned(alu_src1) < $unsigned(alu_src2))};
        `ALU_EQU: 
            alu_res = {{(`CPU_WIDTH-1){1'b0}},(alu_src1 == alu_src2)};
    endcase
end
endmodule
