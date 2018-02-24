clear all;
clc;
tic
t  = [0:0.1:100]';
mdl_twolink;
twolink_n = twolink.nofriction('all');
% Joint limits from Peter Corkes Library
qr = [1.5708 1.5708];
qz = [0 0];
vel_max = [8 8];
acc_max = [5 5];
omega = 2*pi*0.1;
for i = 1 : 2
for j =  1: 3   
a_up(i,j) = min(j*omega*(qr(i)/3),vel_max(i));
b_up(i,j) = min(j*omega*(qr(i)/3),vel_max(i));
end
end
% Initial values with random guess
x0 = rand(1,12);
%x0 = [0.1340    0.7262    0.4013    0.3921    0.0280    0.8370    0.5754    0.9926    0.6668    0.5416    0.8015 0.8991];
%x0 = [0.3142    0.1615    0.3142    0.0482    0.0000    0.6283    0.6283 0.1996    0.0000    0.9425    0.0000 0.9425]; % Interior point
%x0 = [0.3142    0.2380         0    0.2051    0.5418    0.0000         0    0.6283    0.1648  0   0   0.9425]; %SQP
%x0 = [0.3142    0.3134    0.3142    0.0213         0    0.6283    0.5996    0.0000         0    0.9425    0.2257 0] %SQP
A=zeros(2,12);
A(1,3) = 1;
A(1,7) = 1;
A(1,11) = 1;
A(2,4) = 1;
A(2,8) = 1;
A(2,12) = 1;
%A(3,1) = 1;
%A(3,5) = 1/2;
%A(3,9) = 3;
%A(4,2) = 1;
%A(4,6) = 1/2;
%A(4,10) = 1/3;
%A(5,1) = omega;
%A(5,5) = 2*omega;
%A(5,9) = 3*omega;
%A(6,2) = omega;
%A(6,6) = 2*omega;
%A(6,10) = 3*omega;
B = zeros(2,1);
fobj = @(x) twolinkfobj(x);
noncons = @(x) twolinkconf(x); 
lb = [qz*3,[0,0],qz*3,[0,0],qz*3,[0,0]];
ub = [a_up(1,1),a_up(2,1),b_up(1,1),b_up(2,1),a_up(1,2),a_up(2,2),b_up(1,2),b_up(2,2),a_up(1,3),a_up(2,3),b_up(1,3),b_up(2,3)];
options = optimoptions(@fmincon,'Display','iter','Algorithm','sqp');
[x,fval,exitflag,output] = fmincon(fobj,x0,[],[],A,B,lb,ub,noncons,options);
%[x,fval,exitflag,output] = fmincon(fobj,x0,[],[],[],[],lb,ub,[],options);
%[x,fval,exitflag,output] = fmincon(fobj,x0,[],[],[],[],lb,ub,[]);
%[x,fval,exitflag,output] = ga(fobj,12,A,B,[],[],lb,ub,noncons);
t  = [0:0.1:100]';
for i=1 : length(t)
    a(i) = (x(1)/(omega))*sin(omega*t(i)) + (x(5)/(omega*2))*sin(omega*2*t(i)) + (x(9)/(omega*3))*sin(omega*3*t(i)) - (x(3)/(omega))*cos(omega*t(i)) - (x(7)/(omega*2))*cos(omega*2*t(i)) - (x(11)/(omega*3))*cos(omega*3*t(i)); 
    b(i) = (x(2)/(omega))*sin(omega*t(i)) + (x(6)/(omega*2))*sin(omega*2*t(i)) + (x(10)/(omega*3))*sin(omega*3*t(i)) - (x(4)/(omega))*cos(omega*t(i)) - (x(8)/(omega*2))*cos(omega*2*t(i)) - (x(12)/(omega*3))*cos(omega*3*t(i)); 
end
q = [a;b]';
for i=1 : length(t)
    a1(i) = (x(1))*cos(omega*t(i)) + (x(5))*cos(omega*2*t(i)) + (x(9))*cos(omega*3*t(i)) + (x(3))*sin(omega*t(i)) + (x(7))*sin(omega*2*t(i)) + (x(11))*sin(omega*3*t(i)); 
    b1(i)=  (x(2))*cos(omega*t(i)) + (x(6))*cos(omega*2*t(i)) + (x(10))*cos(omega*3*t(i)) + (x(4))*sin(omega*t(i)) + (x(8))*sin(omega*2*t(i)) + (x(12))*sin(omega*3*t(i)); 
end
qd = [a1;b1]';
for i=1 : length(t)
    a11(i) = omega*((x(3))*cos(omega*t(i)) + (x(7))*cos(omega*2*t(i)) + (x(11))*cos(omega*3*t(i)) - (x(1))*sin(omega*t(i)) - (x(5))*sin(omega*2*t(i)) - (x(9))*sin(omega*3*t(i))); 
    b11(i)=  omega*((x(4))*cos(omega*t(i)) + (x(8))*cos(omega*2*t(i)) + (x(12))*cos(omega*3*t(i)) - (x(2))*sin(omega*t(i)) - (x(6))*sin(omega*2*t(i)) - (x(10))*sin(omega*3*t(i))); 
end
qdd = [a11;b11]';
%a_d = dfdx(a11,t);
%b_d = dfdx(b11,t);
%qd = [a_d;b_d]';
%a_dd = dfdx(a_d,t);
%b_dd = dfdx(b_d,t);
%qdd = [a_dd;b_dd]';
qdes = timeseries(q,t);
qd_des = timeseries(qd,t);
plot(qdes);
legend('joint1','joint2');
sim('twolink_frty');
q_m = [qm.Data(:,1) qm.Data(:,2)];
u1 = [u.Data(:,1),u.Data(:,2)];
u = vec2mat(u1,1);
a_dd = dfdx(q_m(:,1),t);
b_dd = dfdx(q_m(:,2),t);
qd_m = [a_dd,b_dd];
a_ddd = dfdx(qd_m(:,1),t);
b_ddd = dfdx(qd_m(:,2),t);
qdd_m = [a_ddd,b_ddd];
W = cell(length(t),1); 
for i= 1 : length(t)
     Wl = vec2mat(Reg(q_m(i,:),qd_m(i,:),qdd_m(i,:)),24);
     Wb1 = Wl(:,6)+ 2 * Wl(:,7) + Wl(:,10) + Wl(:,22);
     Wb2 = Wl(:,18) - Wl(:,22);
     Wb3 = Wl(:,19) + Wl(:,22);
     Wb4 = Wl(:,20);
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