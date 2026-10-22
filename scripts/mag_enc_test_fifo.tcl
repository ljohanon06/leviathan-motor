# Load Required Packages
load_package flow
load_package project

# Project Name and Variables
set project_name "mag_enc_test_fifo"
set top_level_entity "mag_enc_test_fifo"

# Create and Open Project
set build_dir "build/$project_name"

if {![file exists $build_dir]} {
	file mkdir "$build_dir"
}

set project_path "$build_dir/$project_name"

if {[project_exists $project_path]} {
	project_open $project_path
} else {
	project_new $project_path
}
puts "Project Created and Opened"

# Project Details
set_global_assignment -name FAMILY "Max 10"
set_global_assignment -name DEVICE "10M50DAF484C7G"
set_global_assignment -name TOP_LEVEL_ENTITY "$top_level_entity"
set_global_assignment -name NUM_PARALLEL_PROCESSORS 16

# Ignore LogicLock warning
set_global_assignment -name MESSAGE_DISABLE 292013

# Add Project Source Files
set rtl_files [glob -nocomplain ../../rtl/*.sv]

foreach file $rtl_files {
	set_global_assignment -name SYSTEMVERILOG_FILE "../../rtl/$file"
}

set_global_assignment -name SYSTEMVERILOG_FILE "../../tb/hardware_tests/${top_level_entity}.sv"
puts "Added Source Files"

# Other Project Files
source "../../constraints/${top_level_entity}_pins.tcl"
puts "Added Pin Assignments"
set_global_assignment -name SDC_FILE "../../constraints/${project_name}.sdc"
puts "Added SDC file"

export_assignments

# Compile
puts "Starting Compilation"
if {[catch {execute_flow -compile} err]} {
	puts "\nError during compilation"
	puts "Details: $err"
} else {
	puts "\nCompilation Successful"
}

project_close
