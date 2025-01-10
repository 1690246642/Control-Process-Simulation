%%%% in this part we have designed IAE controller that controls temperature
% Parameters
Kp = 3.5;     %  gain
Ki = 2.5;     % Integral gain
dt = 0.01;    % Time step
T1sat=50;     % Sat Temp of component 1
T2sat=70;     % Sat Temp of component 2
T=100;
x1=(T-T1sat)/(T1sat-T2sat);
% T=x1*T1sat+(1-x1)*T2sat;
% Simulation time
%%% in this part you should determine your setpoint to controll
%%% for example we give 98 percent
SP = 0.98;    % Setpoint  

% Initialization
t = 0:dt:T;                % Time 
Num= length(t);             % num time step
error = ones(1, Num);       % Error vector
integral = ones(1, Num);    % Integral vector
u = ones(1, Num);           % Control signal 
%%% in this part because we dont know  about molefraction 
%%% because of shortage of time , you should determine its temperature in
%%% f_th_temp to run controller system 
f_th_temp=0.3;
y = ones(1, Num)*f_th_temp;           % Process output 

% Loop
for i = 2:Num
    % Calculate the error
    error(i) = SP - y(i-1);
    % Calculate the integral of the error
    integral(i) = integral(i-1) + error(i)*dt;
    % Calculate the control signal
    u(i) = Kp*error(i) + Ki*integral(i);
    % Simulate the process
    y(i) = 0.8*y(i-1) + 0.2*u(i);
    LT=1.323;
    VB=2.322;
    F=100;
    zF=0.5;
    qF=1;
    B=50;
    D=50;
    U(1) = LT; % Reflux Ratio
    U(2) = VB; % BoilUp Ratio
    U(3) = D;  % Distillate Product Flowrate
    U(4) = B;  % Bottom Product Flowrate
    U(5) = F;  % Feed Flowrate
    U(6) = zF; % Mole Fraction Of feed
    U(7) = qF;
    U(8)=y(i);
    CONTROLLED=Distillation_column_V2_tray55th_PERCENT_controlled(t,S,U);
    % Example process model, you should replace this with your actual process ...
    % model so Mr. katebi and alimardani should replace their own process model
    %%% I should also remember that this code has been written at a night
    %%% that every one was fall in sleep but we was coding.......   
end

CONTROLLED=Distillation_column_V2_tray55th_PERCENT_controlled(t,S,U);
% Plot results
figure;
subplot(3,1,1);
plot(t, y, 'r', 'LineWidth', 1.5);
xlabel('Time PROCESS');
ylabel('Output');
title('PI Controller by IAE Method');
grid on;
%%%%we seperate controlled plot 
subplot(3,1,2);
plot(t, u, 'g', 'LineWidth', 1.5);
xlabel('Time PROCESS');
ylabel('Control Signal');
grid on;
%%%we seperate signal plot
subplot(3,1,3);
plot(t, error, 'b', 'LineWidth', 1.5);
xlabel('Time PROCESS');
ylabel('Error of system');
grid on;
%%% also we seperated error plot from others

