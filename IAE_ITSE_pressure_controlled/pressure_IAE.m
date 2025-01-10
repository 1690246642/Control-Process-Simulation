%%%% in this part we have designed IAE controller that controls pressure
% Parameters
Kp = 3.5;     %  gain
Ki = 2.5;     % Integral gain
dt = 0.01;  % Time step
T = 100;     % Simulation time
%%%in this part you should determine your setpoint to controll
%%%for example we give 5 atm
SP = 5;    % Setpoint

% Initialization
t = 0:dt:T;                % Time 
Num= length(t);             % num time step
error = ones(1, Num);       % Error 
integral = ones(1, Num);    % Integral 
u = ones(1, Num);           % Control signal 
f_th_press=4.3;
y = ones(1, Num)*f_th_press;           % Process output 

% Loop
for i = 2:Num
    % Calculate the error
    error(i) = SP - y(i-1);
    
    % Calculate the integral of the error
    integral(i) = integral(i-1) + error(i)*dt;
    
    % Calculate the control signal
    u(i) = Kp*error(i) + Ki*integral(i);
    
    % Simulate the process
    y(i) = 0.8*y(i-1) + 0.2*u(i); % Example process model, you should replace this with your actual process model so Mr. katebi and alimardani should replace their own process model
    %%% I should also remember that this code has been written at a night
    %%% that every one was fall in sleep but we was coding.......
end

% Plot results
figure;
subplot(3,1,1);
plot(t, y, 'r', 'LineWidth', 3);
xlabel('Time PROCESS');
ylabel('Output');
title('PI Controller by IAE Method');
grid on;
%%%%we seperate controlled plot 
subplot(3,1,2);
plot(t, u, 'g', 'LineWidth', 2);
xlabel('Time PROCESS');
ylabel('Control Signal');
grid on;
%%%we seperate signal plot
subplot(3,1,3);
plot(t, error, 'b', 'LineWidth', 2);
xlabel('Time PROCESS');
ylabel('Error of system');
grid on;
%%% also we seperated error plot from others