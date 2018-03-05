# Twolink - The folder contains optimization of trajectory to get inverse dynamics model of two-link robot through weighted least squares method.
twolink_ftraj - This is the main file. The twolink robot is defined and optimization of the trajectory is done using fmincon. The file call the objective function 'twolinkfobj' and the constranits function twolinkconf during the optimization process. 
dfdx - It does the numerical differentiation of a vector.
Reg.c - This is a mex file that calculates the regressor matrix (W) for given joint position q, joint velocity and joint acceletration.(tau = W*base_parameters)
twolink_inv_base - The twolink_ftraj calls this file to get the joint position, velocity and accleration to estimate base parmeters. The obtained base paremetrs should be [1.25,-0.5,0,0.25];

twolink_valid - To check the obtained model is perfect. This file generates a validation trajectory and calls the simulink file twolink_inv. The model uncertainities are created in the simulink file and it is compensated by the obtained inverse dynamics model. The desired trajectory mateches the actual trajectory inspite of uncertainities can be observed.
twolink_inv = It is a simulink file.  The simulink file has a robot with a imperfect inverse dynamics model compensated by a perfect dynamics model 



Procedure : 
1. Run twolink_ftraj - Obtain base paremeters (base)
2. Run twolink_valid 


Note : Incase reg.c not working. Try compiling the mex file using the command "mex reg.c" in the command line before running twolink_ftraj
