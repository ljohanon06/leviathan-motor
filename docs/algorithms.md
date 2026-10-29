# Algorithms
There are a few main algorithms used in this code. The brushless motor is controlled using Field-Oriented Control (FOC), cos and sin values for an angle are calculated using CORDIC, and a simple algorithm is used to calculate the PWM for the gate drivers.

## Field-Oriented Control
### Brushless DC Motor Basics
A brushless motor (BLDC) has an internal magnetized rotor and an three sets of outer coils. For the motor to spin, the three sets of coils need to be turned on and off depending on the rotor angle and push or pull the rotor in the desired direction. The BLDC motor has 3 inputs corresponding to the three coil sets and works very similarly to a three phase power load. 

Importantly, we send a voltage to the three lines, but the current through the coils is what actually applies torque to the motor through the magnetic force. The three phases are attached to a half bridge each, which through a high side and low side PWM signal, the MOSFETS comprising the half bridge are rapidly opened and closed simulating the analog voltage powering the motor line.

Finally, there is a difference between an electrical rotation and an actual rotation of the motor. For an electrical rotation, the voltage on the line starts at 0, rises to V+, drops to 0, drops to V-, then rises back up to 0, roughly following a sine wave. This represents a coil pulling a magnet on the rotor in, turning off when they're next to each other, then pushing it away once it passes. Each motor line undergoes two electrical rotations per mechanical rotation.

### Space Vectors


### What is Field-Oriented Control
Field-Oriented Control(FOC) is a method to mathematically force the current vector 
