# TCL Scripting

Work in progress

## TCL Pin Compilation
The TCL Pin Compilation script fully handles the pin assignments for the DE10-Lite. The file name is module_name_pins.tcl. For example, mag_enc_test_pins.tcl. In this file, every input and output port for the top module gets a pin assignment and is assigned a voltage standard. The output pins are assigned a current strength value and the input pins coming from outside the board get the PCI clamp diodes turned on for overvoltage protection. The is as follows.

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
The SDC file is the most central

## TCL Compilation Script
For this project, every build will live in /build. Each testbench(_tb.sv) and hardware testbench(_test.sv), as well as the final product will be in its seperate directory. When compiling using the tcl script, a db and incremental_db directory is created, as well as some other folders. 

The project is referenced by the project_path variable, if this is /build/p_name/p_name, then the Quartus Project file(qpf) and Quartus Settings file(qsf) will be in /build/p_name/p_name.qpf.

## Do Scripts (Questa)
