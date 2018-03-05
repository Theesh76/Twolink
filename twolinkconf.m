function [c,ceq] = twolinkconf(x)
vel_max = [1 1];
acc_max = [0.5 0.5];
qr = [1.5708 1.5708];
omega = 2*pi*0.1;
% Nonlinear Inequality Constraints
c(1) = sqrt(x(1)^2 + x(3)^2)  + (1/2)*(sqrt(x(5)^2 + x(7)^2)) +  (1/3)*(sqrt(x(9)^2 + x(11)^2)) -  omega*qr(1);
c(2) = sqrt(x(2)^2 + x(4)^2)  + (1/2)*(sqrt(x(6)^2 + x(8)^2)) +  (1/3)*(sqrt(x(10)^2 + x(12)^2)) -  omega*qr(2);

c(3) = sqrt(x(1)^2 + x(3)^2)  +  sqrt(x(5)^2 + x(7)^2) +  sqrt(x(9)^2 + x(11)^2) - vel_max(1);
c(4) = sqrt(x(2)^2 + x(4)^2)  +  sqrt(x(6)^2 + x(8)^2) +  sqrt(x(10)^2 + x(12)^2) - vel_max(2);
 
c(5) = sqrt(x(1)^2 + x(3)^2)  + 2*(sqrt(x(5)^2 + x(7)^2)) +  3*(sqrt(x(9)^2 + x(11)^2)) - (1/omega)*acc_max(1);
c(6) = sqrt(x(2)^2 + x(4)^2)  + 2*(sqrt(x(6)^2 + x(8)^2)) +  3*(sqrt(x(10)^2 + x(12)^2)) - (1/omega)*acc_max(2);

ceq = [];
end