// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : tb_rvseed.v
// Author        : Rongye
// Created On    : 2022-03-25 04:18
// Last Modified : 2024-07-25 08:48
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
`timescale 1ns / 1ps

module TB_HISOC ();

reg                  clk;
reg                  rst_n;
reg                  enable;

reg [16*8-1:0] inst_list [0:40];
reg [16*8-1:0] inst_name;
initial begin
    inst_list[0]  = "../inst/ADD";  inst_list[1]  = "../inst/SUB";  inst_list[2]  = "../inst/XOR";
    inst_list[3]  = "../inst/OR";   inst_list[4]  = "../inst/AND";  inst_list[5]  = "../inst/SLL";
    inst_list[6]  = "../inst/SRL";  inst_list[7]  = "../inst/SRA";  inst_list[8]  = "../inst/SLT";
    inst_list[9]  = "../inst/SLTU"; inst_list[10] = "../inst/ADDI"; inst_list[11] = "../inst/XORI";
    inst_list[12] = "../inst/ORI";  inst_list[13] = "../inst/ANDI"; inst_list[14] = "../inst/SLLI";
    inst_list[15] = "../inst/SRLI"; inst_list[16] = "../inst/SRAI"; inst_list[17] = "../inst/SLTI";
    inst_list[18] = "../inst/SLTIU";inst_list[19] = "../inst/LB";   inst_list[20] = "../inst/LH";
    inst_list[21] = "../inst/LW";   inst_list[22] = "../inst/LBU";  inst_list[23] = "../inst/LHU";
    inst_list[24] = "../inst/SB";   inst_list[25] = "../inst/SH";   inst_list[26] = "../inst/SW";
    inst_list[27] = "../inst/BEQ";  inst_list[28] = "../inst/BNE";  inst_list[29] = "../inst/BLT";
    inst_list[30] = "../inst/BGE";  inst_list[31] = "../inst/BLTU"; inst_list[32] = "../inst/BGEU";
    inst_list[33] = "../inst/JAL";  inst_list[34] = "../inst/JALR"; inst_list[35] = "../inst/LUI";
    inst_list[36] = "../inst/AUIPC";
end

integer k;
initial begin
    #(`SIM_PERIOD/2);
    clk = 1'b0;
    for (k = 0; k < 1; k++) begin
        reset;
        inst_name = inst_list[k];
        inst_load(inst_name);
    end
    #(`SIM_PERIOD * 50);
    $finish;
end

initial begin
    #(`SIM_PERIOD * 50000);
    $display("Time Out");
    $finish;
end

always #(`SIM_PERIOD/2) clk = ~clk;

task reset;                // reset 1 clock
    begin
        enable = 0; 
        rst_n = 0; 
        #(`SIM_PERIOD * 1);
        rst_n = 1;
        enable = 1; 
    end
endtask

task inst_load;
    input [16*8-1:0] inst_name;
    begin
        $readmemh (inst_name, U_RVSEED. U_INST_MEM. mem_data);
        #(`SIM_PERIOD * 500);
    end
endtask

// task reg_mem_clear;
    // begin
        // $readmemh ("../data/data_mem_clear.data", U_RVSEED_0. U_DATA_MEM_0. data_mem_f);
        // $readmemh ("../data/reg_file_clear.data", U_RVSEED_0. U_REG_FILE_0. reg_f);
    // end
// endtask

RVSEED U_RVSEED(
    .clk                            ( clk                           ),
    .rst_n                          ( rst_n                         ),
    .enable                         ( enable                        )
);

// vcs 
initial begin
    $fsdbDumpfile("sim_out.fsdb");
    $fsdbDumpvars("+all");
end

endmodule
