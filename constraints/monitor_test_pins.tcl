#Set Pin Assignments
set_location_assignment	PIN_A7	-to	{reset	}
set_location_assignment	PIN_P11	-to	{clk_50	}
set_location_assignment	PIN_Y5	-to {	ft232_clk	}
set_location_assignment	PIN_Y4	-to {	txe	}
set_location_assignment	PIN_Y6	-to {	wr	}
set_location_assignment	PIN_W5	-to	{ft232_data[0]	}
set_location_assignment	PIN_AA14	-to	{ft232_data[1]	}
set_location_assignment	PIN_W12	-to	{ft232_data[2]	}
set_location_assignment	PIN_AB12	-to	{ft232_data[3]	}
set_location_assignment	PIN_AB11	-to	{ft232_data[4]	}
set_location_assignment	PIN_AB10	-to	{ft232_data[5]	}
set_location_assignment	PIN_AA9	-to	{ft232_data[6]	}
set_location_assignment	PIN_AA8	-to	{ft232_data[7]	}

set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to wr

#Set IO Standards
set_instance_assignment	-name	IO_STANDARD	"3.3-V LVTTL"	-to	{	reset	}
set_instance_assignment	-name	IO_STANDARD	"3.3-V LVTTL"	-to	{	clk_50	}
set_instance_assignment	-name	IO_STANDARD	"3.3-V LVTTL"	-to	{	ft232_clk	}
set_instance_assignment	-name	IO_STANDARD	"3.3-V LVTTL"	-to	{	txe	}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" 		-to wr
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" 		-to {ft232_data[*]}

#Set IO Standard for outputs
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to wr
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to {ft232_data[*]}





