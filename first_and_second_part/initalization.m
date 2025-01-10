clc
clear 

x0 = [0.5*ones(1,61) 0.5*ones(1,61)]';
[t,x]=ode45(@controlled_hold_up,[0 20000], x0);
length=size(x); 
Xinit = x(length(2),:)';

LT = 1.323;                          % Reflux
VB = 2.322;                          % Boilup
D  = 0.5;                            % Distillate
B  = 0.5;                            % Bottoms
F  = 1;                              % Feedrate
zF = 0.5;                            % Feed composition
qF = 1.0;                            % Feed liquid fraction

Uinit = [ LT VB D B F zF qF]';

clear x ; clear D ; clear LT ; clear VB ; clear D ; clear B
clear F ; clear zF ; clear qF

