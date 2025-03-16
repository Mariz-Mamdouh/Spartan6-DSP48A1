vlib work
vlog DSP48A1.v DSP48A1_tb.v
vsim -voptargs=+acc work.DSP48A1_tb
add wave -position insertpoint  \
sim:/DSP48A1_tb/A \
sim:/DSP48A1_tb/B \
sim:/DSP48A1_tb/D \
sim:/DSP48A1_tb/BCIN \
sim:/DSP48A1_tb/C \
sim:/DSP48A1_tb/PCIN \
sim:/DSP48A1_tb/CLK \
sim:/DSP48A1_tb/CARRYIN \
sim:/DSP48A1_tb/OPMODE \
sim:/DSP48A1_tb/BCOUT \
sim:/DSP48A1_tb/PCOUT \
sim:/DSP48A1_tb/P \
sim:/DSP48A1_tb/M \
sim:/DSP48A1_tb/CARRYOUT \
sim:/DSP48A1_tb/CARRYOUTF
add wave -position insertpoint  \
sim:/DSP48A1_tb/DUT/outA0_reg \
sim:/DSP48A1_tb/DUT/outB0_reg \
sim:/DSP48A1_tb/DUT/outA1_reg \
sim:/DSP48A1_tb/DUT/outB1_reg \
sim:/DSP48A1_tb/DUT/outD_reg \
sim:/DSP48A1_tb/DUT/outC_reg \
sim:/DSP48A1_tb/DUT/Pre_addSub_out \
sim:/DSP48A1_tb/DUT/outM_reg \
sim:/DSP48A1_tb/DUT/CIN_reg \
sim:/DSP48A1_tb/DUT/outX_mux \
sim:/DSP48A1_tb/DUT/outZ_mux \
sim:/DSP48A1_tb/DUT/Post_addSub_out
run -all