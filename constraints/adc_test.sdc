# 50 MHz clock (clk_50) coming from PIN_P11
create_clock -name clk_50 -period 20.000 [get_ports clk_50]
derive_pll_clocks

set_clock_groups -asynchronous \
	-group [get_clocks {clk_50}] \
	-group [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] 


# ADC Requirements, sdo valid 10ns after clk low
create_generated_clock -name adc_clk -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] [get_ports adc_clk]
set_input_delay -clock adc_clk -clock_fall -max 10 [get_ports sdo]
set_input_delay -clock adc_clk -clock_fall -min 0.5 [get_ports sdo]

# Handle async reset
set_false_path -from [get_ports reset]

derive_clock_uncertainty
