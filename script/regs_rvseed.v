//--------------------------------------------------------------------------------
// RVSEED
//--------------------------------------------------------------------------------
module REGS_RVSEED(
    wire                           clk_reg,
    wire                           rst_reg_n,
    wire                           reg_wen,    // register write enable
    wire [`REG_ADDR_WIDTH  -1:0]   reg_waddr,  // register write address
    wire [`REG_DATA_WIDTH  -1:0]   reg_wdata,  // register write data

    wire [`REG_ADDR_WIDTH  -1:0]   reg1_raddr, // register 1 read address
    wire [`REG_ADDR_WIDTH  -1:0]   reg2_raddr, // register 2 read address
    wire [`REG_DATA_WIDTH  -1:0]   reg1_rdata, // register 1 read data
    wire [`REG_DATA_WIDTH  -1:0]   reg2_rdata  // register 2 read data
);
// x0 (zero)
wire wen_h00 = reg_wen & (reg_waddr == 16'h00);
wire [`REG_DATA_WIDTH-1:0] rdata_h00;
RW_REG #(32,32'h00000000) U_X0_H00 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h00            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h00          )
);

// x1 (ra)
wire wen_h04 = reg_wen & (reg_waddr == 16'h04);
wire [`REG_DATA_WIDTH-1:0] rdata_h04;
RW_REG #(32,32'h00000000) U_X1_H04 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h04            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h04          )
);

// x2 (sp)
wire wen_h08 = reg_wen & (reg_waddr == 16'h08);
wire [`REG_DATA_WIDTH-1:0] rdata_h08;
RW_REG #(32,32'h00000000) U_X2_H08 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h08            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h08          )
);

// x3 (gp)
wire wen_h0c = reg_wen & (reg_waddr == 16'h0c);
wire [`REG_DATA_WIDTH-1:0] rdata_h0c;
RW_REG #(32,32'h00000000) U_X3_H0C (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h0c            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h0c          )
);

// x4 (tp)
wire wen_h10 = reg_wen & (reg_waddr == 16'h10);
wire [`REG_DATA_WIDTH-1:0] rdata_h10;
RW_REG #(32,32'h00000000) U_X4_H10 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h10            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h10          )
);

// x5 (t0)
wire wen_h14 = reg_wen & (reg_waddr == 16'h14);
wire [`REG_DATA_WIDTH-1:0] rdata_h14;
RW_REG #(32,32'h00000000) U_X5_H14 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h14            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h14          )
);

// x6 (t1)
wire wen_h18 = reg_wen & (reg_waddr == 16'h18);
wire [`REG_DATA_WIDTH-1:0] rdata_h18;
RW_REG #(32,32'h00000000) U_X6_H18 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h18            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h18          )
);

// x7 (t2)
wire wen_h1c = reg_wen & (reg_waddr == 16'h1c);
wire [`REG_DATA_WIDTH-1:0] rdata_h1c;
RW_REG #(32,32'h00000000) U_X7_H1C (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h1c            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h1c          )
);

// x8 (s0/fp)
wire wen_h20 = reg_wen & (reg_waddr == 16'h20);
wire [`REG_DATA_WIDTH-1:0] rdata_h20;
RW_REG #(32,32'h00000000) U_X8_H20 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h20            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h20          )
);

// x9 (s1)
wire wen_h24 = reg_wen & (reg_waddr == 16'h24);
wire [`REG_DATA_WIDTH-1:0] rdata_h24;
RW_REG #(32,32'h00000000) U_X9_H24 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h24            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h24          )
);

// x10 (a0)
wire wen_h28 = reg_wen & (reg_waddr == 16'h28);
wire [`REG_DATA_WIDTH-1:0] rdata_h28;
RW_REG #(32,32'h00000000) U_X10_H28 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h28            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h28          )
);

// x11 (a1)
wire wen_h2c = reg_wen & (reg_waddr == 16'h2c);
wire [`REG_DATA_WIDTH-1:0] rdata_h2c;
RW_REG #(32,32'h00000000) U_X11_H2C (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h2c            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h2c          )
);

// x12 (a2)
wire wen_h30 = reg_wen & (reg_waddr == 16'h30);
wire [`REG_DATA_WIDTH-1:0] rdata_h30;
RW_REG #(32,32'h00000000) U_X12_H30 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h30            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h30          )
);

// x13 (a3)
wire wen_h34 = reg_wen & (reg_waddr == 16'h34);
wire [`REG_DATA_WIDTH-1:0] rdata_h34;
RW_REG #(32,32'h00000000) U_X13_H34 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h34            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h34          )
);

// x14 (a4)
wire wen_h38 = reg_wen & (reg_waddr == 16'h38);
wire [`REG_DATA_WIDTH-1:0] rdata_h38;
RW_REG #(32,32'h00000000) U_X14_H38 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h38            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h38          )
);

// x15 (a5)
wire wen_h3c = reg_wen & (reg_waddr == 16'h3c);
wire [`REG_DATA_WIDTH-1:0] rdata_h3c;
RW_REG #(32,32'h00000000) U_X15_H3C (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h3c            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h3c          )
);

// x16 (a6)
wire wen_h40 = reg_wen & (reg_waddr == 16'h40);
wire [`REG_DATA_WIDTH-1:0] rdata_h40;
RW_REG #(32,32'h00000000) U_X16_H40 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h40            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h40          )
);

// x17 (a7)
wire wen_h44 = reg_wen & (reg_waddr == 16'h44);
wire [`REG_DATA_WIDTH-1:0] rdata_h44;
RW_REG #(32,32'h00000000) U_X17_H44 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h44            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h44          )
);

// x18 (s2)
wire wen_h48 = reg_wen & (reg_waddr == 16'h48);
wire [`REG_DATA_WIDTH-1:0] rdata_h48;
RW_REG #(32,32'h00000000) U_X18_H48 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h48            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h48          )
);

// x19 (s3)
wire wen_h4c = reg_wen & (reg_waddr == 16'h4c);
wire [`REG_DATA_WIDTH-1:0] rdata_h4c;
RW_REG #(32,32'h00000000) U_X19_H4C (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h4c            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h4c          )
);

// x20 (s4)
wire wen_h50 = reg_wen & (reg_waddr == 16'h50);
wire [`REG_DATA_WIDTH-1:0] rdata_h50;
RW_REG #(32,32'h00000000) U_X20_H50 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h50            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h50          )
);

// x21 (s5)
wire wen_h54 = reg_wen & (reg_waddr == 16'h54);
wire [`REG_DATA_WIDTH-1:0] rdata_h54;
RW_REG #(32,32'h00000000) U_X21_H54 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h54            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h54          )
);

// x22 (s6)
wire wen_h58 = reg_wen & (reg_waddr == 16'h58);
wire [`REG_DATA_WIDTH-1:0] rdata_h58;
RW_REG #(32,32'h00000000) U_X22_H58 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h58            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h58          )
);

// x23 (s7)
wire wen_h5c = reg_wen & (reg_waddr == 16'h5c);
wire [`REG_DATA_WIDTH-1:0] rdata_h5c;
RW_REG #(32,32'h00000000) U_X23_H5C (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h5c            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h5c          )
);

// x24 (s8)
wire wen_h60 = reg_wen & (reg_waddr == 16'h60);
wire [`REG_DATA_WIDTH-1:0] rdata_h60;
RW_REG #(32,32'h00000000) U_X24_H60 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h60            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h60          )
);

// x25 (s9)
wire wen_h64 = reg_wen & (reg_waddr == 16'h64);
wire [`REG_DATA_WIDTH-1:0] rdata_h64;
RW_REG #(32,32'h00000000) U_X25_H64 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h64            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h64          )
);

// x26 (s10)
wire wen_h68 = reg_wen & (reg_waddr == 16'h68);
wire [`REG_DATA_WIDTH-1:0] rdata_h68;
RW_REG #(32,32'h00000000) U_X26_H68 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h68            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h68          )
);

// x27 (s11)
wire wen_h6c = reg_wen & (reg_waddr == 16'h6c);
wire [`REG_DATA_WIDTH-1:0] rdata_h6c;
RW_REG #(32,32'h00000000) U_X27_H6C (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h6c            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h6c          )
);

// x28 (t3)
wire wen_h70 = reg_wen & (reg_waddr == 16'h70);
wire [`REG_DATA_WIDTH-1:0] rdata_h70;
RW_REG #(32,32'h00000000) U_X28_H70 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h70            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h70          )
);

// x29 (t4)
wire wen_h74 = reg_wen & (reg_waddr == 16'h74);
wire [`REG_DATA_WIDTH-1:0] rdata_h74;
RW_REG #(32,32'h00000000) U_X29_H74 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h74            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h74          )
);

// x30 (t5)
wire wen_h78 = reg_wen & (reg_waddr == 16'h78);
wire [`REG_DATA_WIDTH-1:0] rdata_h78;
RW_REG #(32,32'h00000000) U_X30_H78 (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h78            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h78          )
);

// x31 (t6)
wire wen_h7c = reg_wen & (reg_waddr == 16'h7c);
wire [`REG_DATA_WIDTH-1:0] rdata_h7c;
RW_REG #(32,32'h00000000) U_X31_H7C (
    .clk_reg        (clk_reg            ),
    .rst_reg_n      (rst_reg_n          ),
    .wen            (wen_h7c            ),
    .data_in        (reg_wdata          ),
    .data_out       (rdata_h7c          )
);


endmodule
