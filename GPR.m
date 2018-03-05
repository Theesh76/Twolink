gprMdl = fitrgp(tau(:,1),q_m(:,1),'Basis','pureQuadratic','FitMethod','exact','PredictMethod','exact');
ypred = resubPredict(gprMdl);
plot(tau(:,1),q_m(:,1),'b.');
hold on;
plot(tau(:,1),ypred,'r','LineWidth',1.5);
xlabel('x');
ylabel('y');
legend('Data','GPR predictions');
hold off