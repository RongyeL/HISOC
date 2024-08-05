// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : m_axi.v
// Author        : Rongye
// Created On    : 2022-12-25 03:08
// Last Modified : 2024-08-05 08:32
// ---------------------------------------------------------------------------------
// Description   :
//
//
// -FHDR----------------------------------------------------------------------------
module IFU(
// global 
    input  wire                              clk,
    input  wire                              rst_n,          
    input  wire                              enable,          

    input  wire [`BRAN_WIDTH           -1:0] idu_branch,     
    input  wire                              exu_zero,       
    input  wire [`JUMP_WIDTH           -1:0] idu_jump,       
    input  wire [`CPU_WIDTH            -1:0] idu_imm,       
    input  wire [`CPU_WIDTH            -1:0] reg1_rdata,       


// AR channel
    output wire                              ifu_arvalid,
    input  wire                              ifu_arready,
    output wire [`AXI_ID_WIDTH         -1:0] ifu_arid,
    output wire [`AXI_ADDR_WIDTH       -1:0] ifu_araddr,
    output wire [`AXI_LEN_WIDTH        -1:0] ifu_arlen,
    output wire [`AXI_SIZE_WIDTH       -1:0] ifu_arsize,
    output wire [`AXI_BURST_WIDTH      -1:0] ifu_arburst,
    output wire                              ifu_arlock,
    output wire [`AXI_CACHE_WIDTH      -1:0] ifu_arcache,
    output wire [`AXI_PROT_WIDTH       -1:0] ifu_arprot,
    output wire [`AXI_QOS_WIDTH        -1:0] ifu_arqos,
    output wire [`AXI_REGION_WIDTH     -1:0] ifu_arregion,
// R channel
    input  wire                              ifu_rvalid,
    output wire                              ifu_rready,
    input  wire [`AXI_ID_WIDTH         -1:0] ifu_rid,
    input  wire [`AXI_DATA_WIDTH       -1:0] ifu_rdata,
    input  wire [`AXI_RESP_WIDTH       -1:0] ifu_rresp,
    input  wire                              ifu_rlast,

    output wire                              ifu2idu_en,
    output wire [`CPU_WIDTH            -1:0] ifu2idu_pc,
    output wire [`CPU_WIDTH            -1:0] ifu2idu_inst,
    input  wire [`CPU_WIDTH            -1:0] idu_pc
);

localparam DLY = 0.1;

wire                          branch_active = ((idu_branch == `BRAN_TYPE_A) &&  exu_zero) 
                                            | ((idu_branch == `BRAN_TYPE_B) && ~exu_zero); 
reg  [`CPU_WIDTH        -1:0] curr_pc;    
reg  [`CPU_WIDTH        -1:0] next_pc;    
reg  [`CPU_WIDTH        -1:0] if_pc;    

wire                          rd_req_en;
wire                          rd_block_en;
wire [`AXI_ADDR_WIDTH   -1:0] rd_base_addr = `INST_MEM_BASE_ADDR + if_pc;
wire [`AXI_LEN_WIDTH    -1:0] rd_len       = `AXI_LEN_WIDTH'h0; // len = 1
wire [`AXI_SIZE_WIDTH   -1:0] rd_size      = `AXI_SIZE_4_BYTE;
wire [`AXI_BURST_WIDTH  -1:0] rd_burst     = `AXI_BURTS_INCR;
wire [`AXI_LOCK_WIDTH   -1:0] rd_lock      = `AXI_LOCK_WIDTH'b0;
wire [`AXI_CACHE_WIDTH  -1:0] rd_cache     = `AXI_CACHE_WIDTH'b0000;
wire [`AXI_PROT_WIDTH   -1:0] rd_prot      = `AXI_PROT_WIDTH'b000;
wire [`AXI_QOS_WIDTH    -1:0] rd_qos       = `AXI_QOS_WIDTH'h0;
wire [`AXI_REGION_WIDTH -1:0] rd_region    = `AXI_REGION_WIDTH'h0;

wire                          rd_result_en; 
wire [`AXI_DATA_WIDTH   -1:0] rd_result_data;

reg  [`CPU_WIDTH        -1:0] ifu2idu_pc_r;

wire                          pc_full; 
wire                          pc_empty; 
wire [`PC_FIFO_DATA_W -1:0]   pc_pop_dat;
wire                          pc_pop_dat_vld; 
wire [`PC_FIFO_DEEP_W   :0]   pc_fifo_num;

wire                          inst_full; 
wire                          inst_empty; 
wire [`INST_FIFO_DATA_W -1:0] inst_pop_dat;
wire                          inst_pop_dat_vld; 
wire [`INST_FIFO_DEEP_W   :0] inst_fifo_num;
// PC REGISTER 
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        curr_pc <= #DLY `CPU_WIDTH'b0;
    end
    else if (enable) begin
        if (branch_active) begin // beq/bge/bgeu : idu_branch if the exu_zero flag is high.// bne/blt/bltu : idu_branch if the exu_zero flag is low.
            curr_pc <= #DLY idu_pc + idu_imm;
        end
        else if (idu_jump == `JUMP_JAL) begin           // jal 
            curr_pc <= #DLY idu_pc + idu_imm;
        end
        else if (idu_jump == `JUMP_JALR) begin           // jalr 
            curr_pc <= #DLY reg1_rdata + idu_imm;
        end
        else if (ifu2idu_en) begin
            curr_pc <= #DLY curr_pc + `CPU_WIDTH'h4;      // pc + 4  
        end
    end
end 
// INST FETCH PC REGISTER 
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        if_pc <= #DLY `CPU_WIDTH'b0;
    end
    else if (enable) begin
        if (branch_active) begin // beq/bge/bgeu : idu_branch if the exu_zero flag is high.// bne/blt/bltu : idu_branch if the exu_zero flag is low.
            if_pc <= #DLY idu_pc + idu_imm;
        end
        else if (idu_jump == `JUMP_JAL) begin           // jal 
            if_pc <= #DLY idu_pc + idu_imm;
        end
        else if (idu_jump == `JUMP_JALR) begin           // jalr 
            if_pc <= #DLY reg1_rdata + idu_imm;
        end
        else if (rd_req_en) begin
            if_pc <= #DLY if_pc + `CPU_WIDTH'h4;      // pc + 4  
        end
    end
end 
// AXI_MST_RD_CTRL INST
assign rd_req_en = enable & ~rd_block_en & ~pc_full;
AXI_MST_RD_CTRL #(
    .AXI_RD_OST_NUM     (8                  )
)U_AXI_MST_RD_CTRL(
    .clk                (clk                ),
    .rst_n              (rst_n              ), 
                        
    .rd_block_en        (rd_block_en        ), 
    .rd_req_en          (rd_req_en          ), 
    .rd_base_addr       (rd_base_addr       ),
    .rd_len             (rd_len             ),
    .rd_size            (rd_size            ),
    .rd_burst           (rd_burst           ),
    .rd_lock            (rd_lock            ),
    .rd_cache           (rd_cache           ),
    .rd_prot            (rd_prot            ),
    .rd_qos             (rd_qos             ),
    .rd_region          (rd_region          ),

    .rd_result_en       (rd_result_en       ), 
    .rd_result_data     (rd_result_data     ),
                        
    .axi_mst_arvalid    (ifu_arvalid    ),
    .axi_mst_arready    (ifu_arready    ),
    .axi_mst_arid       (ifu_arid       ),
    .axi_mst_araddr     (ifu_araddr     ),
    .axi_mst_arlen      (ifu_arlen      ),
    .axi_mst_arsize     (ifu_arsize     ),
    .axi_mst_arburst    (ifu_arburst    ),
    .axi_mst_arlock     (ifu_arlock     ),
    .axi_mst_arcache    (ifu_arcache    ),
    .axi_mst_arprot     (ifu_arprot     ),
    .axi_mst_arqos      (ifu_arqos      ),
    .axi_mst_arregion   (ifu_arregion   ),
                        
    .axi_mst_rvalid     (ifu_rvalid     ),
    .axi_mst_rready     (ifu_rready     ),
    .axi_mst_rid        (ifu_rid        ),
    .axi_mst_rdata      (ifu_rdata      ),     
    .axi_mst_rresp      (ifu_rresp      ),
    .axi_mst_rlast      (ifu_rlast      )
);
SYNC_FIFO #(
    .FIFO_DEEP   (`PC_FIFO_DEEP   ),
    .FIFO_DEEP_W (`PC_FIFO_DEEP_W ),
    .FIFO_DATA_W (`PC_FIFO_DATA_W )
) U_PC_FIFO 
(
    .clk                (clk                ),
    .rst_n              (rst_n              ),

    .push               (rd_req_en          ),
    .push_dat           (if_pc              ),

    .pop                (~inst_empty        ),
    .pop_dat            (pc_pop_dat         ),
    .pop_dat_vld        (pc_pop_dat_vld     ),

    .full               (pc_full            ),
    .empty              (pc_empty           ),
    .fifo_num           (pc_fifo_num        )
);
SYNC_FIFO #(
    .FIFO_DEEP   (`INST_FIFO_DEEP   ),
    .FIFO_DEEP_W (`INST_FIFO_DEEP_W ),
    .FIFO_DATA_W (`INST_FIFO_DATA_W )
) U_INST_FIFO 
(
    .clk                (clk                ),
    .rst_n              (rst_n              ),

    .push               (rd_result_en       ),
    .push_dat           (rd_result_data     ),

    .pop                (~inst_empty        ),
    .pop_dat            (inst_pop_dat       ),
    .pop_dat_vld        (inst_pop_dat_vld   ),

    .full               (inst_full          ),
    .empty              (inst_empty         ),
    .fifo_num           (inst_fifo_num      )
);
// ---------------------------------------------------------------------------------
// IFU CTRL
// ---------------------------------------------------------------------------------
assign ifu2idu_en   = (pc_pop_dat_vld & (curr_pc == pc_pop_dat)) & ~branch_active;
assign ifu2idu_pc   = pc_pop_dat;
assign ifu2idu_inst = {`INST_FIFO_DATA_W{inst_pop_dat_vld}} & inst_pop_dat;

endmodule

