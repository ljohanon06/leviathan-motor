create_clock -name clk_50 -period 20.000 [get_ports clk_50]
derive_pll_clocks

set_clock_groups -asynchronous \
	-group [get_clocks {clk_50}] \
	-group [get_clocks {gcr|pll_inst|altpll_component|auto_generated|pll1|clk[0]}] 
	
set_false_path -from [get_ports reset]
derive_clock_uncertainty
