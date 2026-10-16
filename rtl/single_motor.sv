/*
Modules to instantiate

-cordic_full
-forward_transform
-inverse_transform
-PI controller
-PWM output
-Clock logic
-PLL for mt6701
-magnetic_encoder
-two adc, timing logic to ensure that its clocked when low gate on.
*/

/*
Clocks:
100MHz - Logic and ADC
64ns - MT6701
216MHz - PWM

Remaining:
ESP32 logic - unclocked?
Angle sensor
BMS?? 
*/