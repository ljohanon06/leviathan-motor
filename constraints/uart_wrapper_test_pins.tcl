#Set Pin Assignments
set_location_assignment	PIN_A7	-to {	reset	}
set_location_assignment	PIN_P11	-to {	clk	}
set_location_assignment 	PIN_AB3 -to {tx}
set_location_assignment	PIN_AB2 -to {rx}
set_location_assignment	PIN_C14	-to	{ssd1[0]}
set_location_assignment	PIN_E15	-to	{ssd1[1]}
set_location_assignment	PIN_C15	-to	{ssd1[2]}
set_location_assignment	PIN_C16	-to	{ssd1[3]}
set_location_assignment	PIN_E16	-to	{ssd1[4]}
set_location_assignment	PIN_D17	-to	{ssd1[5]}
set_location_assignment	PIN_C17	-to	{ssd1[6]}
set_location_assignment	PIN_C18	-to	{ssd2[0]}
set_location_assignment	PIN_D18	-to	{ssd2[1]}
set_location_assignment	PIN_E18	-to	{ssd2[2]}
set_location_assignment	PIN_B16	-to	{ssd2[3]}
set_location_assignment	PIN_A17	-to	{ssd2[4]}
set_location_assignment	PIN_A18	-to	{ssd2[5]}
set_location_assignment	PIN_B17	-to	{ssd2[6]}
set_location_assignment	PIN_B20	-to	{ssd3[0]}
set_location_assignment	PIN_A20	-to	{ssd3[1]}
set_location_assignment	PIN_B19	-to	{ssd3[2]}
set_location_assignment	PIN_A21	-to	{ssd3[3]}
set_location_assignment	PIN_B21	-to	{ssd3[4]}
set_location_assignment	PIN_C22	-to	{ssd3[5]}
set_location_assignment	PIN_B22	-to	{ssd3[6]}
set_location_assignment	PIN_F21	-to	{ssd4[0]}
set_location_assignment	PIN_E22	-to	{ssd4[1]}
set_location_assignment	PIN_E21	-to	{ssd4[2]}
set_location_assignment	PIN_C19	-to	{ssd4[3]}
set_location_assignment	PIN_C20	-to	{ssd4[4]}
set_location_assignment	PIN_D19	-to	{ssd4[5]}
set_location_assignment	PIN_E17	-to	{ssd4[6]}
set_location_assignment	PIN_V10	-to {	pwm_a	}
set_location_assignment	PIN_V9	-to {	pwm_b	}
set_location_assignment	PIN_V8	-to {	pwm_c	}
set_location_assignment	PIN_B8	-to {	zero	}
set_location_assignment	PIN_A8	-to {	leds[0]}
set_location_assignment	PIN_A9	-to {	leds[1]}
set_location_assignment	PIN_A10	-to {	leds[2]}
set_location_assignment	PIN_B10	-to {	leds[3]}
set_location_assignment	PIN_D13	-to {	leds[4]}
set_location_assignment	PIN_C13	-to {	leds[5]}
set_location_assignment	PIN_E14	-to {	leds[6]}
set_location_assignment	PIN_D14	-to {	leds[7]}
set_location_assignment	PIN_A11	-to {	leds[8]}
set_location_assignment	PIN_B11	-to {	leds[9]}


#Set IO Standards
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	reset	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	clk	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	tx}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	rx	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	ssd1[*]	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	ssd2[*]	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	ssd3[*]	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	ssd4[*]	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	leds[*]	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	pwm_a	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	pwm_b	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	pwm_c	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {	zero	}

#Set IO Standard for outputs
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	tx	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ssd1[*]	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ssd2[*]	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ssd3[*]	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ssd4[*]	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	leds[*]	}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to { 	pwm_a	}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to { 	pwm_b	}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to { 	pwm_c	}






