# 50 MHz clock (clk_50) coming from PIN_P11
create_clock -name clk_50 -period 20.000 [get_ports clk_50]
derive_pll_clocks
derive_clock_uncertainty

# Magnetic Encoder Requirements, Data read 15ns after rising edge
create_generated_clock -name mag_enc_clk -source [get_pins {pll_inst|c2}] [get_ports mag_clk_out]
set_input_delay -clock mag_clock_out -max 15.5 [get_ports d_in]
set_input_delay -clock mag_clock_out -min 0.5 [get_ports d_in]

# Handle async reset
set_false_path -from [get_ports reset]
