transcript on

cd /home/levijohanon/School/Fall26/EE3240/Quartus/simulation/questa
set SV_DIR "/home/levijohanon/School/Fall26/EE3240/SystemVerilog"

if {[file exists levi_work]} {
	vdel -lib levi_work -all
}

vlib levi_work
vmap work levi_work

vlog -sv -work work +incdir+$SV_DIR $SV_DIR/crc_tb.sv $SV_DIR/crc.sv
vsim -t 1ps -L lpm_ver -L work -voptargs="+acc" crc_tb

add wave *
view structure
view signals
run 300ns