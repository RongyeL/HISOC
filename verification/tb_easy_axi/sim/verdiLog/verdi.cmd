debImport "-f" "../tb/tb.f"
wvCreateWindow
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 \
           {/home/myeda/project/hisoc/verification/tb_easy_axi/sim/easy_axi_tb.fsdb}
srcDeselectAll -win $_nTrace1
srcSelect -signal "rst_n" -line 19 -pos 1 -win $_nTrace1
srcSelect -signal "clk" -line 18 -pos 1 -win $_nTrace1
srcSelect -signal "txn_start" -line 20 -pos 1 -win $_nTrace1
srcSelect -signal "txn_type" -line 21 -pos 1 -win $_nTrace1
srcSelect -signal "txn_done" -line 22 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomAll -win $_nWave2
debExit
