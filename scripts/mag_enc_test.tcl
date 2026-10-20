# Load Required Packages
load_package flow
load_package project

# Project Name and Variables
set project_name "mag_enc_test"
set top_level_entity "mag_enc_test"

# Create and Open Project
set build_dir "build/$project_name"

if{![file exists $build_dir]} {
	file mkdir $build_dir
}

set project_path "$build_dir/$project_name"

if{[project_exists $project_path]}{
	project_open $project_path
} else {
	project_new $project_path
}

# Project Details
set_global_assignment -name FAMILY "Max 10"
set_global_assignment -name DEVICE "10M50DAF484C7G"

# Add Project Source Files
set rtl_files [glob -nocomplain src/*.sv]

foreach file $rtl_files {
	set_global_assignment -name SYSTEMVERILOG_FILE "../../src/$file"
}

set_global_assignment -name SYSTEMVERILOG_FILE "../../tb/hardware_tests/$mag_enc_test"

# Other Project Files
source "../../constraints/${project_name}_pins.tcl"
# set_global_assignment -name SDC_FILE "../../constraints/${project_name}.sdc"

export_assignments

# Compile
if{[catch {execute_flow -compile} err]}{
	puts "\nError during compilation"
	puts "Details: $err"
} else {
	puts "\nCompilation Successful"
}

project_close
