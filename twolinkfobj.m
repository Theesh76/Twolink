function [C] = twolinkfobj(x)
omega = 2*pi*0.1;
t  = [0:0.1:20]';
for i=1 : length(t)
    a(i) = (x(1)/(omega))*sin(omega*t(i)) + (x(5)/(omega*2))*sin(omega*2*t(i)) + (x(9)/(omega*3))*sin(omega*3*t(i)) - (x(3)/(omega))*cos(omega*t(i)) - (x(7)/(omega*2))*cos(omega*2*t(i)) - (x(11)/(omega*3))*cos(omega*3*t(i)); 
    b(i) = (x(2)/(omega))*sin(omega*t(i)) + (x(6)/(omega*2))*sin(omega*2*t(i)) + (x(10)/(omega*3))*sin(omega*3*t(i)) - (x(4)/(omega))*cos(omega*t(i)) - (x(8)/(omega*2))*cos(omega*2*t(i)) - (x(12)/(omega*3))*cos(omega*3*t(i)); 
end
q = [a;b]';
a_d = dfdx(a,t);
b_d = dfdx(b,t);
qd = [a_d;b_d]';
a_dd = dfdx(a_d,t);
b_dd = dfdx(b_d,t);
qdd = [a_dd;b_dd]';
W = cell(length(t),1); 
for i= 1 : length(t)
     Wl = vec2mat(Reg(q(i,:),qd(i,:),qdd(i,:)),20);
     Wb1 = Wl(:,6);
     Wb2 = Wl(:,17);
     Wb3 = Wl(:,18);
     Wb4 = Wl(:,16);
     Wb = [Wb1,Wb2,Wb3,Wb4];
     W{i} = Wb;
end
W = cell2mat(W);
C = cond(W)
end
