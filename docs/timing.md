# Timing
## External Components
### Magnetic Encoder
The magnetic encoder is a MT6701. It has a minimum clock period of 64ns, the PLL generates a clock frequency of 15.43 MHz, or a clock period of 64.8ns. 24 bits are transmitted: 14 data bits, 4 status bits, and a 6 bit CRC checksum ($x^6+x+1$). An additional six clock cycles are used for CRC checking and chganging the CSN bit. These 30 clock cyles take 1944ns. SSI is used to communicate with the magnetic encoder.

The magnetic encoder will read if **enable** is high, it doesn't work on positive edge. The output **angle_out** is registered over if the crc matches and **done** sends a positive edge.

### ADC
The analog to digital converter is a MCP33151D. It is a 500 ksps ADC with 14 bits of resolution, max 100 MHz clock. A 101 MHz clock is generated from the PLL is used to talk to it. Two of them are used to measure the current on lines A and B. There is two phases to the ADC calculation: a capacitor charge phase which takes 600ns, and a data conversion phase which takes 1400ns. The capacitor charge phase is where the internal capacitor for the SAR ADC charges to the input voltage level. The data conversion phase is where the ADC takes the capacitor voltage and digitizes it. The capacitor must charge when the low side MOSFET is on.

The ADC starts if **start** is high, it waits the 1400ns for the data conversion phase. The data is shifted into **adc**, and **done** gets a positive edge when the device is done.

### Gate Driver
The gate driver used is a DRV8300D. It takes 6 pwm signals: high and low for inputs A, B, C. The max pwm frequency is 200kHz or 5000ns. The gate driver either requires, or manually enforces, a 200ns deadtime between the high and low edges. The algorithm first takes the signed normalized voltage for the line, biases it up to be positive, and scales it to be 10 bits. This provides 1024 different PWM lengths. 4600ns/1024 = 4.49ns or 222.6 MHz clock, the PLL provides 222.2. 

The output of the algorithm, done in voltage_normalizer.sv, returns the cycle count for which pwm is high. Cycle count low is equal to 1023-high. The voltage_normalizer algorithm also guarentees that the ADC will get at least 400ns to charge, not the full 600ns required. single_pwm.sv handles the actual pwm signal generation from these values, and triple_pwm handles the clock cycle count, and also tells the ADCs when to take measurements through a posedge signal. 

## Overall Timing Information
Work in progress
