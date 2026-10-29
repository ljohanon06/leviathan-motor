#Set Pin Assignments
set_location_assignment	PIN_B8	-to {	reset	}
set_location_assignment	PIN_P11	-to {	clk_50	}
set_location_assignment	PIN_Y5	-to {	ft232_clk	}
set_location_assignment	PIN_Y4	-to {	txe	}
set_location_assignment	PIN_Y6	-to {	wr	}
set_location_assignment	PIN_W5	-to {	ft232_data[0]	}
set_location_assignment	PIN_AA14	-to {	ft232_data[1]	}
set_location_assignment	PIN_W12	-to {	ft232_data[2]	}
set_location_assignment	PIN_AB12	-to {	ft232_data[3]	}
set_location_assignment	PIN_AB11	-to {	ft232_data[4]	}
set_location_assignment	PIN_AB10	-to {	ft232_data[5]	}
set_location_assignment	PIN_AA9	-to {	ft232_data[6]	}
set_location_assignment	PIN_AA8	-to {	ft232_data[7]	}
set_location_assignment	PIN_AA7	-to {	csn	}
set_location_assignment	PIN_AA6	-to {	d_in	}
set_location_assignment	PIN_AA5	-to {	mag_clk_out	}
set_location_assignment	PIN_C10	-to {	on_switch	}
set_location_assignment	PIN_V10	-to {	sdo1	}
set_location_assignment	PIN_W10	-to {	sdo2	}
set_location_assignment	PIN_V9	-to {	adc_clk1	}
set_location_assignment	PIN_W9	-to {	adc_clk2	}
set_location_assignment	PIN_V8	-to {	cs1	}
set_location_assignment	PIN_W8	-to {	cs2	}
set_location_assignment	PIN_AA15	-to {	pwm_a_high	}
set_location_assignment	PIN_W13	-to {	pwm_a_low	}
set_location_assignment	PIN_AB13	-to {	pwm_b_high	}
set_location_assignment	PIN_Y11	-to {	pwm_b_low	}
set_location_assignment	PIN_W11	-to {	pwm_c_high	}
set_location_assignment	PIN_AA10	-to {	pwm_c_low	}
set_location_assignment	PIN_A8	-to {	debug[0]	}
set_location_assignment	PIN_A9	-to {	debug[1]	}
set_location_assignment	PIN_A10	-to {	debug[2]	}
set_location_assignment	PIN_B10	-to {	debug[3]	}
set_location_assignment	PIN_D13	-to {	debug[4]	}
set_location_assignment	PIN_C13	-to {	debug[5]	}
set_location_assignment	PIN_E14	-to {	debug[6]	}
set_location_assignment	PIN_D14	-to {	debug[7]	}
set_location_assignment	PIN_A11	-to {	debug[8]	}
set_location_assignment	PIN_B11	-to {	debug[9]	}
set_location_assignment	PIN_A14	-to {	voltage[0]	}
set_location_assignment	PIN_B14	-to {	voltage[1]	}
set_location_assignment	PIN_F15	-to {	voltage[2]	}
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

set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to wr

#Set IO Standards
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	reset	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	clk_50	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	ft232_clk	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	txe	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	wr	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	ft232_data[*]	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	csn	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	d_in	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	mag_clk_out	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	on_switch	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	sdo1	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	sdo2	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	adc_clk1	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	adc_clk2	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	cs1	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	cs2	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	pwm_a_high	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	pwm_a_low	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	pwm_b_high	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	pwm_b_low	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	pwm_c_high	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	pwm_c_low	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	debug[*]	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {voltage[*]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {ssd1[*]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {ssd2[*]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {ssd3[*]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {ssd4[*]}


#Set IO Standard for outputs
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	wr	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ft232_data[*]	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	csn	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	mag_clk_out	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	adc_clk1	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	adc_clk2	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	cs1	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	cs2	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	pwm_a_high	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	pwm_a_low	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	pwm_b_high	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	pwm_b_low	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	pwm_c_high	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	pwm_c_low	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	debug[*]	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ssd1[*]	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ssd2[*]	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ssd3[*]	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ssd4[*]	}






