# 50 MHz clock (clk_50) coming from PIN_P11
create_clock -name clk_50 -period 20.000 [get_ports clk_50]
derive_pll_clocks
derive_clock_uncertainty

set_clock_groups -asynchronous \
	-group [get_clocks {clk_50}] \
	-group [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}]

# Magnetic Encoder Requirements, Data read 15ns after rising edge
create_generated_clock -name mag_enc_clk -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] [get_ports mag_clk_out]
set_input_delay -clock mag_enc_clk -max 15.5 [get_ports d_in]
set_input_delay -clock mag_enc_clk -min 0.5 [get_ports d_in]

# Handle async reset
set_false_path -from [get_ports reset]

# CRC is a multicycle path
set_multicycle_path -setup -from [get_cells {me|checksum|*}] -to [get_cells {me|checksum|*}] 2
set_multicycle_path -hold -from [get_cells {me|checksum|*}] -to [get_cells {me|checksum|*}] 1
