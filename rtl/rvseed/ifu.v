// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : m_axi.v
// Author        : Rongye
// Created On    : 2022-12-25 03:08
// Last Modified : 2024-07-24 09:49
// ---------------------------------------------------------------------------------
// Description   :
//
//
// -FHDR----------------------------------------------------------------------------
module IFU #(
    parameter INST_MEM_BASE_ADDR	    = 32'h00000000,
    parameter integer BURST_LEN	= 1
)(
// global 
    input  wire                                  clk,
    input  wire                                  rst_n,          // active low
    input  wire                                  enable,          // rvseed enable ctrl
// AW channel
    output wire [`AXI_ID_WIDTH         -1:0]      ifu_axi_awid,     // write transaction id
    output wire [`AXI_ADDR_WIDTH       -1:0]      ifu_axi_awaddr,   // write address
    output wire [`AXI_BURST_LEN_WIDTH  -1:0]      ifu_axi_awlen,    // write transaction burst lengths
    output wire [`AXI_BURST_SIZE_WIDTH -1:0]      ifu_axi_awsize,   // write transaction burst size
    output wire [`AXI_BURST_TYPE_WIDTH -1:0]      ifu_axi_awburst,  // write transaction burst type
    output wire                                   ifu_axi_awlock,   // write transaction atomic type
    output wire [`AXI_CACHE_WIDTH      -1:0]      ifu_axi_awcache,  // write transaction memory attribute
    output wire [`AXI_PROT_WIDTH       -1:0]      ifu_axi_awprot,   // write transaction protection attribute
    output wire [`AXI_QOS_WIDTH        -1:0]      ifu_axi_awqos,    // write transaction quality of service
    output wire [`AXI_REGION_WIDTH     -1:0]      ifu_axi_awregion, // write transaction region
    output wire                                   ifu_axi_awvalid,  // write address channel valid
    input  wire                                   ifu_axi_awready,  // write address channel ready
// W channel
    output wire [`AXI_DATA_WIDTH       -1:0]      ifu_axi_wdata,    // write data
    output wire [(`AXI_DATA_WIDTH/8)   -1:0]      ifu_axi_wstrb,    // write strobe, indicate which byte is valid
    output wire                                   ifu_axi_wlast,    // write last data indicate
    output wire                                   ifu_axi_wvalid,   // write data channel valid
    input  wire                                   ifu_axi_wready,   // write data channel ready
// B channel
    input  wire [`AXI_ID_WIDTH         -1:0]             ifu_axi_bid,      // write transaction id
    input  wire [`AXI_RESP_WIDTH       -1:0]           ifu_axi_bresp,    // write response
    input  wire                                   ifu_axi_bvalid,   // write response channel valid
    output wire                                   ifu_axi_bready,   // write response channel ready
// AR channel 
    output wire [`AXI_ID_WIDTH         -1:0]            ifu_axi_arid,     // read transaction id
    output wire [`AXI_ADDR_WIDTH       -1:0]          ifu_axi_araddr,   // read address
    output wire [`AXI_BURST_LEN_WIDTH  -1:0]      ifu_axi_arlen,    // read transaction burst length
    output wire [`AXI_BURST_SIZE_WIDTH -1:0]     ifu_axi_arsize,   // read transaction burst size
    output wire [`AXI_BURST_TYPE_WIDTH -1:0]     ifu_axi_arburst,  // read transaction burst type
    output wire                                   ifu_axi_arlock,   // read atomic type
    output wire [`AXI_CACHE_WIDTH      -1 : 0]          ifu_axi_arcache,  // read transaction memory attribute
    output wire [`AXI_PROT_WIDTH       -1 : 0]           ifu_axi_arprot,   // read transaction protection attribute
    output wire [`AXI_QOS_WIDTH-1 : 0]            ifu_axi_arqos,    // read transaction quality of service
    output wire [`AXI_REGION_WIDTH-1 : 0]         ifu_axi_arregion, // read transaction region
    output wire                                   ifu_axi_arvalid,  // read address channel valid
    input  wire                                   ifu_axi_arready,  // read address channel ready
// R channel
    input  wire [`AXI_ID_WIDTH-1 : 0]             ifu_axi_rid,      // read transaction id
    input  wire [`AXI_DATA_WIDTH-1 : 0]           ifu_axi_rdata,    // read data
    input  wire [`AXI_RESP_WIDTH-1 : 0]            ifu_axi_rresp,    // read transaction response
    input  wire                                    ifu_axi_rlast,    // read last data indicate
    input  wire                                    ifu_axi_rvalid,   // read data channel valid
    output wire                                    ifu_axi_rready    // read data channel read

);

wire                         next_en;
wire [`CPU_WIDTH-1:0]        curr_pc;    // current pc addr
wire [`CPU_WIDTH-1:0]        next_pc;    // next pc addr
wire                         pc_update;

wire [`BRAN_WIDTH-1:0]       branch;     // branch flag
wire                         zero;       // alu result is zero
wire [`JUMP_WIDTH-1:0]       jump;       // jump flag

wire [`CPU_WIDTH-1:0]        imm;    // next pc addr
wire [`CPU_WIDTH-1:0]        reg1_rdata;    // next pc addr
assign branch     = `BRAN_WIDTH'b0;
assign zero       = 1'b0;
assign jump       = `JUMP_WIDTH'b0;
assign imm        = `CPU_WIDTH'b0;
assign reg1_rdata = `CPU_WIDTH'b0;

wire if_process   = pc_update;
reg  if_process_r;
assign next_en = enable & ~if_process & ~if_process_r;
PC_REG U_PC_REG(
    .clk                            ( clk                           ),
    .rst_n                          ( rst_n                         ),
    .next_en                        ( next_en                       ),
    .next_pc                        ( next_pc                       ),
    .curr_pc                        ( curr_pc                       ),
    .pc_update                      ( pc_update                     )
);

MUX_PC U_MUX_PC(
    .ena                            ( next_en                       ),
    .branch                         ( branch                        ),
    .zero                           ( zero                          ),
    .jump                           ( jump                          ),
    .imm                            ( imm                           ),
    .reg1_rdata                     ( reg1_rdata                    ),
    .curr_pc                        ( curr_pc                       ),
    .next_pc                        ( next_pc                       )
);


// ---------------------------------------------------------------------------------------------------
// IFU CTRL
// ---------------------------------------------------------------------------------------------------
wire if_req_en    = ifu_axi_arvalid & ifu_axi_arready;
wire if_result_en = ifu_axi_rvalid  & ifu_axi_rready & ifu_axi_rlast;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        if_process_r <= 1'b0;
    end
    else if (pc_update) begin
        if_process_r <= if_process;
    end
    else if (if_result_en) begin
        if_process_r <= 1'b0;
    end
end


// ---------------------------------------------------------------------------------------------------
// AXI MST CTRL
// ---------------------------------------------------------------------------------------------------
// Determine the counter bit width by calculating log2.
function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
            bit_depth = bit_depth >> 1;
    end
endfunction

localparam integer TX_NUM_WIDTH = clogb2(BURST_LEN-1);

localparam [1:0] IDLE    = 2'b00, 
                 WRITE   = 2'b01, // write transaction,
                 READ    = 2'b10; // read transaction

reg [1:0] mst_exestate;

// axi internal signals
reg  [`AXI_ADDR_WIDTH-1 : 0]       axi_awaddr;
reg                                 axi_awvalid;
reg  [`AXI_DATA_WIDTH-1 : 0]       axi_wdata;
reg                                 axi_wlast;
reg                                 axi_wvalid;
reg                                 axi_bready;
reg  [`AXI_ADDR_WIDTH-1 : 0]       axi_araddr;
reg                                 axi_arvalid;
reg                                 axi_rready;

reg  [TX_NUM_WIDTH : 0] 	write_index; // write beat count in a burst
reg  [TX_NUM_WIDTH : 0] 	read_index; // read beat count in a burst

wire [TX_NUM_WIDTH+2 : 0] burst_size_bytes; //size of BURST_LEN length burst in bytes

reg                                 start_single_burst_write;
reg                                 start_single_burst_read;
reg                                 writes_done;
reg                                 reads_done;
reg                                 burst_write_active;
reg                                 burst_read_active;
reg                                 txn_start_ff;
reg                                 txn_start_ff2;
wire                                txn_start_pulse;

//Interface response error flags
wire                                write_resp_error;
wire                                read_resp_error;


//Write Address (AW)
assign ifu_axi_awid       = 'b0;
assign ifu_axi_awaddr     = INST_MEM_BASE_ADDR + axi_awaddr;
assign ifu_axi_awlen      = BURST_LEN - 1;
assign ifu_axi_awsize     = clogb2((`AXI_DATA_WIDTH/8)-1);
assign ifu_axi_awburst    = `AXI_BURST_TYPE_WIDTH'b01;
assign ifu_axi_awlock     = 1'b0;
assign ifu_axi_awcache    = `AXI_CACHE_WIDTH'b0010;
assign ifu_axi_awprot     = `AXI_PROT_WIDTH'h0;
assign ifu_axi_awqos      = `AXI_QOS_WIDTH'h0;
assign ifu_axi_awregion   = `AXI_REGION_WIDTH'h0;
assign ifu_axi_awvalid    = axi_awvalid;
//Write Data(W)
assign ifu_axi_wdata      = axi_wdata;
assign ifu_axi_wstrb      = {(`AXI_DATA_WIDTH/8){1'b1}};
assign ifu_axi_wlast      = axi_wlast;
assign ifu_axi_wvalid     = axi_wvalid;
//Write Response (B)
assign ifu_axi_bready     = axi_bready;
//Read Address (AR)
assign ifu_axi_arid       = 'b0;
assign ifu_axi_araddr     = INST_MEM_BASE_ADDR + axi_araddr;
assign ifu_axi_arlen      = BURST_LEN - 1;
assign ifu_axi_arsize     = clogb2((`AXI_DATA_WIDTH/8)-1);
assign ifu_axi_arburst    = `AXI_BURST_TYPE_WIDTH'b01;
assign ifu_axi_arlock     = 1'b0;
assign ifu_axi_arcache    = `AXI_CACHE_WIDTH'b0010;
assign ifu_axi_arprot     = `AXI_PROT_WIDTH'h0;
assign ifu_axi_arqos      = `AXI_QOS_WIDTH'h0;
assign ifu_axi_arregion   = `AXI_REGION_WIDTH'h0;
assign ifu_axi_arvalid    = axi_arvalid;
//Read and Read Response (R)
assign ifu_axi_rready     = axi_rready;

//Example design I/O
assign txn_done         = (~burst_write_active) && (~burst_read_active);

//Burst size in bytes
assign burst_size_bytes = BURST_LEN * `AXI_DATA_WIDTH/8;

//Generate a pulse to initiate AXI transaction.
// assign txn_start_pulse	= (!txn_start_ff2) && txn_start_ff;
// always @(posedge clk) begin
    // if (rst_n == 0 ) begin
        // txn_start_ff  <= 1'b0;
        // txn_start_ff2 <= 1'b0;
    // end
    // else begin // rising edge detection
        // txn_start_ff  <= txn_start;
        // txn_start_ff2 <= txn_start_ff;
    // end
// end


//--------------------
//Write Address Channel
//--------------------

always @(posedge clk) begin
    if (rst_n == 0 ) begin
        axi_awvalid <= 1'b0;
    end
    else if (~axi_awvalid && start_single_burst_write) begin
        axi_awvalid <= 1'b1;
    end
    else if (ifu_axi_awready && axi_awvalid) begin
        axi_awvalid <= 1'b0;
    end 
    else begin
        axi_awvalid <= axi_awvalid;
    end
end

always @(posedge clk) begin
    if (rst_n == 0 ) begin
        axi_awaddr <= 'b0;
    end
    else if (ifu_axi_awready && axi_awvalid) begin
        axi_awaddr <= axi_awaddr + burst_size_bytes;
    end
    else begin
        axi_awaddr <= axi_awaddr;
    end
end


//--------------------
//Write Data Channel
//--------------------

always @(posedge clk) begin
    if (rst_n == 0 ) begin
        axi_wvalid <= 1'b0;
    end
    else if (~axi_wvalid && start_single_burst_write) begin
        axi_wvalid <= 1'b1;
    end
    else if (ifu_axi_wready & axi_wvalid && axi_wlast) begin
        axi_wvalid <= 1'b0;
    end
    else begin
        axi_wvalid <= axi_wvalid;
    end
end


always @(posedge clk) begin
    if (rst_n == 0 ) begin
        axi_wlast <= 1'b0;
    end
    else if (((write_index == BURST_LEN-2 && BURST_LEN >= 2) && ifu_axi_wready & axi_wvalid) || (BURST_LEN == 1 )) begin
        axi_wlast <= 1'b1;
    end
    else if (ifu_axi_wready & axi_wvalid) begin
        axi_wlast <= 1'b0;
    end
    else if (axi_wlast && BURST_LEN == 1) begin
        axi_wlast <= 1'b0;
    end
    else begin
        axi_wlast <= axi_wlast;
    end
end


always @(posedge clk) begin
    if (rst_n == 0 || start_single_burst_write == 1'b1) begin
        write_index <= 0;
    end
    else if (ifu_axi_wready & axi_wvalid && (write_index != BURST_LEN-1)) begin
        write_index <= write_index + 1;
    end
    else begin
        write_index <= write_index;
    end
end


always @(posedge clk) begin
    if (rst_n == 0 ) begin
        axi_wdata <= 'b0;
    end
    else if (ifu_axi_wready & axi_wvalid) begin
        axi_wdata <= axi_wdata + 1;
    end
    else begin
        axi_wdata <= axi_wdata;
    end
end


//----------------------------
//Write Response (B) Channel
//----------------------------

always @(posedge clk) begin
    if (rst_n == 0) begin
        axi_bready <= 1'b0;
    end
    // accept/acknowledge bresp with axi_bready by the master
    else if (ifu_axi_bvalid && ~axi_bready) begin
        axi_bready <= 1'b1;
    end
    else if (axi_bready) begin
        axi_bready <= 1'b0;
    end
    else begin
        axi_bready <= axi_bready;
    end
end


//Flag any write response errors
assign write_resp_error = axi_bready & ifu_axi_bvalid & ifu_axi_bresp[1];


//----------------------------
//Read Address Channel
//----------------------------

always @(posedge clk) begin
    if (rst_n == 0 ) begin
        axi_arvalid <= 1'b0;
    end
    // If previously not valid , start next transaction
    else if (~axi_arvalid && start_single_burst_read) begin
        axi_arvalid <= 1'b1;
    end
    else if (ifu_axi_arready && axi_arvalid) begin
        axi_arvalid <= 1'b0;
    end
    else begin
        axi_arvalid <= axi_arvalid;
    end
end


// generate next address 
always @(posedge clk) begin
    if (rst_n == 0 ) begin
        axi_araddr <= 'b0;
    end
    else if (~axi_arvalid && pc_update) begin
        axi_araddr <= curr_pc;
    end
    else begin
        axi_araddr <= axi_araddr;
    end
end


//--------------------------------
//Read Data (and Response) Channel
//--------------------------------

always @(posedge clk) begin
    if (rst_n == 0 || start_single_burst_read) begin
        read_index <= 0;
    end
    else if ( ifu_axi_rvalid && axi_rready && (read_index != BURST_LEN-1)) begin
        read_index <= read_index + 1;
    end
    else begin
        read_index <= read_index;
    end
end


always @(posedge clk) begin
    if (rst_n == 0  ) begin
        axi_rready <= 1'b0;
    end
    else if (ifu_axi_rlast && axi_rready) begin
        axi_rready <= 1'b0;
    end
    else begin
        axi_rready <= 1'b1; //TODO
    end
end

//Flag any read response errors
assign read_resp_error = axi_rready & ifu_axi_rvalid & ifu_axi_rresp[1];


//--------------------------------
// write/ read transaction state 
//--------------------------------

always @ ( posedge clk) begin
    if (rst_n == 1'b0 ) begin
        mst_exestate             <= IDLE;
        start_single_burst_write <= 1'b0;
        start_single_burst_read  <= 1'b0;
    end
    else begin
        // state transition
        case (mst_exestate)
            IDLE:
                if (pc_update == 1'b1) begin
                    mst_exestate  <= READ;
                end
                else begin
                    mst_exestate  <= IDLE;
                end

            WRITE:
                if (writes_done) begin
                    mst_exestate <= IDLE;
                end
                else begin
                    mst_exestate  <= WRITE;
                    if ( ~burst_write_active) begin
                        start_single_burst_write <= 1'b1;
                    end
                    else begin
                        start_single_burst_write <= 1'b0; 
                    end
                end

            READ:
                if (reads_done) begin
                    mst_exestate <= IDLE;
                end
                else begin
                    mst_exestate  <= READ;
                    if (~burst_read_active) begin
                        start_single_burst_read <= 1'b1;
                    end
                    else begin
                        start_single_burst_read <= 1'b0; 
                    end
                end
            default:
                begin
                    mst_exestate  <= IDLE;
                end
        endcase
    end
end 


// burst_write_active signal is asserted when there is a burst write transaction
always @(posedge clk) begin
    if (rst_n == 0 ) begin
        burst_write_active <= 1'b0;
    end
    else if (start_single_burst_write) begin
        burst_write_active <= 1'b1;
    end
    else if (ifu_axi_bvalid && axi_bready) begin
        burst_write_active <= 0;
    end
end

// Check for last write completion.
always @(posedge clk) begin
    if (rst_n == 0 ) begin
        writes_done <= 1'b0;
    end
    else if (ifu_axi_bvalid && axi_bready) begin // only write transaction once
        writes_done <= 1'b1;
    end
    else begin
        writes_done <= 1'b0;
    end
end

// burst_read_active signal is asserted when there is a burst write transaction
always @(posedge clk) begin
    if (rst_n == 0 ) begin
        burst_read_active <= 1'b0;
    end
    else if (start_single_burst_read) begin
        burst_read_active <= 1'b1;
    end
    else if (ifu_axi_rvalid && axi_rready && ifu_axi_rlast) begin
        burst_read_active <= 0;
    end
end


// Check for last read completion.
always @(posedge clk) begin
    if (rst_n == 0 ) begin
        reads_done <= 1'b0;
    end
    else if (ifu_axi_rvalid && axi_rready && ifu_axi_rlast) begin
        reads_done <= 1'b1;
    end
    else begin
        reads_done <= 1'b0;
    end
end



endmodule

