// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : tb_rvseed.v
// Author        : Rongye
// Created On    : 2022-03-25 04:18
// Last Modified : 2024-08-11 08:41
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

// register file
wire [`CPU_WIDTH-1:0] zero_x0  = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h00;
wire [`CPU_WIDTH-1:0] ra_x1    = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h04;
wire [`CPU_WIDTH-1:0] sp_x2    = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h08;
wire [`CPU_WIDTH-1:0] gp_x3    = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h0c;
wire [`CPU_WIDTH-1:0] tp_x4    = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h10;
wire [`CPU_WIDTH-1:0] t0_x5    = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h14;
wire [`CPU_WIDTH-1:0] t1_x6    = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h18;
wire [`CPU_WIDTH-1:0] t2_x7    = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h1c;
wire [`CPU_WIDTH-1:0] s0_fp_x8 = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h20;
wire [`CPU_WIDTH-1:0] s1_x9    = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h24;
wire [`CPU_WIDTH-1:0] a0_x10   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h28;
wire [`CPU_WIDTH-1:0] a1_x11   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h2c;
wire [`CPU_WIDTH-1:0] a2_x12   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h30;
wire [`CPU_WIDTH-1:0] a3_x13   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h34;
wire [`CPU_WIDTH-1:0] a4_x14   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h38;
wire [`CPU_WIDTH-1:0] a5_x15   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h3c;
wire [`CPU_WIDTH-1:0] a6_x16   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h40;
wire [`CPU_WIDTH-1:0] a7_x17   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h44;
wire [`CPU_WIDTH-1:0] s2_x18   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h48;
wire [`CPU_WIDTH-1:0] s3_x19   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h4c;
wire [`CPU_WIDTH-1:0] s4_x20   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h50;
wire [`CPU_WIDTH-1:0] s5_x21   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h54;
wire [`CPU_WIDTH-1:0] s6_x22   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h58;
wire [`CPU_WIDTH-1:0] s7_x23   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h5c;
wire [`CPU_WIDTH-1:0] s8_x24   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h60;
wire [`CPU_WIDTH-1:0] s9_x25   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h64;
wire [`CPU_WIDTH-1:0] s10_x26  = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h68;
wire [`CPU_WIDTH-1:0] s11_x27  = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h6c;
wire [`CPU_WIDTH-1:0] t3_x28   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h70;
wire [`CPU_WIDTH-1:0] t4_x29   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h74;
wire [`CPU_WIDTH-1:0] t5_x30   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h78;
wire [`CPU_WIDTH-1:0] t6_x31   = U_HISOC. U_RVSEED. U_REGS_RVSEED. rdata_h7c;

integer r;
always begin
    wait(s10_x26 == 32'b1 & rst_n)   // wait sim end, when x26 == 1
        #(`SIM_PERIOD * 4 + 1)
        if (s11_x27 == 32'b1) begin
            $display("~~~~~~~~~~~~~~~~~~~ %s PASS ~~~~~~~~~~~~~~~~~~~",inst_name);
            $monitor($time);
            #(`SIM_PERIOD * 1)
            enable = 0; 
            reg_mem_clear;
        end 
        else begin
            $display("~~~~~~~~~~~~~~~~~~~ %s FAIL ~~~~~~~~~~~~~~~~~~~~",inst_name);
            $display("fail testnum = %2d", gp_x3);
            $monitor($time);
            #(`SIM_PERIOD * 1);
            $finish;
            // for (r = 0; r < 32; r = r + 1)
                // $display("x%2d = 0x%x", r, U_HISOC. U_RVSEED. U_REGS_RVSEED. reg_f[r]);
        end
end
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
    for (k = 0; k <= 36; k=k+1) begin
        reset;
        inst_name = inst_list[k];
        inst_load(inst_name);
    end
    #(`SIM_PERIOD * 200);
    // $finish;
end

initial begin
    #(`SIM_PERIOD * 100000);
    $display("Time Out");
    $finish;
end

always #(`SIM_PERIOD/2) clk = ~clk;

task reset;                // reset 1 clock
    begin
        enable = 0; 
        rst_n = 0; 
        reg_mem_clear;
        #(`SIM_PERIOD * 1);
        rst_n = 1;
        #(`SIM_PERIOD * 5 + 1);
        enable = 1; 
    end
endtask

task inst_load;
    input [16*8-1:0] inst_name;
    begin
        $readmemh (inst_name, U_HISOC. U_INST_ROM. mem_data);
        #(`SIM_PERIOD * 2000);
    end
endtask

task reg_mem_clear;
    begin
        rst_n = 0; 
        $readmemh ("../data/data_mem_clear.data", U_HISOC. U_RVSEED. U_DATA_MEM. data_mem_f);
        // $readmemh ("../data/reg_file_clear.data", U_HISOC. U_RVSEED. U_REGS_RVSEED. reg_f);
    end
endtask

HISOC U_HISOC(
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
