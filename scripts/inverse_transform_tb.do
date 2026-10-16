transcript on

cd /home/levijohanon/School/Fall26/EE3240/Quartus/simulation/questa
set SV_DIR "/home/levijohanon/School/Fall26/EE3240/SystemVerilog"

if {[file exists levi_work]} {
	vdel -lib levi_work -all
}

vlib levi_work
vmap work levi_work

vlog -sv -work work +incdir+$SV_DIR $SV_DIR/inverse_transform_tb.sv $SV_DIR/inverse_transform.sv $SV_DIR/inverse_clarke.sv $SV_DIR/inverse_park.sv $SV_DIR/cordic.sv $SV_DIR/cordic_full.sv $SV_DIR/two_to_sign.sv $SV_DIR/angle_normalizer.sv
vsim -t 1ps -L lpm_ver -L work -voptargs="+acc" inverse_transform_tb

add wave *
view structure
view signals
run 300ns

# Works with Matlab_Tests.m/test_inverse