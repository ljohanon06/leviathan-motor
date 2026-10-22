# 50 MHz clock (clk_50) coming from PIN_P11
create_clock -name clk_50 -period 20.000 [get_ports clk_50]
derive_pll_clocks

# 60 MHz clock (ft232_clk) coming from FT232H
create_clock -name ft232_clk -period 16.666 [get_ports ft232_clk]

set_clock_groups -asynchronous \
	-group [get_clocks {clk_50}] \
	-group [get_clocks {ft232_clk}] \
	-group [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}]

# Magnetic Encoder Requirements, Data read 15ns after rising edge
create_generated_clock -name mag_enc_clk -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] [get_ports mag_clk_out]
set_input_delay -clock mag_enc_clk -max 15.5 [get_ports d_in]
set_input_delay -clock mag_enc_clk -min 0.5 [get_ports d_in]

# FT232H Requirements, Setup time of 7.5ns for wr, data, Setup time of 9ns for txe
set_output_delay -clock ft232_clk -max 7.5 [get_ports {wr ft232_data[*]}]
set_output_delay -clock ft232_clk -min 0 [get_ports {wr ft232_data[*]}]
set_input_delay -clock ft232_clk -max 9 [get_ports txe]
set_input_delay -clock ft232_clk -min 0 [get_ports txe]

# Handle async reset
set_false_path -from [get_ports reset]

# CRC is a multicycle path
set_multicycle_path -setup -from [get_cells {me|checksum|*}] -to [get_cells {me|checksum|*}] 2
set_multicycle_path -hold -from [get_cells {me|checksum|*}] -to [get_cells {me|checksum|*}] 1

set_multicycle_path -setup -from [get_cells {mon|crc|*}] -to [get_cells {mon|crc|*}] 2
set_multicycle_path -hold -from [get_cells {mon|crc|*}] -to [get_cells {mon|crc|*}] 1

derive_clock_uncertainty
