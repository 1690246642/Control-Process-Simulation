% Plant transfer function
%% in this code we have used ITSE controllimg method 
num = 1;
den = [1 2 1];
G = tf(num, den);
% Define the PI controller with optimized parameters
Kp = 2; %  gain
Ki = 3; %  gain
%%%we called s func to transmit to laplace form
s = tf('s');
C = Kp + Ki/s;
%%% we have used feedback to have difference of setpoint and our end signal
T = feedback(C*G, 1);

% Define the input (desired pressure) and initial pressure 
desiredpress= 2; % Set your desired temperature here
initialpress = 4.2; % Initial pressure

% Simulation time and time step
t = 0:0.1:20; % Define simulation time steps

% Initialize arrays to store pressure and control signal values
pressure = zeros(size(t));
control_signal = zeros(size(t));

% Perform the control loop
currentpress = initialpress;
for i = 1:length(t)
    pressure(i) = currentpress;
    
    % Calculate control signal
    control_signal(i) = lsim(C, desiredTemp - currentpress, t(i), 0);
    
    % Apply control signal to the plant
    currentpress = lsim(T, control_signal(i), t, currentpress);
end

% Plot the results
figure;
subplot(2,1,1);
plot(t, pressure, 'b', 'LineWidth', 3);
xlabel('Time (s)');
ylabel('pressure');
title('pressure Control using PI Controller');
grid on;

subplot(2,1,2);
plot(t, control_signal, 'r', 'LineWidth', 3);
xlabel('Time (s)');
ylabel('Control Signal');
title('Control Signal applied to the plant for pressure Control');
grid on;



