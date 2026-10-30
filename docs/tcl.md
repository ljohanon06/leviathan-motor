# TCL Scripting

## TCL Pin Compilation
The TCL Pin Compilation script fully handles the pin assignments for the DE10-Lite. The file name is module_name_pins.tcl. For example, mag_enc_test_pins.tcl. In this file, every input and output port for the top module gets a pin assignment and is assigned a voltage standard. The output pins are assigned a current strength value and the input pins coming from outside the board get the PCI clamp diodes turned on for overvoltage protection. Everything is shown below.

```TCL
# All pins get location and IO standard
set_location_assignment	PIN_A6 -to {input_pin}
set_location_assignment	PIN_A7 -to {output_pin}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {input_pin}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {output_pin}

# Output pins get current assignment
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to {output_pin}

# Input pins leaving board get PCI clamp diodes
set_instance_assignment -name PCI_IO ON -to {input_pin}
```

## SDC File
The SDC file controls the timing for every build and allow the timing analyzer to truly function. The first step is to tell the timing analyzer about the clocks in the design with the create_clock command, and also tell it to automatically run the command for the PLL clocks. get_ports is used any ports specifically going in and out of the top level module.

```TCL
# Create clocks and pll clocks
create_clock -name clk_50 -period 20.000 [get_ports clk_50]
derive_pll_clocks
```
The next step is that the clocks need to be declared asynchronous. This is so the timing analyzer doesn't try and analyze any paths between different clock domains. The same is done for the asynchronous reset. Also, the reset is lifted with a reset synchronizer.

```TCL
# Declare clocks asynchronous
set_clock_groups -asynchronous \
	-group [get_clocks {clk_50}] \
	-group [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]

# Handle async reset
set_false_path -from [get_ports reset]
```
Any generated clocks, such as the clock sent to the ADC and the magnetic encoder, or internal clocks created, needs to be declared. Also, for any external pins, the input and output delays need to be set. The input delay is the time after a clock edge that an input to the FPGA will be ready. The output delay is the setup time that an external device needs on an FPGA output. Also, get_pins is for the ports of internal modules.

```TCL
# Create any generated clock, set input output delays
create_generated_clock -name adc_clk1 -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] [get_ports adc_clk1]
set_input_delay -clock adc_clk1 -clock_fall -max 10 [get_ports sdo1]
set_input_delay -clock adc_clk1 -clock_fall -min 0.5 [get_ports sdo1]
```
Any multicycle paths in the logic need to be declared. There is two settings that can be declared, the setup and the hold path. The setup time is the time output needs to be held stable before the next clock edge, and the setup path tells the timing analysis how many clock edges this takes to happen. Similarly, the hold time is the an input needs to be stable after the clock edge, and a multicycle hold path tells the timing analyzer what clock edge to to an earlier clock cycle for the input. Finally, derive_clock_uncertainty tells the timing analyzer to handle any other details.

```TCL
# CRC is a multicycle path
set_multicycle_path -setup -from [get_cells {me|checksum|*}] -to [get_cells {me|checksum|*}] 2
set_multicycle_path -hold -from [get_cells {me|checksum|*}] -to [get_cells {me|checksum|*}] 1

# Derive clock uncertainty
derive_clock_uncertainty
```

## TCL Compilation Script
For this project, every build will live in /build. Each testbench(_tb.sv) and hardware testbench(_test.sv), as well as the final product will be in its seperate directory. This build directory is on the gitignore. The first thing that happens is the necessary packages are loaded to deal with the project and for compilation, project and flow, are loaded.

Then to start, a few variables are declared. The top_level_module and project_name, which should ideally be the same, are set. All file names are set off of the project name, such as "$project_name.sdc" and so on. From these, the build directory and project paths are created, then the project is created and opened. After this, there is three main steps: creating the global attributes and ignoring some warnings, adding all necessary files, and finally compiling everything. 

Overall, the TCL script is pretty unique here in that only the only thing necessary to change between scripts is the project_name. The script run command is shown below.

```bash
quartus_sh -t scripts/module_name.tcl
```

## Do Scripts (Questa)
The .do scripts are the scripts necessary to simulate in Questa.
