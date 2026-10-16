module motor_test(
	input on_switch,
	input clk_50,
	input reset,
	input sdo1, //ADC Inputs and Outputs
	input sdo2,
	output adc_clk1,
	output adc_clk2,
	output cs1,
	output cs2,
	input d_in, //Magnetic Encoder Inputs and Outputs
	output mag_clk_out,
	output csn,
	output pwm_a_high, //Gate Driver outputs
	output pwm_a_low,
	output pwm_b_high,
	output pwm_b_low,
	output pwm_c_high,
	output pwm_c_low,
	input ft232_clk, //FT232H Direct Connections
	input txe,
	output [7:0] ft232_data,
	output wr);
	
	logic clk_100;
	logic clk_222; //Gate Driver clock
	logic clk_15; //Magnetic encoder
	logic pll_bad; //Active Low
	
	//PLL
	pll pll_inst (
		.areset (~reset),
		.inclk0 (clk_50),
		.c0 (clk_100),
		.c1 (clk_222),
		.c2 (clk_15),
		.locked (pll_bad) 
	);
	
	//State Variables
	typedef enum logic [2:0] {idle, one, two, zero, neg_one} voltage_state_t;
	logic [10:0] pwm_count;
	logic [23:0] cycle_count;
	voltage_state_t state;
	
	logic pwm_enable;
	logic mag_enable;
	logic data_write; //For monitor
	
	//Logic within one clock cycle
	assign pwm_enable = 11'd10 < pwm_count && pwm_count < 11'd100;
	assign mag_enable = 11'd10 < pwm_count && pwm_count < 11'd100;
	assign data_write = 11'd700 < pwm_count && pwm_count < 11'd750;
	
	//Timing Information
	always_ff @(posedge clk_222 or negedge reset) begin
			if(~reset) begin
				cycle_count <= 24'b0;
				state <= idle;
			end else begin
				case (state)
					idle: if(on_switch) begin
								state <= one;
								cycle_count <= 24'b0; end
					one: if(cycle_count > 24'd200000) state <= two;
					two: if(cycle_count > 24'd400000) state <= zero;
					zero: if(cycle_count > 24'd600000) state <= neg_one;
					neg_one: if(cycle_count > 24'd800000) state <= idle;
				endcase	
				case(state)
					idle: vq <= 18'b0;
					one: vq <= 18'h800;
					two: vq <= 18'h1000;
					zero: vq <= 18'b0;
					neg_one: vq <= -18'h800;
				endcase
				if (pwm_count == 10'd1020 && state != idle)
					cycle_count <= cycle_count + 24'b1;
			end
	end
	
	//Variables holding sensor information
	logic adc_done_1;
	logic adc_done_2;
	logic [13:0] adc_measurement1;
	logic [13:0] adc_measurement2;
	logic [13:0] angle_reg;
	
	monitor #(.N(6)) mon (
		.clk(clk_100),
		.reset(reset),
		.data_input({8'b0,cycle_count,2'b0,angle_reg}),
		.data_write(data_write),
		.ft232_clk(ft232_clk),
		.txe(txe),
		.ft232_data(ft232_data),
		.wr(wr));
	
	//Cordic
	logic [15:0] cos_mag;
	logic [15:0] sin_mag;
	logic cos_sign;
	logic sin_sign;
	logic angle_valid;
	logic cordic_done;
	
	cordic_full cd (
		.clk(clk_100),
		.reset(reset),
		.valid(angle_valid),
		.angle_in(angle_reg),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.done(cordic_done));
	
	//Convert desired voltage to pwm voltages
	logic [17:0] vd;
	logic [17:0] vq;
	logic [17:0] v1;
	logic [17:0] v2;
	logic [17:0] v3;
	
	assign vd = 18'b0;

	inverse_transform dut (
		.clk(clk_100),
		.reset(reset),
		.vd(vd),
		.vq(vq),
		.cos_mag(cos_mag),
		.sin_mag(sin_mag),
		.cos_sign(cos_sign),
		.sin_sign(sin_sign),
		.v1(v1),
		.v2(v2),
		.v3(v3));
		
	//PWM Gate Driver
	triple_pwm tp (
		.pwm_clk(clk_222),
		.reset(reset),
		.enable(pwm_enable),
		.v1(v1),
		.v2(v2),
		.v3(v3),
		.pwm_a_high(pwm_a_high),
		.pwm_a_low(pwm_a_low),
		.pwm_b_high(pwm_b_high),
		.pwm_b_low(pwm_b_low),
		.pwm_c_high(pwm_c_high),
		.pwm_c_low(pwm_c_low),
		.take_measurement_1(adc_start_1),
		.take_measurement_2(adc_start_2),
		.pwm_count(pwm_count));
		
	//Sensor signals
	//ADCs are controller from triple_pwm take measurement
	//Magnetic Encoder constantly reads and clocks into register
	logic adc_start_1;
	logic adc_start_2;
	logic me_done;
	logic [13:0] angle_out;
	always_ff @(posedge me_done) angle_reg <= angle_out;
	
	adc adc_1 (
		.clk(clk_100),
		.reset(reset),
		.start(adc_start_1),
		.sdo(sdo1),
		.clk_out(adc_clk1),
		.cs(cs1),
		.adc(adc_measurement1),
		.done(adc_done_1));
		
	adc adc_2 (
		.clk(clk_100),
		.reset(reset),
		.start(adc_start_2),
		.sdo(sdo2),
		.clk_out(adc_clk2),
		.cs(cs2),
		.adc(adc_measurement2),
		.done(adc_done_2));
		
	magnetic_encoder me (
		.mag_clk(clk_15),
		.reset(reset),
		.d_in(d_in),
		.enable(mag_enable),
		.csn(csn),
		.clk_out(mag_clk_out),
		.done(me_done),
		.angle_out(angle_out));
		
	
		
	
	
endmodule