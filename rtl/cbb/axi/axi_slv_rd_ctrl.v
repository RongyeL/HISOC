// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : axi_slv_ctrl_rd.v
// Author        : Rongye
// Created On    : 2024-07-25 05:24
// Last Modified : 2024-08-01 07:51
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module AXI_SLV_RD_CTRL #(
    parameter AXI_RD_OST_NUM      = 8
)(
// Global
    input  wire                              clk,
    input  wire                              rst_n, 
// Read Interface
    output wire                              rd_req_en, 
    output wire [`AXI_ADDR_WIDTH       -1:0] rd_base_addr,

    input  wire                              rd_result_en, 
    input  wire [`AXI_DATA_WIDTH       -1:0] rd_result_data,
// AIX AR Channel
    input  wire                              axi_slv_arvalid,
    output wire                              axi_slv_arready,
    input  wire [`AXI_ID_WIDTH         -1:0] axi_slv_arid,
    input  wire [`AXI_ADDR_WIDTH       -1:0] axi_slv_araddr,
    input  wire [`AXI_LEN_WIDTH        -1:0] axi_slv_arlen,
    input  wire [`AXI_SIZE_WIDTH       -1:0] axi_slv_arsize,
    input  wire [`AXI_BURST_WIDTH      -1:0] axi_slv_arburst,
    input  wire                              axi_slv_arlock,
    input  wire [`AXI_CACHE_WIDTH      -1:0] axi_slv_arcache,
    input  wire [`AXI_PROT_WIDTH       -1:0] axi_slv_arprot,
    input  wire [`AXI_QOS_WIDTH        -1:0] axi_slv_arqos,
    input  wire [`AXI_REGION_WIDTH     -1:0] axi_slv_arregion,
// AIX R Channel
    output wire                              axi_slv_rvalid,
    input  wire                              axi_slv_rready,
    output wire [`AXI_ID_WIDTH         -1:0] axi_slv_rid,
    output wire [`AXI_DATA_WIDTH       -1:0] axi_slv_rdata,
    output wire [`AXI_RESP_WIDTH       -1:0] axi_slv_rresp,
    output wire                              axi_slv_rlast
);
localparam DLY      = 0.1;
localparam AXI_RD_OST_NUM_LOG2 = $clog2(AXI_RD_OST_NUM);
localparam ADDR_LSB = (`AXI_DATA_WIDTH/32)+ 1;  // word as gran
//--------------------------------------------------------------------------------
// Inner Signal
//--------------------------------------------------------------------------------
reg  [(AXI_RD_OST_NUM*(`AXI_LEN_WIDTH+1))     :0] read_index; // read beat count in a burst
reg  [(AXI_RD_OST_NUM*1                )    -1:0] burst_read_active; 
                                                 
reg  [(AXI_RD_OST_NUM*1                )    -1:0] axi_slv_rvalid_r;
                                                 
reg  [(AXI_RD_OST_NUM*`AXI_ID_WIDTH    )    -1:0] axi_slv_arid_r;
reg  [(AXI_RD_OST_NUM*`AXI_ADDR_WIDTH  )    -1:0] axi_slv_araddr_r;
reg  [(AXI_RD_OST_NUM*`AXI_LEN_WIDTH   )    -1:0] axi_slv_arlen_r;
reg  [(AXI_RD_OST_NUM*`AXI_SIZE_WIDTH  )    -1:0] axi_slv_arsize_r;
reg  [(AXI_RD_OST_NUM*`AXI_BURST_WIDTH )    -1:0] axi_slv_arburst_r;
reg  [(AXI_RD_OST_NUM*`AXI_LOCK_WIDTH  )    -1:0] axi_slv_arlock_r;
reg  [(AXI_RD_OST_NUM*`AXI_CACHE_WIDTH )    -1:0] axi_slv_arcache_r;
reg  [(AXI_RD_OST_NUM*`AXI_PROT_WIDTH  )    -1:0] axi_slv_arprot_r;
reg  [(AXI_RD_OST_NUM*`AXI_QOS_WIDTH   )    -1:0] axi_slv_arqos_r;
reg  [(AXI_RD_OST_NUM*`AXI_REGION_WIDTH)    -1:0] axi_slv_arregion_r;
                                                 
reg  [(AXI_RD_OST_NUM*`AXI_DATA_WIDTH  )    -1:0] axi_slv_rdata_r;
reg  [(AXI_RD_OST_NUM*`AXI_RESP_WIDTH  )    -1:0] axi_slv_rresp_r;

wire [(AXI_RD_OST_NUM*`AXI_ADDR_WIDTH  )    -1:0] ar_wrap_size;
wire [(AXI_RD_OST_NUM*1                )    -1:0] ar_wrap_en;
//--------------------------------------------------------------------------------
// Ost Ctrl
//--------------------------------------------------------------------------------
reg  [AXI_RD_OST_NUM_LOG2:0] ptr_set_r;
wire  [AXI_RD_OST_NUM_LOG2-1:0] ptr_set=ptr_set_r[AXI_RD_OST_NUM_LOG2-1:0];
wire                            wrap_set=ptr_set_r[AXI_RD_OST_NUM_LOG2];
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ptr_set_r <= #DLY 0;
    end
    else if (axi_slv_arvalid && axi_slv_arready) begin
        ptr_set_r <= #DLY ptr_set_r + 1;
    end
end
reg  [AXI_RD_OST_NUM_LOG2:0] ptr_send_r;
wire  [AXI_RD_OST_NUM_LOG2-1:0] ptr_send=ptr_send_r[AXI_RD_OST_NUM_LOG2-1:0];
wire                            wrap_send=ptr_send_r[AXI_RD_OST_NUM_LOG2];
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ptr_send_r <= #DLY 0;
    end
    else if (rd_req_en) begin
        ptr_send_r <= #DLY ptr_send_r + 1;
    end
end
reg  [AXI_RD_OST_NUM_LOG2:0] ptr_wait_r;
wire  [AXI_RD_OST_NUM_LOG2-1:0] ptr_wait=ptr_wait_r[AXI_RD_OST_NUM_LOG2-1:0];
wire                            wrap_wait=ptr_wait_r[AXI_RD_OST_NUM_LOG2];
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ptr_wait_r <= #DLY 0;
    end
    else if (rd_result_en) begin
        ptr_wait_r <= #DLY ptr_wait_r + 1;
    end
end
reg  [AXI_RD_OST_NUM_LOG2:0] ptr_clr_r;
wire  [AXI_RD_OST_NUM_LOG2-1:0] ptr_clr=ptr_clr_r[AXI_RD_OST_NUM_LOG2-1:0];
wire                            wrap_clr=ptr_clr_r[AXI_RD_OST_NUM_LOG2];
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ptr_clr_r <= #DLY 0;
    end
    else if (axi_slv_rvalid && axi_slv_rready && axi_slv_rlast) begin
        ptr_clr_r <= #DLY ptr_clr_r + 1;
    end
end

genvar ost_num;
generate 
for(ost_num=0;ost_num<AXI_RD_OST_NUM;ost_num=ost_num+1) begin : axi_buff_gen
//--------------------------------------------------------------------------------
// Register Payload 
//--------------------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_slv_arid_r    [(ost_num*`AXI_ID_WIDTH    ) +:`AXI_ID_WIDTH    ] <= #DLY {`AXI_ID_WIDTH{1'b0}};
        axi_slv_arlen_r   [(ost_num*`AXI_LEN_WIDTH   ) +:`AXI_LEN_WIDTH   ] <= #DLY {`AXI_LEN_WIDTH{1'b0}};
        axi_slv_arsize_r  [(ost_num*`AXI_SIZE_WIDTH  ) +:`AXI_SIZE_WIDTH  ] <= #DLY {`AXI_SIZE_WIDTH{1'b0}};
        axi_slv_arburst_r [(ost_num*`AXI_BURST_WIDTH ) +:`AXI_BURST_WIDTH ] <= #DLY {`AXI_BURST_WIDTH{1'b0}};
        axi_slv_arlock_r  [(ost_num*`AXI_LOCK_WIDTH  ) +:`AXI_LOCK_WIDTH  ] <= #DLY {`AXI_LOCK_WIDTH{1'b0}};
        axi_slv_arcache_r [(ost_num*`AXI_CACHE_WIDTH ) +:`AXI_CACHE_WIDTH ] <= #DLY {`AXI_CACHE_WIDTH{1'b0}};
        axi_slv_arprot_r  [(ost_num*`AXI_PROT_WIDTH  ) +:`AXI_PROT_WIDTH  ] <= #DLY {`AXI_PROT_WIDTH{1'b0}};
        axi_slv_arqos_r   [(ost_num*`AXI_QOS_WIDTH   ) +:`AXI_QOS_WIDTH   ] <= #DLY {`AXI_QOS_WIDTH{1'b0}};
        axi_slv_arregion_r[(ost_num*`AXI_REGION_WIDTH) +:`AXI_REGION_WIDTH] <= #DLY {`AXI_REGION_WIDTH{1'b0}};
    end
    else if (axi_slv_arvalid && axi_slv_arready & (ost_num==ptr_set)) begin
        axi_slv_arid_r    [(ost_num*`AXI_ID_WIDTH    ) +:`AXI_ID_WIDTH    ] <= #DLY axi_slv_arid;   
        axi_slv_arlen_r   [(ost_num*`AXI_LEN_WIDTH   ) +:`AXI_LEN_WIDTH   ] <= #DLY axi_slv_arlen;  
        axi_slv_arsize_r  [(ost_num*`AXI_SIZE_WIDTH  ) +:`AXI_SIZE_WIDTH  ] <= #DLY axi_slv_arsize; 
        axi_slv_arburst_r [(ost_num*`AXI_BURST_WIDTH ) +:`AXI_BURST_WIDTH ] <= #DLY axi_slv_arburst;
        axi_slv_arlock_r  [(ost_num*`AXI_LOCK_WIDTH  ) +:`AXI_LOCK_WIDTH  ] <= #DLY axi_slv_arlock; 
        axi_slv_arcache_r [(ost_num*`AXI_CACHE_WIDTH ) +:`AXI_CACHE_WIDTH ] <= #DLY axi_slv_arcache;
        axi_slv_arprot_r  [(ost_num*`AXI_PROT_WIDTH  ) +:`AXI_PROT_WIDTH  ] <= #DLY axi_slv_arprot; 
        axi_slv_arqos_r   [(ost_num*`AXI_QOS_WIDTH   ) +:`AXI_QOS_WIDTH   ] <= #DLY axi_slv_arqos; 
        axi_slv_arregion_r[(ost_num*`AXI_REGION_WIDTH) +:`AXI_REGION_WIDTH] <= #DLY axi_slv_arregion; 
    end
end
//--------------------------------------------------------------------------------
// State Ctrl
//--------------------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        burst_read_active[ost_num] <= #DLY 1'b0;
    end
    else if (axi_slv_arvalid && axi_slv_arready && ~burst_read_active[ost_num] & (ost_num==ptr_set)) begin
        burst_read_active[ost_num] <= #DLY 1'b1;
    end
    else if (axi_slv_rvalid && axi_slv_rready && axi_slv_rlast & (ost_num==axi_slv_rid)) begin
        burst_read_active[ost_num] <= #DLY 1'b0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_slv_rvalid_r[ost_num]  <= #DLY 1'b0;
    end
    else if (rd_result_en & (ost_num==ptr_wait)) begin
        axi_slv_rvalid_r[ost_num]  <= #DLY 1'b1;
    end
    else if (axi_slv_rvalid && axi_slv_rready & (ost_num==axi_slv_rid)) begin
        axi_slv_rvalid_r[ost_num]  <= #DLY 1'b0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_slv_rdata_r[(ost_num*`AXI_DATA_WIDTH    ) +:`AXI_DATA_WIDTH    ]  <= #DLY {`AXI_DATA_WIDTH{1'b0}};
    end
    else if (rd_result_en & (ost_num==ptr_wait)) begin
        axi_slv_rdata_r[(ost_num*`AXI_DATA_WIDTH    ) +:`AXI_DATA_WIDTH    ]  <= #DLY rd_result_data;
    end
end
//--------------------------------------------------------------------------------
// Burst Ctrl
//--------------------------------------------------------------------------------

assign ar_wrap_size[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH] = (`AXI_DATA_WIDTH/8 * (axi_slv_arlen_r[(ost_num*`AXI_LEN_WIDTH) +:`AXI_LEN_WIDTH]));
assign ar_wrap_en[ost_num] = ((axi_slv_araddr_r[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH] & ar_wrap_size[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH]) == ar_wrap_size[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH]) ? 1'b1: 1'b0;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        read_index[(ost_num*(`AXI_LEN_WIDTH+1)) +:(`AXI_LEN_WIDTH+1)] <= #DLY {(`AXI_LEN_WIDTH+1){1'b0}};
    end
    else if (axi_slv_arvalid && axi_slv_arready & (ost_num==ptr_set)) begin
        read_index[(ost_num*(`AXI_LEN_WIDTH+1)) +:(`AXI_LEN_WIDTH+1)] <= #DLY {(`AXI_LEN_WIDTH+1){1'b0}};
    end
    else if((read_index[(ost_num*(`AXI_LEN_WIDTH+1)) +:(`AXI_LEN_WIDTH+1)] <= axi_slv_arlen_r[(ost_num*`AXI_LEN_WIDTH) +:`AXI_LEN_WIDTH]) && rd_req_en & (ost_num==ptr_send)) begin
        read_index[(ost_num*(`AXI_LEN_WIDTH+1)) +:(`AXI_LEN_WIDTH+1)] <= #DLY read_index[(ost_num*(`AXI_LEN_WIDTH+1)) +:(`AXI_LEN_WIDTH+1)] + 1;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_slv_araddr_r[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH] <= #DLY {`AXI_ADDR_WIDTH{1'b0}};
    end
    else if (axi_slv_arvalid && axi_slv_arready && ~burst_read_active[ost_num] & (ost_num==ptr_set)) begin
        axi_slv_araddr_r[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH]  <= #DLY axi_slv_araddr;
    end
    else if((read_index[(ost_num*(`AXI_LEN_WIDTH+1)) +:(`AXI_LEN_WIDTH+1)] <= axi_slv_arlen_r[(ost_num*`AXI_LEN_WIDTH) +:`AXI_LEN_WIDTH]) && axi_slv_rvalid && axi_slv_rready & (ost_num==axi_slv_rid)) begin
        case (axi_slv_arburst_r[(ost_num*`AXI_BURST_WIDTH) +:`AXI_BURST_WIDTH])
            // 2'b00: // fixed burst
                // begin
                    // axi_slv_araddr_r[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH] <= #DLY axi_slv_araddr_r[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH];
                // end
            // 2'b01: //incremental burst #TODO
                // begin
                    // axi_slv_araddr_r[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH] <= #DLY axi_slv_araddr_r[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH];
                    // // axi_slv_araddr_r[`AXI_ADDR_WIDTH-1:ADDR_LSB] <= #DLY axi_slv_araddr_r[`AXI_ADDR_WIDTH-1:ADDR_LSB]+1;
                    // // axi_slv_araddr_r[ADDR_LSB-1:0] <= #DLY {ADDR_LSB{1'b0}};
                // end
            // 2'b10: //Wrapping burst #TODO
                // begin
                // // if (ar_wrap_en) begin
                    // // axi_slv_araddr_r <= #DLY (axi_slv_araddr_r - ar_wrap_size);
                // // end
                // // else begin
                    // // axi_slv_araddr_r[`AXI_ADDR_WIDTH-1:ADDR_LSB] <= #DLY axi_slv_araddr_r[`AXI_ADDR_WIDTH-1:ADDR_LSB]+1;
                    // // axi_slv_araddr_r[ADDR_LSB-1:0] <= #DLY {ADDR_LSB{1'b0}};
                // // end
                // end
            default: 
                begin
                    axi_slv_araddr_r[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH] <= #DLY axi_slv_araddr_r[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH];
                end
        endcase
    end
end

//--------------------------------------------------------------------------------
// Resp Ctrl
//--------------------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin //TODO
    if (~rst_n) begin
        axi_slv_rresp_r[(ost_num*`AXI_RESP_WIDTH) +:`AXI_RESP_WIDTH] <= #DLY {`AXI_RESP_WIDTH{1'b0}};
    end
    else if (axi_slv_arvalid && axi_slv_arready & (ost_num==ptr_set)) begin
        axi_slv_rresp_r[(ost_num*`AXI_RESP_WIDTH) +:`AXI_RESP_WIDTH] <= #DLY `AXI_RESP_WIDTH'b0;
    end
end
end
endgenerate
//--------------------------------------------------------------------------------
// Output Signal
//--------------------------------------------------------------------------------
assign axi_slv_arready = ~((wrap_set != wrap_clr) & (ptr_set == ptr_clr));

assign axi_slv_rvalid  = burst_read_active[ptr_clr] && axi_slv_rvalid_r[ptr_clr];
assign axi_slv_rlast   = burst_read_active[ptr_clr] && axi_slv_rvalid && axi_slv_rready && (read_index[(ptr_clr*(`AXI_LEN_WIDTH+1)) +:(`AXI_LEN_WIDTH+1)] == axi_slv_arlen_r[(ptr_clr*`AXI_LEN_WIDTH) +:`AXI_LEN_WIDTH]+1);
assign axi_slv_rdata   = axi_slv_rdata_r[(ptr_clr*`AXI_DATA_WIDTH) +:`AXI_DATA_WIDTH];
assign axi_slv_rid     = axi_slv_arid_r[(ptr_clr*`AXI_ID_WIDTH) +:`AXI_ID_WIDTH];

assign rd_req_en       = burst_read_active[ptr_send] && (read_index[(ptr_send*(`AXI_LEN_WIDTH+1)) +:(`AXI_LEN_WIDTH+1)] <= axi_slv_arlen_r[(ptr_send*`AXI_LEN_WIDTH) +:`AXI_LEN_WIDTH]);
assign rd_base_addr    = axi_slv_araddr_r[(ptr_send*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH];

endmodule
