# 50 MHz clock (clk) coming from PIN_P11
create_clock -name clk -period 20.000 [get_ports clk]
derive_pll_clocks

set_clock_groups -asynchronous \
	-group [get_clocks {clk}] \
	-group [get_clocks {sd|gcr|pll_inst|altpll_component|auto_generated|pll1|clk[0]}] 

# Handle async reset
set_false_path -from [get_ports reset]

derive_clock_uncertainty
