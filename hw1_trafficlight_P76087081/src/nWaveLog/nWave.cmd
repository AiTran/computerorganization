wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/home/Ai/Computer_Organization/Computer_Organization/hw1_trafficlight/F740XXXXX/src/triffic_light.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/traffic_light_tb"
wvGetSignalSetScope -win $_nWave1 "/traffic_light_tb/ul"
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/traffic_light_tb/ul/G} \
{/traffic_light_tb/ul/R} \
{/traffic_light_tb/ul/Y} \
{/traffic_light_tb/ul/check} \
{/traffic_light_tb/ul/clk} \
{/traffic_light_tb/ul/counter\[9:0\]} \
{/traffic_light_tb/ul/next_state\[3:0\]} \
{/traffic_light_tb/ul/pass} \
{/traffic_light_tb/ul/rst} \
{/traffic_light_tb/ul/state\[3:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 )} 
wvSetPosition -win $_nWave1 {("G1" 10)}
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSetRadix -win $_nWave1 -format UDec
wvSetCursor -win $_nWave1 2756.569682 -snap {("G1" 6)}
wvExit
