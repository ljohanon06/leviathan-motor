set project_name "adc_tb"

if {![string match "*build/$project_name" [pwd]]} {
	file mkdir "build/$project_name"
	cd "build/$project_name"
}

transcript on

set rtl_dir "../../rtl"
set tb_dir "../../tb"

if {[file exists "$project_name"]} {
	vdel -lib "$project_name" -all
}

vlib "$project_name"
vmap work "$project_name"

set rtl_files [glob -nocomplain "$rtl_dir/*.sv"]
foreach file $rtl_files {
	vlog -sv -work work "$file"
}

vlog -sv -work work "$tb_dir/$project_name.sv"

vsim -t 10ps -L lpm_ver -L work -voptargs="+acc" "$project_name"

add wave *
view structure
view signals
run -all
