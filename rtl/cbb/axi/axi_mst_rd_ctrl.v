// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2024 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : axi_mst_ctrl_rd.v
// Author        : Rongye
// Created On    : 2024-07-25 05:24
// Last Modified : 2024-08-01 07:44
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
module AXI_MST_RD_CTRL #(
    parameter AXI_RD_OST_NUM      = 8
)(
// Global
    input  wire                              clk,
    input  wire                              rst_n, 
// Read Interface
    output wire                              rd_block_en, 
    input  wire                              rd_req_en, 
    input  wire [`AXI_ADDR_WIDTH       -1:0] rd_base_addr,
    input  wire [`AXI_LEN_WIDTH        -1:0] rd_len,
    input  wire [`AXI_SIZE_WIDTH       -1:0] rd_size,
    input  wire [`AXI_BURST_WIDTH      -1:0] rd_burst,
    input  wire [`AXI_LOCK_WIDTH       -1:0] rd_lock,
    input  wire [`AXI_CACHE_WIDTH      -1:0] rd_cache,
    input  wire [`AXI_PROT_WIDTH       -1:0] rd_prot,
    input  wire [`AXI_QOS_WIDTH        -1:0] rd_qos,
    input  wire [`AXI_REGION_WIDTH     -1:0] rd_region,

    output wire                              rd_result_en, 
    output wire [`AXI_DATA_WIDTH       -1:0] rd_result_data,
// AXI AR Channel
    output wire                              axi_mst_arvalid,
    input  wire                              axi_mst_arready,
    output wire [`AXI_ID_WIDTH         -1:0] axi_mst_arid,
    output wire [`AXI_ADDR_WIDTH       -1:0] axi_mst_araddr,
    output wire [`AXI_LEN_WIDTH        -1:0] axi_mst_arlen,
    output wire [`AXI_SIZE_WIDTH       -1:0] axi_mst_arsize,
    output wire [`AXI_BURST_WIDTH      -1:0] axi_mst_arburst,
    output wire [`AXI_LOCK_WIDTH       -1:0] axi_mst_arlock,
    output wire [`AXI_CACHE_WIDTH      -1:0] axi_mst_arcache,
    output wire [`AXI_PROT_WIDTH       -1:0] axi_mst_arprot,
    output wire [`AXI_QOS_WIDTH        -1:0] axi_mst_arqos,
    output wire [`AXI_REGION_WIDTH     -1:0] axi_mst_arregion,
// AXI R Channel
    input  wire                              axi_mst_rvalid,
    output wire                              axi_mst_rready,
    input  wire [`AXI_ID_WIDTH         -1:0] axi_mst_rid,
    input  wire [`AXI_DATA_WIDTH       -1:0] axi_mst_rdata,
    input  wire [`AXI_RESP_WIDTH       -1:0] axi_mst_rresp,
    input  wire                              axi_mst_rlast
);
localparam DLY                 = 0.1;
localparam AXI_RD_OST_NUM_LOG2 = $clog2(AXI_RD_OST_NUM);
//--------------------------------------------------------------------------------
// Inner Signal
//--------------------------------------------------------------------------------
reg  [(AXI_RD_OST_NUM*(`AXI_LEN_WIDTH+1))     :0] read_index; // read beat count in a burst
reg  [(AXI_RD_OST_NUM*1                )    -1:0] burst_read_active;

reg  [(AXI_RD_OST_NUM*1                )    -1:0] axi_mst_arvalid_r;

reg  [(AXI_RD_OST_NUM*`AXI_ID_WIDTH    )    -1:0] axi_mst_arid_r;
reg  [(AXI_RD_OST_NUM*`AXI_ADDR_WIDTH  )    -1:0] axi_mst_araddr_r;
reg  [(AXI_RD_OST_NUM*`AXI_LEN_WIDTH   )    -1:0] axi_mst_arlen_r;
reg  [(AXI_RD_OST_NUM*`AXI_SIZE_WIDTH  )    -1:0] axi_mst_arsize_r;
reg  [(AXI_RD_OST_NUM*`AXI_BURST_WIDTH )    -1:0] axi_mst_arburst_r;
reg  [(AXI_RD_OST_NUM*`AXI_LOCK_WIDTH  )    -1:0] axi_mst_arlock_r;
reg  [(AXI_RD_OST_NUM*`AXI_CACHE_WIDTH )    -1:0] axi_mst_arcache_r;
reg  [(AXI_RD_OST_NUM*`AXI_PROT_WIDTH  )    -1:0] axi_mst_arprot_r;
reg  [(AXI_RD_OST_NUM*`AXI_QOS_WIDTH   )    -1:0] axi_mst_arqos_r;
reg  [(AXI_RD_OST_NUM*`AXI_REGION_WIDTH)    -1:0] axi_mst_arregion_r;


reg  [(AXI_RD_OST_NUM*`AXI_RESP_WIDTH  )    -1:0] axi_mst_rresp_r;

reg  [(AXI_RD_OST_NUM*1                )    -1:0] read_resp_error_r;
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
    else if (rd_req_en) begin
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
    else if (axi_mst_arvalid && axi_mst_arready) begin
        ptr_send_r <= #DLY ptr_send_r + 1;
    end
end
reg  [AXI_RD_OST_NUM_LOG2:0] ptr_clr_r;
wire  [AXI_RD_OST_NUM_LOG2-1:0] ptr_clr=ptr_clr_r[AXI_RD_OST_NUM_LOG2-1:0];
wire                            wrap_clr=ptr_clr_r[AXI_RD_OST_NUM_LOG2];
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ptr_clr_r <= #DLY 0;
    end
    else if (rd_result_en) begin
        ptr_clr_r <= #DLY ptr_clr_r + 1;
    end
end
assign rd_block_en = (wrap_set != wrap_clr) & (ptr_set == ptr_clr);

genvar ost_num;
generate 
for(ost_num=0;ost_num<AXI_RD_OST_NUM;ost_num=ost_num+1) begin : axi_buff_gen
//--------------------------------------------------------------------------------
// Register Payload 
//--------------------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_mst_arid_r     [(ost_num*`AXI_ID_WIDTH    ) +:`AXI_ID_WIDTH    ] <= #DLY {`AXI_ID_WIDTH{1'b0}};
        axi_mst_arlen_r    [(ost_num*`AXI_LEN_WIDTH   ) +:`AXI_LEN_WIDTH   ] <= #DLY {`AXI_LEN_WIDTH{1'b0}};
        axi_mst_arsize_r   [(ost_num*`AXI_SIZE_WIDTH  ) +:`AXI_SIZE_WIDTH  ] <= #DLY {`AXI_SIZE_WIDTH{1'b0}};
        axi_mst_arburst_r  [(ost_num*`AXI_BURST_WIDTH ) +:`AXI_BURST_WIDTH ] <= #DLY {`AXI_BURST_WIDTH{1'b0}};
        axi_mst_arlock_r   [(ost_num*`AXI_LOCK_WIDTH  ) +:`AXI_LOCK_WIDTH  ] <= #DLY {`AXI_LOCK_WIDTH{1'b0}};
        axi_mst_arcache_r  [(ost_num*`AXI_CACHE_WIDTH ) +:`AXI_CACHE_WIDTH ] <= #DLY {`AXI_CACHE_WIDTH{1'b0}};
        axi_mst_arprot_r   [(ost_num*`AXI_PROT_WIDTH  ) +:`AXI_PROT_WIDTH  ] <= #DLY {`AXI_PROT_WIDTH{1'b0}};
        axi_mst_arqos_r    [(ost_num*`AXI_QOS_WIDTH   ) +:`AXI_QOS_WIDTH   ] <= #DLY {`AXI_QOS_WIDTH{1'b0}};
        axi_mst_arregion_r [(ost_num*`AXI_REGION_WIDTH) +:`AXI_REGION_WIDTH] <= #DLY {`AXI_REGION_WIDTH{1'b0}};
    end
    else if (rd_req_en & (ost_num==ptr_set)) begin
        axi_mst_arid_r     [(ost_num*`AXI_ID_WIDTH    ) +:`AXI_ID_WIDTH    ] <= #DLY ptr_set;   
        axi_mst_arlen_r    [(ost_num*`AXI_LEN_WIDTH   ) +:`AXI_LEN_WIDTH   ] <= #DLY rd_len;   // len=0
        axi_mst_arsize_r   [(ost_num*`AXI_SIZE_WIDTH  ) +:`AXI_SIZE_WIDTH  ] <= #DLY rd_size; 
        axi_mst_arburst_r  [(ost_num*`AXI_BURST_WIDTH ) +:`AXI_BURST_WIDTH ] <= #DLY rd_burst;
        axi_mst_arlock_r   [(ost_num*`AXI_LOCK_WIDTH  ) +:`AXI_LOCK_WIDTH  ] <= #DLY rd_lock; 
        axi_mst_arcache_r  [(ost_num*`AXI_CACHE_WIDTH ) +:`AXI_CACHE_WIDTH ] <= #DLY rd_cache;
        axi_mst_arprot_r   [(ost_num*`AXI_PROT_WIDTH  ) +:`AXI_PROT_WIDTH  ] <= #DLY rd_prot; 
        axi_mst_arqos_r    [(ost_num*`AXI_QOS_WIDTH   ) +:`AXI_QOS_WIDTH   ] <= #DLY rd_qos; 
        axi_mst_arregion_r [(ost_num*`AXI_REGION_WIDTH) +:`AXI_REGION_WIDTH] <= #DLY rd_region; 
    end
end
//--------------------------------------------------------------------------------
// State Ctrl
//--------------------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        burst_read_active[ost_num] <= #DLY 1'b0;
    end
    else if (rd_req_en & (ost_num==ptr_set)) begin
        burst_read_active[ost_num] <= #DLY 1'b1;
    end
    else if (axi_mst_rvalid && axi_mst_rready && axi_mst_rlast & (ost_num==axi_mst_rid)) begin
        burst_read_active[ost_num] <= #DLY 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        read_index[(ost_num*(`AXI_LEN_WIDTH+1)) +:(`AXI_LEN_WIDTH+1)] <= #DLY {(`AXI_LEN_WIDTH+1){1'b0}};
    end
    else if(rd_req_en) begin
        read_index[(ost_num*(`AXI_LEN_WIDTH+1)) +:(`AXI_LEN_WIDTH+1)] <= #DLY {(`AXI_LEN_WIDTH+1){1'b0}};
    end
    else if (axi_mst_rvalid && axi_mst_rready && (read_index != axi_mst_arlen_r) & (ost_num==axi_mst_rid)) begin
        read_index[(ost_num*(`AXI_LEN_WIDTH+1)) +:(`AXI_LEN_WIDTH+1)] <= #DLY read_index + `AXI_LEN_WIDTH'b1;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_mst_araddr_r[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH] <= #DLY {`AXI_ADDR_WIDTH{1'b0}};
    end
    else if (rd_req_en & (ost_num==ptr_set)) begin
        axi_mst_araddr_r[(ost_num*`AXI_ADDR_WIDTH) +:`AXI_ADDR_WIDTH] <= #DLY rd_base_addr;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        axi_mst_arvalid_r[ost_num]  <= #DLY 1'b0;
    end
    else if (rd_req_en & (ost_num==ptr_set)) begin
        axi_mst_arvalid_r[ost_num]  <= #DLY 1'b1;
    end
    else if (axi_mst_arvalid && axi_mst_arready & (ost_num==axi_mst_arid)) begin
        axi_mst_arvalid_r[ost_num]  <= #DLY 1'b0;
    end
end
//--------------------------------------------------------------------------------
// Resp Ctrl
//--------------------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        read_resp_error_r[ost_num] <= #DLY 1'b0;
    end
    else if(rd_req_en) begin
        read_resp_error_r[ost_num] <= #DLY 1'b0;
    end
    else if (axi_mst_rvalid && axi_mst_rready & (ost_num==axi_mst_rid)) begin
        read_resp_error_r[ost_num] <= #DLY read_resp_error_r | axi_mst_rresp[1];
    end
end

end
endgenerate
//--------------------------------------------------------------------------------
// Output Signal
//--------------------------------------------------------------------------------
assign axi_mst_arvalid  = burst_read_active[ptr_send] && axi_mst_arvalid_r[ptr_send];

assign axi_mst_arid     = axi_mst_arid_r    [(ptr_send*`AXI_ID_WIDTH     ) +:`AXI_ID_WIDTH     ];
assign axi_mst_arlen    = axi_mst_arlen_r   [(ptr_send*`AXI_LEN_WIDTH    ) +:`AXI_LEN_WIDTH    ];
assign axi_mst_arsize   = axi_mst_arsize_r  [(ptr_send*`AXI_SIZE_WIDTH   ) +:`AXI_SIZE_WIDTH   ];
assign axi_mst_arburst  = axi_mst_arburst_r [(ptr_send*`AXI_BURST_WIDTH  ) +:`AXI_BURST_WIDTH  ];
assign axi_mst_arlock   = axi_mst_arlock_r  [(ptr_send*`AXI_LOCK_WIDTH   ) +:`AXI_LOCK_WIDTH   ];
assign axi_mst_arcache  = axi_mst_arcache_r [(ptr_send*`AXI_CACHE_WIDTH  ) +:`AXI_CACHE_WIDTH  ];
assign axi_mst_arprot   = axi_mst_arprot_r  [(ptr_send*`AXI_PROT_WIDTH   ) +:`AXI_PROT_WIDTH   ];
assign axi_mst_arqos    = axi_mst_arqos_r   [(ptr_send*`AXI_QOS_WIDTH    ) +:`AXI_QOS_WIDTH    ];
assign axi_mst_arregion = axi_mst_arregion_r[(ptr_send*`AXI_REGION_WIDTH ) +:`AXI_REGION_WIDTH ];
assign axi_mst_araddr   = axi_mst_araddr_r  [(ptr_send*`AXI_ADDR_WIDTH   ) +:`AXI_ADDR_WIDTH   ];

assign axi_mst_rready   = 1'b1;

assign rd_result_en     = axi_mst_rvalid && axi_mst_rready && axi_mst_rlast;
assign rd_result_data   = axi_mst_rdata;

endmodule
