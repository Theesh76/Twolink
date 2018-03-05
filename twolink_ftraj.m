clear all;
clc;
tic
t  = [0:0.1:20]';
twolink_mod = SerialLink([
    Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 1, 'r', [-0.5 0 0], 'I', [0 0 0], 'B', 0, 'G', 0, 'Jm', 0, 'standard')
   Revolute('d', 0, 'a', 0, 'alpha', 0, 'm', 1, 'r', [-0.5 0 0], 'I', [0 0 0], 'B', 0, 'G', 0, 'Jm', 0, 'standard')]);
h = 0.1;
omega = 2*pi*h;
x0 = rand(1,12);
%x0 =[0.1540   -0.3595   -0.0532    0.2027   -0.4855    0.5743    0.1701 -0.6486    0.3316   -0.2149   -0.0957    0.3648]; %[SQP - only dynamic parameters]
%x0 = [0.1340    0.7262    0.4013    0.3921    0.0280    0.8370    0.5754    0.9926    0.6668    0.5416    0.8015 0.8991];
%x0 = [0.3142    0.1615    0.3142    0.0482    0.0000    0.6283    0.6283 0.1996    0.0000    0.9425    0.0000 0.9425]; % Interior point
%x0 = [0.3142    0.2380         0    0.2051    0.5418    0.0000         0    0.6283    0.1648  0   0   0.9425]; %SQP
%x0 = [0.3142    0.3134    0.3142    0.0213         0    0.6283    0.5996    0.0000         0    0.9425    0.2257 0] %SQP
A=zeros(6,12);
A(1,3) = 1/omega;
A(1,7) = 1/(2*omega);
A(1,11) = 1/(3*omega);
A(2,4) = 1/(omega);
A(2,8) = 1/(2*omega);
A(2,12) = 1/(3*omega);
A(3,1) = 1;
A(3,5) = 1;
A(3,9) = 1;
A(4,2) = 1;
A(4,6) = 1;
A(4,10) = 1;
A(5,3) = omega;
A(5,7) = 2*omega;
A(5,11) = 3*omega;
A(6,4) = omega;
A(6,8) = 2*omega;
A(6,12) = 3*omega;
B = zeros(6,1);
fobj = @(x) twolinkfobj(x);
noncons = @(x) twolinkconf(x); 
lb = -100*ones(1,12);
ub = 100*ones(1,12);
options = optimoptions(@fmincon,'Display','iter','Algorithm','interior-point');
[x,fval,exitflag,output] = fmincon(fobj,x0,[],[],A,B,lb,ub,noncons,options);
for i=1 : length(t)
    a11(i) = (x(1)/(omega))*sin(omega*t(i)) + (x(5)/(omega*2))*sin(omega*2*t(i)) + (x(9)/(omega*3))*sin(omega*3*t(i)) - (x(3)/(omega))*cos(omega*t(i)) - (x(7)/(omega*2))*cos(omega*2*t(i)) - (x(11)/(omega*3))*cos(omega*3*t(i)); 
    b11(i) = (x(2)/(omega))*sin(omega*t(i)) + (x(6)/(omega*2))*sin(omega*2*t(i)) + (x(10)/(omega*3))*sin(omega*3*t(i)) - (x(4)/(omega))*cos(omega*t(i)) - (x(8)/(omega*2))*cos(omega*2*t(i)) - (x(12)/(omega*3))*cos(omega*3*t(i)); 
end
q = [a11;b11]';
a11_d = dfdx(a11,t);
b11_d = dfdx(b11,t);
qd = [a11_d;b11_d]';
a11_dd = dfdx(a11_d,t);
b11_dd = dfdx(b11_d,t);
qdd = [a11_dd;b11_dd]';
qdes = timeseries(q,t);
qd_des = timeseries(qd,t);
qdd_des = timeseries(qdd,t);
plot(qdes);
legend('joint1','joint2');
sim('twolink_inv_base');
q_m = [qm.Data(:,1) qm.Data(:,2)];
qd_m = [qd_m.Data(:,1) qd_m.Data(:,2)];
qdd_m = [qdd_m.Data(:,1) qdd_m.Data(:,2)];
W = cell(length(t),1); 
for i= 1 : length(t)
     Wl = vec2mat(Reg(q_m(i,:),qd_m(i,:),qdd_m(i,:)),20);
     Wb1 = Wl(:,6);
     Wb2 = Wl(:,17);
     Wb3 = Wl(:,18);
     Wb4 = Wl(:,16);
     Wb = [Wb1,Wb2,Wb3,Wb4];
     W{i} = Wb;
end
W = cell2mat(W);
base = pinv(W)*u
xlabel('Time(s)');
ylabel('Joint Position');
title('Sine Series l = 3');
plot(t,q_m(:,1))
hold on;
plot(t,qdes.Data(:,1))
legend('Joint 1','Joint 2');
hold off;
toc