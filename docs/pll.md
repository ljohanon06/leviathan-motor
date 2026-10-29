# PLL
### How it works
A PLL works with by setting up a voltage controlled oscillator, then dividing it by a constant C. The voltage controlled oscillator needs to be setup to be between 600 and 1300 MHz to work reliably. It compares $f_{in}/N$ and $f_{VCO}/M$ and adjusts them so that they are the same frequency. M and N are user controlled numbers between 0 and 512. After this operation, $f_{VCO}$ can be divided by different constants C to get up to 5 different clock frequencies. In total for a single PLL, a unique M and N parameter is needed to set up the VCO, as well as up to 5 C parameters for the five possible clock outputs.

$f_o = \frac{f_{VCO}}{C} = \frac{f_{in} M}{N C}$

### Clocks Needed
Three different clock frequencies are needed for this project. First, for the magnetic encoder there is a max clock frequency of 64ns. Second, the PWM carrier frequency has a max of 200kHz, determined by the gate driver used. With the two mandatory 200ns deadtimes, this results in 1024 clock cycles every 4600ns, so 222.6 MHz max. For the third clock frequency, I decided to run the main logic off of a 100MHz clock. This comes to a 15.625 MHz, 100 MHz, and 222.6 MHz clock.

### Calculations
First, M and N parameters were set to be 200 and 9, resulting in a VCO frequency of 1111.11 MHz, satisfying the between 600 and 1300 MHz requirement. Then, a C of 5 was used to get 222.2 MHz, a C of 11 to get 101.01 MHz, and a C of 72 to get 15.43 MHz. These are usable for my project.

### Altera PLL Implementation
Alteras PLL instantiation wraps these three internal parameters (M,N,C) in two instantiation parameters, multiply_by(mb) = M and divide_by(db) = N*C. In addition to this, while there can only be one M value for a PLL, there can be a unique mb value for each output clock, where the actual M value is the lowest common multiple of the three mb values. In addition to this, the Quartus IP can give you non-functional values, which is mildly annoying.

For this implementation, multiply_by = 200 and divide_by is 45, 99, and 648 for the three output clocks. In addition, the input clock frequency is passed in picoseconds. At 50 MHz this is 20000.
