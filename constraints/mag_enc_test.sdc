#50 MHz clock (clk_50) coming from PIN_P11
create_clock -name clk_50 -period 20.000 [get_ports clk_50]
derive_pll_clocks
derive_clock_uncertainty

create_generated_clock -name ladder_bit_0 \
    -source [get_ports clk_50] \
    -divide_by 2 \
    [get_registers {clk_ladder[0]}]

create_generated_clock -name ladder_bit_10 \
    -source [get_ports clk_50] \
    -divide_by 12048 \
    [get_registers {clk_ladder[10]}]
    
set_clock_groups -asynchronous \
    -group [get_clocks {ladder_bit_10}] \
    -group [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}]
