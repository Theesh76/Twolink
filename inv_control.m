function u = inv_control(q,qd,qdd,X)
% Compute required input torque as a function of desired trajectory and the
% extended plant design vector.

% check vector orientation:
if isrow(q)
    q = q';
end
if isrow(qd)
    qd = qd';
end
if isrow(qdd)
    qdd = qdd';
end

q1 = q(1);
q2 = q(2);
q1d = qd(1);
q2d = qd(2);

% physical constants:
g = 9.81;           % gravitational constant

% manipulator parameters:           
l1 = X(1);          % link 1 length
l2 = X(2);          % link 2 length
m1 = X(3);          % link 1 mass
m2 = X(4);          % link 2 mass
mp = X(5);          % payload mass

% dependent parameters:
lc1 = l1/2;         % link 1 cm location
lc2 = l2*(m2/2+mp)/(m2+mp);         
                    % link 2 cm location
I1 = m1*l1^2/12;    % link 1 mass moment of inertia
Ilink = m2*l2^2/12 + m2*(lc2-l2/2)^2;
Ipayload = mp*(l2-lc2)^2;
I2 = Ilink+Ipayload;% link 2 mass moment of inertia

% update total link masses for D(q) calculation:
m2 = m2 + mp;

% form inertia matrix:
D(1,1) = m1*lc1^2 + m2*(l1^2+lc2^2+2*l1*lc2*cos(q2)) + I1 + I2;
D(1,2) = m2*(lc2^2+l1*lc2*cos(q2)) + I2;
D(2,1) = D(1,2);
D(2,2) = m2*lc2^2 + I2;

% form damping matrix:
h = -m2*l1*lc2*sin(q2);
C(1,1) = h*q2d;
C(1,2) = h*q2d + h*q1d;
C(2,1) = -h*q1d;

% form gravity vector:
G(1,1) = (m1*lc1+m2*l1)*g*cos(q1) + m2*lc2*g*cos(q1+q2);
G(2,1) = m2*lc2*g*cos(q1+q2);

% compute required torque (outputs column vector)
u = D*qdd + C*qd + G; 
end