debImport "-f" "../tb/tb.f"
nsMsgSelect -range {0-0}
nsMsgSelect -range {0 0-0}
nsMsgAction -tab cmpl -index {0 0}
nsMsgSelect -range {0 0-0}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 42 -pos 11 -win $_nTrace1
wvCreateWindow
wvOpenFile -win $_nWave2 -mul \
           {/home/myeda/project/hisoc/verification/tb_rvseed/sim/sim_out.fsdb} {/home/myeda/project/hisoc/verification/tb_hisoc/sim/tb_hisoc.fsdb} 
wvCloseFile -win $_nWave2
wvDisplayGridCount -win $srcDeselectAll -win $_nTrace1
debReload
debExit
ignalClose -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 \
           {/home/myeda/project/hisoc/verification/tb_hisoc/sim/sim_out.fsdb}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "inst_name" -line 45 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 1 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 0)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "rst_n" -line 19 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 18 -pos 1 -win $_nTrace1
srcSelect -signal "rst_n" -line 19 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomAll -win $_nWave2
wvZoomAll -win $_nWave2
wvZoom -win $_nWave2 0.000000 13347215.114613
wvZoom -win $_nWave2 0.000000 344197.524446
wvSetCursor -win $_nWave2 27368.141270 -snap {("G1" 2)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -signal "U_RVSEED. U_INST_MEM. mem_data" -line 71 -pos 1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvExpandBus -win $_nWave2 {("G1" 3)}
wvZoom -win $_nWave2 0.000000 59174.359504
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -signal "U_RVSEED. U_INST_MEM. mem_data" -line 71 -pos 1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -signal "U_RVSEED. U_INST_MEM. mem_data" -line 71 -pos 1
srcAction -pos 70 7 25 -win $_nTrace1 -name "U_RVSEED. U_INST_MEM. mem_data" \
          -ctrlKey off
srcHBSelect "TB_HISOC.U_RVSEED" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_axi_wdata" -line 328 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data" -line 318 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_DEEP" -line 318 -pos 1 -win $_nTrace1
srcAction -pos 317 21 6 -win $_nTrace1 -name "MEM_ADDR_DEEP" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data" -line 318 -pos 1 -win $_nTrace1
srcAction -pos 317 14 4 -win $_nTrace1 -name "mem_data" -ctrlKey off
srcBackwardHistory -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_DEEP" -line 318 -pos 1 -win $_nTrace1
srcSearchString "MEM_ADDR_DEEP" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {98 98 5 6 1 1}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_DEEP" -line 98 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
srcDeselectAll -win $_nTrace1
srcSelect -signal "ar_wrap_size" -line 116 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_awlen" -line 113 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_awready" -line 101 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_WIDTH" -line 97 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_DEEP" -line 98 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_WIDTH" -line 98 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_DEEP" -line 98 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_DEEP" -line 98 -pos 1 -win $_nTrace1
srcSearchString "MEM_ADDR_DEEP" -win $_nTrace1 -next -case
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data" -line 318 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_DEEP" -line 318 -pos 1 -win $_nTrace1
srcAction -pos 317 21 5 -win $_nTrace1 -name "MEM_ADDR_DEEP" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_DEEP" -line 318 -pos 1 -win $_nTrace1
srcAction -pos 317 21 5 -win $_nTrace1 -name "MEM_ADDR_DEEP" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_DEEP" -line 318 -pos 1 -win $_nTrace1
srcAction -pos 317 21 5 -win $_nTrace1 -name "MEM_ADDR_DEEP" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_DEEP" -line 318 -pos 1 -win $_nTrace1
srcSearchString "MEM_ADDR_DEEP" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {98 98 5 6 1 1}
srcDeselectAll -win $_nTrace1
debReload
wvSelectSignal -win $_nWave2 {( "G1" 10 )} 
wvSelectSignal -win $_nWave2 {( "G1" 3 4 5 6 7 8 9 10 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 2)}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "MEM_ADDR_WIDTH" -line 98 -pos 1 -win $_nTrace1
srcSearchString "MEM_ADDR_WIDTH" -win $_nTrace1 -next -case
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data" -line 318 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvExpandBus -win $_nWave2 {("G1" 3)}
wvScrollUp -win $_nWave2 2037
wvScrollDown -win $_nWave2 494
wvScrollDown -win $_nWave2 475
wvScrollUp -win $_nWave2 639
wvScrollDown -win $_nWave2 94
wvScrollUp -win $_nWave2 151
wvScrollUp -win $_nWave2 7
wvScrollUp -win $_nWave2 69
wvScrollUp -win $_nWave2 146
wvScrollUp -win $_nWave2 51
srcDeselectAll -win $_nTrace1
debReload
wvScrollDown -win $_nWave2 91
wvScrollDown -win $_nWave2 57
wvScrollDown -win $_nWave2 164
wvScrollDown -win $_nWave2 56
wvScrollUp -win $_nWave2 70
wvScrollDown -win $_nWave2 716
wvScrollUp -win $_nWave2 1014
wvSelectSignal -win $_nWave2 {( "G1" 2 )} 
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSelectAll -win $_nWave2
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
srcDeselectAll -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 16 -pos 1 -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 70 -pos 2 -win $_nTrace1
srcSelect -signal "rst_n" -line 71 -pos 2 -win $_nTrace1
srcSelect -signal "ifu_axi_awid" -line 73 -pos 2 -win $_nTrace1
srcSelect -toggle -signal "ifu_axi_awid" -line 73 -pos 2 -win $_nTrace1
srcSelect -signal "ifu_axi_arid" -line 97 -pos 2 -win $_nTrace1
srcSelect -signal "ifu_axi_arvalid" -line 107 -pos 2 -win $_nTrace1
srcSelect -signal "ifu_axi_arready" -line 108 -pos 2 -win $_nTrace1
srcSelect -signal "ifu_axi_araddr" -line 98 -pos 2 -win $_nTrace1
srcSelect -signal "ifu_axi_rid" -line 110 -pos 2 -win $_nTrace1
srcSelect -signal "ifu_axi_rdata" -line 111 -pos 2 -win $_nTrace1
srcSelect -signal "ifu_axi_rvalid" -line 114 -pos 2 -win $_nTrace1
srcSelect -signal "ifu_axi_rready" -line 115 -pos 2 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "ifu_axi_rlast" -line 113 -pos 2 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomAll -win $_nWave2
wvZoomAll -win $_nWave2
wvZoomAll -win $_nWave2
wvZoom -win $_nWave2 0.000000 15964316.117479
wvZoom -win $_nWave2 0.000000 480301.774308
wvSelectSignal -win $_nWave2 {( "G2" 6 )} 
wvSetCursor -win $_nWave2 129364.947808 -snap {("G2" 6)}
wvSelectSignal -win $_nWave2 {( "G2" 6 )} 
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ifu_axi_awburst" -line 128 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ifu_axi_rid" -line 161 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ifu_axi_rready" -line 166 -pos 1 -win $_nTrace1
wvSelectSignal -win $_nWave2 {( "G2" 6 )} 
wvSelectSignal -win $_nWave2 {( "G2" 4 )} 
wvSetCursor -win $_nWave2 116978.942167 -snap {("G2" 5)}
wvSetCursor -win $_nWave2 111474.050771 -snap {("G2" 5)}
srcActiveTrace "TB_HISOC.U_RVSEED.ifu_axi_arready" -win $_nTrace1 \
           -TraceByDConWave -TraceTime 110000 -TraceValue 1
srcBackwardHistory -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED" -win $_nTrace1
wvSelectSignal -win $_nWave2 {( "G2" 9 )} 
wvSelectSignal -win $_nWave2 {( "G2" 10 )} 
wvSelectSignal -win $_nWave2 {( "G2" 11 )} 
wvSelectSignal -win $_nWave2 {( "G2" 9 )} 
wvSelectSignal -win $_nWave2 {( "G2" 10 )} 
wvSelectSignal -win $_nWave2 {( "G2" 11 )} 
wvSetCursor -win $_nWave2 130397.114945 -snap {("G2" 6)}
wvSetCursor -win $_nWave2 130397.114945 -snap {("G2" 6)}
srcActiveTrace "TB_HISOC.U_RVSEED.ifu_axi_araddr\[31:0\]" -win $_nTrace1 \
           -TraceByDConWave -TraceTime 10000 -TraceValue \
           01000000000000000000000000000000
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_araddr" -line 149 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_araddr" -line 149 -pos 1 -win $_nTrace1
srcAction -pos 148 10 7 -win $_nTrace1 -name "axi_araddr" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "curr_pc" -line 331 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "curr_pc" -line 331 -pos 1 -win $_nTrace1
srcAction -pos 330 5 1 -win $_nTrace1 -name "curr_pc" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "next_pc" -line 32 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "next_pc" -line 32 -pos 1 -win $_nTrace1
srcAction -pos 31 5 4 -win $_nTrace1 -name "next_pc" -ctrlKey off
srcDeselectAll -win $_nTrace1
debReload
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 7654551.486250 -snap {("G2" 8)}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
verdiSetFont -font "Bitstream Vera Sans" -size "14"
verdiSetFont -monoFont "Fixed" -monoFontSize "20"
simSetInteractiveFsdbFile inter.fsdb
simSetSimMode on
srcSetPreference -filterPowerAwareInstruments off -profileTime off
tbvSetPreference -dynamicDumpMDA 1 -dynamicDumpStruct 1 -dynamicDumpSystemCStruct \
           1 -dynamicDumpSystemCPlain 1 -dynamicDumpSystemCFIFO 1
verdiSetFont -font "Bitstream Vera Sans" -size "16"
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "next_pc" -line 32 -pos 1 -win $_nTrace1
srcAction -pos 31 5 5 -win $_nTrace1 -name "next_pc" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "curr_pc" -line 32 -pos 1 -win $_nTrace1
wvSetCursor -win $_nWave2 85325.816639 -snap {("G2" 4)}
wvSetCursor -win $_nWave2 88078.262337 -snap {("G2" 5)}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
wvSetCursor -win $_nWave2 141750.953449 -snap {("G2" 9)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 147255.844845 -snap {("G2" 10)}
wvSetCursor -win $_nWave2 169275.410429 -snap {("G2" 9)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
srcDeselectAll -win $_nTrace1
