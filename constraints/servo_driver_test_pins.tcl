set_location_assignment	PIN_P11	-to {	clk_50	}
set_location_assignment	PIN_A7	-to {	reset	}
set_location_assignment	PIN_B8	-to {	zero	}
set_location_assignment	PIN_C10	-to {	sw[0]	}
set_location_assignment	PIN_C11	-to {	sw[1]	}
set_location_assignment	PIN_D12	-to {	sw[2]	}
set_location_assignment	PIN_C12	-to {	sw[3]	}
set_location_assignment	PIN_A12	-to {	sw[4]	}
set_location_assignment	PIN_B12	-to {	sw[5]	}
set_location_assignment	PIN_A13	-to {	sw[6]	}
set_location_assignment	PIN_A14	-to {	sw[7]	}
set_location_assignment	PIN_B14	-to {	sw[8]	}
set_location_assignment	PIN_F15	-to {	sw[9]	}
set_location_assignment	PIN_V10	-to {	pwm_a	}
set_location_assignment	PIN_V9	-to {	pwm_b	}
set_location_assignment	PIN_V8	-to {	pwm_c	}
set_location_assignment	PIN_A10	-to {	rev_a	}
set_location_assignment	PIN_A9	-to {	rev_b	}
set_location_assignment	PIN_A8	-to {	rev_c	}

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	clk_50	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	reset	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	zero	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	sw[*]	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	pwm_a	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	pwm_b	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	pwm_c	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	rev_a	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	rev_b	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	rev_c	}

set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to { 	pwm_a	}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to { 	pwm_b	}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to { 	pwm_c	}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to { 	rev_a	}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to { 	rev_b	}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to { 	rev_c	}

