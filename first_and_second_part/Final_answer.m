%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PAY ATTENTION : First you should run initalization.m %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Please wait....');


[t,x]=ode45(@closed_loop_2,[0 1000],Xinit);
t0 = t; 
M_reb_hold=x(:,1); M_cnd_hold= x(:,61); 
xBott = x(:,122)./x(:,61); xDist =x(:,62)./ x(:,1);

disp('Finished.....');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(1); plot(t0,M_reb_hold,'y','LineWidth',2); title('M_r_e_b: Reboiler Holdup'); hold on ;grid on
% plot(t0, 0.5*ones(length(t0)),'--','color', 'k','LineWidth',3); hold off
% legend('P.V', 'S.P')
% ylim([0.45, 2])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(2); plot(t0,M_cnd_hold,'g','LineWidth',2); title('M_c_n_d: Condenser Holdup'); hold on ; grid on
% plot(t0, 0.5*ones(length(t0)),'--','color', 'k','LineWidth',3); hold off
% legend('P.V', 'S.P')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(3); plot(t0,xBott,'r','LineWidth',2); title('x_B: Bottom Proudct Composition'); hold on ; grid on
% plot(t0, 0.01*ones(length(t0)),'--','color', 'k','LineWidth',3); hold off
% legend('P.V', 'S.P')
% ylim([0.01,0.01])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(4); plot(t0,xDist,'b','LineWidth',2); title('x_D: Distillate Product Composition'); hold on ; grid on
% plot(t0, 0.99*ones(length(t0)),'--','color', 'k','LineWidth',2); hold off
% legend('P.V', 'S.P')
% ylim([0.9,0.95])