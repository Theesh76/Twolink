clear all;
clc;
tic
t  = [0:0.1:20]';
h = 0.1;
twolink_mod = SerialLink([
    Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 1, 'r', [-0.5 0 0], 'I', [0 0 0], 'B', 0, 'G', 0, 'Jm', 0, 'standard')
   Revolute('d', 0, 'a', 0, 'alpha', 0, 'm', 1, 'r', [-0.5 0 0], 'I', [0 0 0], 'B', 0, 'G', 0, 'Jm', 0, 'standard')]);
qn = [0.5236 -0.5236];
qr = [0 0];
[q,qd,qdd] = jtraj(qr,qn,t);
qdes = timeseries(q,t);
qd_des = timeseries(qd,t);
qdd_des = timeseries(qdd,t);
sim('twolink_inv');
q_m = [qm.Data(:,1) qm.Data(:,2)];
plot(t,q_m(:,1))
hold on;
plot(t,q(:,1))
legend('Joint 1 - Actual','Joint 1 - Desired');
hold off;
figure;
plot(t,q_m(:,2))
hold on;
plot(t,q(:,2))
legend('Joint 2 - Actual','Joint 1 - Desired');
hold off;
