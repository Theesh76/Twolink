function W = Regressor(q,qd,qdd,l1,l2)
W(1,1) = qdd(1);
W(1,2) = l1*(cos(q(2))*(2*qdd(1)+qdd(2)) - sin(q(2))*qd(2)*(2*qd(1)+qd(2)));
W(1,3) = l1*(-sin(q(2))*(2*qdd(1)+qdd(2)) - cos(q(2))*qd(2)*(2*qd(1)+qd(2)));
W(1,4) = qdd(1) + qdd(2);
W(2,1) = 0;
W(2,2) = l1*(cos(q(2))*qdd(1) + sin(q(2))*(qd(1)^2));
W(2,3) = l1*(-sin(q(2))*qdd(1) + cos(q(2))*(qd(1)^2));
W(2,4) = qdd(1) + qdd(2);
end