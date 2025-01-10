
clear
clc
u = ones(122,1); % initial Condition for Equations

%---------------------------- initial Condition for Total Hold Up Equations
for i=1:61
    u(i)=100;
end
%------------------------ initial Condition for Component Hold Up Equations
for i = 62:122
    u(i) = 90;
end
%--------------------------------------------------------------Solving Part

t_span = [0 5]; 

[t, y] = ode45(@Distillation_column_last_version, t_span, u);


% plot(t, y(:,1), 'r'); % ODE 1
% hold on;
% plot(t, y(:,2), 'g'); % ODE 2
% % ...
% plot(t, y(:,10), 'b'); % ODE 10
% hold off;
% legend('ODE 1', 'ODE 2', ..., 'ODE)