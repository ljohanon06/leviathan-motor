#Set Pin Assignments
set_location_assignment	PIN_B8	-to {	reset	}
set_location_assignment	PIN_P11	-to {	clk_50	}
set_location_assignment	PIN_V10	-to {	sdo	}
set_location_assignment	PIN_V9	-to {	adc_clk}
set_location_assignment	PIN_V8	-to {	cs	}
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



#Set IO Standards
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	reset	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	clk_50	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	sdo1	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	adc_clk1	}
set_instance_assignment	-name IO_STANDARD "3.3-V LVTTL"	-to {	cs1	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {ssd1[*]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {ssd2[*]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {ssd3[*]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {ssd4[*]}


#Set IO Standard for outputs
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	adc_clk}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	cs	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ssd1[*]	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ssd2[*]	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ssd3[*]	}
set_instance_assignment	-name CURRENT_STRENGTH_NEW 8MA	-to {	ssd4[*]	}






