#Set Pin Assignments
set_location_assignment	PIN_AA7	-to	{csn	}
set_location_assignment	PIN_AA6	-to	{d_in	}
set_location_assignment	PIN_AA5	-to	{mag_clk_out	}
set_location_assignment	PIN_A7	-to	{reset	}
set_location_assignment	PIN_P11	-to	{clk_50	}
set_location_assignment	PIN_A9	-to	{mg[1]	}
set_location_assignment	PIN_A10	-to	{mg[2]	}
set_location_assignment	PIN_B10	-to	{mg[3]	}
set_location_assignment	PIN_A8	-to	{mg[0]	}
set_location_assignment	PIN_W9	-to	{ft232_clk	}
set_location_assignment	PIN_W8	-to	{txe	}
set_location_assignment	PIN_W10	-to	{wr	}
set_location_assignment	PIN_W5	-to	{ft232_data[0]	}
set_location_assignment	PIN_AA14	-to	{ft232_data[1]	}
set_location_assignment	PIN_W12	-to	{ft232_data[2]	}
set_location_assignment	PIN_AB12	-to	{ft232_data[3]	}
set_location_assignment	PIN_AB11	-to	{ft232_data[4]	}
set_location_assignment	PIN_AB10	-to	{ft232_data[5]	}
set_location_assignment	PIN_AA9	-to	{ft232_data[6]	}
set_location_assignment	PIN_AA8	-to	{ft232_data[7]	}



#Set IO Standards
set_instance_assignment	-name	IO_STANDARD	"3.3-V LVTTL"	-to	{	csn	}
set_instance_assignment	-name	IO_STANDARD	"3.3-V LVTTL"	-to	{	d_in	}
set_instance_assignment	-name	IO_STANDARD	"3.3-V LVTTL"	-to	{	mag_clk_out	}
set_instance_assignment	-name	IO_STANDARD	"3.3-V LVTTL"	-to	{	reset	}
set_instance_assignment	-name	IO_STANDARD	"3.3-V LVTTL"	-to	{	clk_50	}
set_instance_assignment	-name	IO_STANDARD	"3.3-V LVTTL"	-to	{	mg[*]	}
set_instance_assignment	-name	IO_STANDARD	"3.3-V LVTTL"	-to	{	ft232_clk	}
set_instance_assignment	-name	IO_STANDARD	"3.3-V LVTTL"	-to	{	txe	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" 		-to wr
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" 		-to {ft232_data[*]}

#Set IO Standard for outputs
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to wr
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to {ft232_data[*]}
set_instance_assignment	-name	CURRENT_STRENGTH_NEW	8MA	-to	{csn	}
set_instance_assignment	-name	CURRENT_STRENGTH_NEW	8MA	-to	{mag_clk_out}
set_instance_assignment	-name	CURRENT_STRENGTH_NEW	8MA	-to	{mg[1]	}
set_instance_assignment	-name	CURRENT_STRENGTH_NEW	8MA	-to	{mg[2]	}
set_instance_assignment	-name	CURRENT_STRENGTH_NEW	8MA	-to	{mg[3]	}
set_instance_assignment	-name	CURRENT_STRENGTH_NEW	8MA	-to	{mg[0]	}





