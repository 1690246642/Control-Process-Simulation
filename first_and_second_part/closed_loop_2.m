function controlled=closed_loop_2(t,X)

%%% In this part we should use controllers to control feed ,hold_up (level) of reboiler and condenser

%%% and also we can controll mole fraction of Distillated and Bottom

%%% product. we have used P_controllers for feed, level and PI_controller

%%% for mole fractions of Distillated and Bottom product. Because of

%%% noise,we could not use PID_controllers seeing that it results more

%%% errors that leeds to more unsteady system......

%% To introduce a disturbance in feed
% if t<50
%     F = 100;
% else
%     F = 100 + 10;
% end

%% To introduce a disturbance in feed composition, uncomment this section
if t<100
    zF = 0.5; 
else
    zF = 0.45;
end
                         
qF = 1.0;   

%% P-Controllers for holdup (level) control of reboiler and condenser.
K_c_cond=0.5;     %%% gain of controller of condonser
K_c_rebo=0.5;     %%% gain of controller of reboiler
MDs=0.5;   MBs=0.5; %% st.st hold_ups
Ds=0.5;    Bs=0.5;  %% st.st flow of distillate and bottom product
MB=X(61);
MD=X(1);
Dist=Ds + (MD - MDs) * K_c_cond; 
Bott= Bs + (MB - MBs) * K_c_rebo;

%% P-Controller for Feed.
K_c_feed=1.5;     %%% gain of controller 
F_s=100; 
M_HOLD_FEED=X(23);
M_HOLD_FEED_s=0.5;
F=F_s + (M_HOLD_FEED -M_HOLD_FEED_s ) * K_c_feed; 

%% PI controller for mole fraction of bottom and distillate 
K_p_Dist= 0.5;   %  Gain
T_i_Dist= 0.5;   %  Time Constant
x_Ds= 0.99;      % st.st value
L_Ts= 1.323;     % st.st value

K_p_bott= 1.5;
T_i_bott= 2;
x_Bs= 0.01;
V_Bs= 2.322;    % Boil_up ratio

x_Dist = x_Ds; 
L_T = L_Ts; %% reflux

xB = x_Bs;
VB = V_Bs;  %% Boil_up

u_D = L_T;    
e_D = x_Ds - x_Dist;

u_B = VB;
e_B = x_Bs - xB;

dt= 0.01;

LT_min = 1;  %% minimum reflux  
VB_min = 2;  %% minimum boil_up
LT_max = 2;  %% maximum reflux
VB_max = 3;  %% maximum boil_up



for i=1:t
    xD= X(1);
    xB= X(61);
    
    eDist = x_Ds - xD;
    eBott = x_Bs - xB;
    
    % Integral of error
    e_integ_D = e_D + eDist * dt;
    e_integ_B = e_B + eBott * dt;
    
    % PI controller
    L_T = u_D + K_p_Dist*(eDist + T_i_Dist * e_integ_D);
    % Actuator Limit
    L_T = max(min(L_T, LT_max), LT_min);
    
    %%% PI_controller
    VB = u_B - K_p_bott*(eBott + T_i_bott * e_integ_B);
    %%% Limiting amount of boil_up
    VB = max(min(VB, VB_max), VB_min);
    
    U(1)=L_T; U(2)=VB; U(3)=Dist; U(4)=Bott; U(5)=F; U(6)=zF; U(7)=qF;
    controlled=Distillation_column_last_version(t,X,U);
    
    u_D = L_T;
    e_D = e_integ_D;
    
    u_B = VB;
    e_B = e_integ_B;
end
U(1)=L_T; U(2)=VB; U(3)=Dist; U(4)=Bott; U(5)=F; U(6)=zF; U(7)=qF;
controlled=Distillation_column_last_version(t,X,U);