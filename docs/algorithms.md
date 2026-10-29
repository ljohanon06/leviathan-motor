# Algorithms
There are a few main algorithms used in this code. The brushless motor is controlled using Field-Oriented Control (FOC), cos and sin values for an angle are calculated using CORDIC, and a simple algorithm is used to calculate the PWM for the gate drivers.

## Field-Oriented Control
### Brushless DC Motor Basics
A brushless motor (BLDC) has an internal magnetized rotor and an three sets of outer coils. For the motor to spin, the three sets of coils need to be turned on and off depending on the rotor angle and push or pull the rotor in the desired direction. The BLDC motor has 3 inputs corresponding to the three coil sets and works very similarly to a three phase power load. 

Importantly, we send a voltage to the three lines, but the current through the coils is what actually applies torque to the motor through the magnetic force. The three phases are attached to a half bridge each, which through a high side and low side PWM signal, the MOSFETS comprising the half bridge are rapidly opened and closed simulating the analog voltage powering the motor line.

Finally, there is a difference between an electrical rotation and an actual rotation of the motor. For an electrical rotation, the voltage on the line starts at 0, rises to V+, drops to 0, drops to V-, then rises back up to 0, roughly following a sine wave. This represents a coil pulling a magnet on the rotor in, turning off when they're next to each other, then pushing it away once it passes. Each motor line undergoes two electrical rotations per mechanical rotation.

### Space Vectors
A space vector is a way to represent a three phase power system as a 2d vector. By taking the magnitudes of the three voltages or currents, giving assign the vectors 0, 120, and 240 degree directions respectively, then summing them up, you get the space vector. This represents the overall magnitude and direction of the three phase power system at a given time. 

<img src="media/Space_Vector.gif" width="250" alt="Space Vector GIF">

In the gif, the red, blue, and green dots represent the changing magnitude of the voltage/current on each phase with a fixed direction, and the purple dot represents the normalized space vector. As time goes on, the space vector follows the peak magnitude of the three phases.

### What is Field-Oriented Control
Field-Oriented Control(FOC) is a method to mathematically force the current space vector to be 90 degrees ahead of the rotor angle. At a high level, the algorithm reads the currents on the three motor lines and turns it into a space vector, then it takes the space vectors direction, and subtracts the motor rotor angle from it. This is the normalized current space vector. This vector has two components: the quadrature current (y-axis) and the direct current (x-axis). The quadrature current is the component directly contributing to torque, and the direct current is the wasted current simply increasing flux. 

For a brushless motor, a current space vector that is 90 degrees ahead of the rotor means that the coil 90 degrees ahead would be pulling, the coil at the location of the rotor would be off, and the coil 90 degrees behind would be pushing. This is the situation in which maximum torque is obtained, and it also corresponds to a quadrature current of 1. If on the other hand, the current is aligned with the rotor angle, then the coil aligned with the rotor would be pulling and the coils ahead and behind would be off. This zero torque situation corresponds to a direct current of 0.

The goal of FOC is to use a PI controller to take the error between the desired current vector and actual current vector, and output the voltage space vector necessary to minimize that error. This voltage space vector is converted back into three phase voltages for the motor.

### Vector Transforms
A three phase system is converted into a space vector using the Clarke transform. It simply does some trig to get the x and y components of each vector and sum them up. Because the currents have to follow KCL, the maximum space vector magnitude is obtained when one current has magnitude one, and second has magnitude negative one. The magnitude of the space vector in this case is $\sqrt{3}$, which is the reason for the $1/sqrt{3}$ constant.

$$
\begin{equation} 
    \begin{bmatrix}
        I_a \\
        I_b
    \end{bmatrix} 
    = \frac{1}{\sqrt{3}}
    \begin{bmatrix}
        1 & -1/2 & -1/2 \\
        0 & \sqrt{3} /2 & -\sqrt{3}/2 
    \end{bmatrix}
    \begin{bmatrix}
        I_1 \\
        I_2 \\
        I_3
    \end{bmatrix}
\end{equation}
$$


