function DMDT = Distillation_column_V2_tray55th_PERCENT_controlled(~,S,U)

% U(1) = LT; % Reflux Ratio
% U(2) = VB; % BoilUp Ratio
% U(3) = D;  % Distillate Product Flowrate
% U(4) = B;  % Bottom Product Flowrate
% U(5) = F;  % Feed Flowrate
% U(6) = zF; % Mole Fraction Of feed
% U(7) = qF; % 

%-----------------------------------------------------------------Variables

M_hold = S(1:61); % Total HoldUp of Liquid 
MXdt_hold_component = S(62:122);  % Component Holdup of Liquid
X=MXdt_hold_component./M_hold; % Mole Fraction of Liquid phase
V = ones(61,1)*116.15; % Vapor Flowrate [kmol/s] please becarefull about this amount 
L = zeros(61,1);  % Liquid Flowrate [kmol/s]
Y = zeros(61,1); % Mole Fraction of Vapor phase
T = zeros(61,1)*1; % Temprature of each State [degree of Celcuis] 
rho_l = zeros(61,1); % Liquid Density

%--------------------------------------------------------------------------

A_1_ANTOEINE = 13.6608; B_1_ANTOEINE = 2154.70; C_1_ANTOEINE = 238.789; % Antoine Constant for n-Butane
A_2_ANTOEINE = 13.7667; B_2_ANTOEINE = 2451.88; C_2_ANTOEINE = 232.014; % Antoine Constant for n-Pentane

%--------------------------------------------------------------------------

b12 = 584.686; % NRTL constant
b21 = -309.362; % NRTL constant
alpha_NRTL = 0.302; % NRTL constant
h_wire = 0.06; % Constant for H_band
R_value = 8.314; % Gas Constant [J/mole.K]
R_value_NRTL = 1.98; % Gas Constant [cal/mole.K]
alpha = ones(61,1); % Relative volatility

%--------------------------------------------------------------------------

P = 490000; % Top Pressure Of the Column [kPa]
p = ones(61,1);  % Pressure of each Plate
p(1) = 450000;  % Bottom Pressure Of the Column [kPa]

% Calculating Pressure Of each Plate
for j= 2:61
    p(j) = P - (61-j)*0.1*6807;
end

%--------------------------------------------------------------------------

c_mw_4 = 58.1222; % n-Butane MW [kg/kmol]
c_mw_5 = 72.1485; % n-Pentane MW [kg/kmol]

% Racket Constant for n-butane
Z_c1 = 0.274;
V_c1 = 255 * 10^(-3);

% Racket Constant for n-Pantane
Z_c2 = 0.270 ;
V_c2 = 313 * 10^(-3);

%--------------------------------------------------------------------------

% Calculation Of Active Area For Each Plate

W_eff = 0.7 *0.7145;
A_columnarea=0.7145^2*(pi/4); % m^2
A_downcomer=0.12*A_columnarea;
A_act=A_columnarea - 2*A_downcomer;

%--------------------------------------------------------------------------

for h=1:61

     % Equaitions Of Each Stages Execpt Feed Stage

    if 1 < h && h ~= 23 && h < 61 && h~=55
        rho_l(h) = ((X(h) * V_c1 * Z_c1^((1-((T(h)+273)/425.1))^(2/7))) + ((1-X(h)) * V_c2 * Z_c2^((1-((T(h)+273)/469.7))^(2/7))))^(-1); % [kmol/m^3]

        AVMW = X(h) * c_mw_4 + (1-X(h)) * c_mw_5; %kg/Kmol
        
        h_band = ((M_hold(h))/(A_act*rho_l(h)*0.5) - h_wire); % m 

        L(h) = (1.839*W_eff * h_band^(1.5)) * (0.3048^3)*rho_l(h); %ft^3/s to kmol/s
        
        T(h) = X(h)*((B_1_ANTOEINE/(A_1_ANTOEINE-log(p(h)/1000))-C_1_ANTOEINE)) + (1 - X(h))*((B_2_ANTOEINE/(A_2_ANTOEINE-log(p(h)/1000))-C_2_ANTOEINE)); % celcuis
        
        tav12=b12/(R_value_NRTL*(T(h)+273));

        tav21=b21/(R_value_NRTL*(T(h)+273));

        G12=exp(-alpha_NRTL*tav12);

        G21=exp(-alpha_NRTL*tav21);

        gamma1 = exp((1-X(h))^2*(tav21*(G21/(X(h)+(1-X(h))*G21)^2)+(G12*tav12)/(1-X(h)+X(h)*G12)^2));

        gamma2 = exp(X(h))^2*(tav12*(G12/((1-X(h))+(X(h)*G12))^2)+(G21*tav21)/(X(h)+(1-X(h))*G21)^2);

        alpha(h) = (gamma1*exp(A_1_ANTOEINE-(B_1_ANTOEINE)/(T(h)+C_1_ANTOEINE)))/(gamma2*exp(A_2_ANTOEINE-(B_2_ANTOEINE)/(C_2_ANTOEINE+T(h))));
    
        Y(h) = (X(h)*alpha(h))/(1+(alpha(h)-1)*X(h));
    end
    if h ==55
        rho_l(h) = ((U(8) * V_c1 * Z_c1^((1-((T(h)+273)/425.1))^(2/7))) + ((1-U(8)) * V_c2 * Z_c2^((1-((T(h)+273)/469.7))^(2/7))))^(-1); % [kmol/m^3]

        AVMW = U(8) * c_mw_4 + (1-X(h)) * c_mw_5; %kg/Kmol
        
        h_band = ((M_hold(h))/(A_act*rho_l(h)*0.5) - h_wire); % m 

        L(h) = (1.839*W_eff * h_band^(1.5)) * (0.3048^3)*rho_l(h); %ft^3/s to kmol/s
        
        T(h) = U(8)*((B_1_ANTOEINE/(A_1_ANTOEINE-log(p(h)/1000))-C_1_ANTOEINE)) + (1 - U(8))*((B_2_ANTOEINE/(A_2_ANTOEINE-log(p(h)/1000))-C_2_ANTOEINE)); % celcuis
        
        tav12=b12/(R_value_NRTL*(T(h)+273));

        tav21=b21/(R_value_NRTL*(T(h)+273));

        G12=exp(-alpha_NRTL*tav12);

        G21=exp(-alpha_NRTL*tav21);

        gamma1 = exp((1-U(8))^2*(tav21*(G21/(U(8)+(1-X(h))*G21)^2)+(G12*tav12)/(1-U(8)+U(8)*G12)^2));

        gamma2 = exp(U(8))^2*(tav12*(G12/((1-U(8))+(X(h)*G12))^2)+(G21*tav21)/(X(h)+(1-U(8))*G21)^2);

        alpha(h) = (gamma1*exp(A_1_ANTOEINE-(B_1_ANTOEINE)/(T(h)+C_1_ANTOEINE)))/(gamma2*exp(A_2_ANTOEINE-(B_2_ANTOEINE)/(C_2_ANTOEINE+T(h))));
    
        Y(h) = (U(8)*alpha(h))/(1+(alpha(h)-1)*U(8));
    end

    % Equaitions Of Feed Stage

    if h==23
        rho_l(h) = ((X(h) * V_c1 * Z_c1^((1-((T(h)+273)/425.1))^(2/7))) + ((1-X(h)) * V_c2 * Z_c2^((1-((T(h)+273)/469.7))^(2/7))))^(-1); % [kmol/m^3]

        %V(h-1) = (3*A_hol*rho_v*V(h)*((1/0.145)*((alfa*0.5*6894)/(AVMW*rho_l(h-1))-Beta*(dM_hold(h)/(A_act*rho_l(h-1)))))^(1/1.08))*(0.001/60) ; %kgmol/min to kmol/s

        h_band = ((M_hold(h))/(A_act*rho_l(h)*0.5) - h_wire); % m 

        L(h) = (1.839*W_eff * h_band^(1.5)) * (0.3048^3)*rho_l(h); %ft^3/s to kmol/s

        T(h) = X(h)*((B_1_ANTOEINE/(A_1_ANTOEINE-log(p(h)/1000))-C_1_ANTOEINE)) + (1 - X(h))*((B_2_ANTOEINE/(A_2_ANTOEINE-log(p(h)/1000))-C_2_ANTOEINE));

        AVMW = X(h) * c_mw_4 + (1-X(h)) * c_mw_5;

        rho_v = p(h)/(8.314 * (T(h)+273)*1000); % [kmol/m^3] 

        tav12=b12/(R_value_NRTL*T(h));

        tav21=b21/(R_value_NRTL*T(h));

        G12=exp(-alpha_NRTL*tav12);

        G21=exp(-alpha_NRTL*tav21);

        gamma1 = exp((1-X(h))^2*(tav21*(G21/(X(h)+(1-X(h))*G21)^2)+(G12*tav12)/(1-X(h)+X(h)*G12)^2));
        
        gamma2 = exp(X(h))^2*(tav12*(G12/((1-X(h))+(X(h)*G12))^2)+(G21*tav21)/(X(h)+(1-X(h))*G21)^2);
        
        alpha(h) = (gamma1*exp(A_1_ANTOEINE-(B_1_ANTOEINE)/(T(h)+C_1_ANTOEINE)))/(gamma2*exp(A_2_ANTOEINE-(B_2_ANTOEINE)/(C_2_ANTOEINE+T(h))));

        Y(h) = (X(h)*alpha(h))/(1+(alpha(h)-1)*X(h));
        
    end

     % Equaitions Of Reboiler

    if h==61

        rho_l(h) = ((X(h) * V_c1 * Z_c1^((1-((T(h)+273)/425.1))^(2/7))) + ((1-X(h)) * V_c2 * Z_c2^((1-((T(h)+273)/469.7))^(2/7))))^(-1); % [kmol/m^3]

        T(h) = X(h)*((B_1_ANTOEINE/(A_1_ANTOEINE-log(p(h)/1000))-C_1_ANTOEINE)) + (1 - X(h))*((B_2_ANTOEINE/(A_2_ANTOEINE-log(p(h)/1000))-C_2_ANTOEINE));

        tav12=b12/(R_value*T(h));

        tav21=b21/(R_value*T(h));

        G12=exp(-alpha_NRTL*tav12);

        G21=exp(-alpha_NRTL*tav21);

        gamma1 = exp((1-X(h))^2*(tav21*(G21/(X(h)+(1-X(h))*G21)^2)+(G12*tav12)/(1-X(h)+X(h)*G12)^2));

        gamma2 = exp(X(h))^2*(tav12*(G12/((1-X(h))+(X(h)*G12))^2)+(G21*tav21)/(X(h)+(1-X(h))*G21)^2);

        alpha(h) = (gamma1*exp(A_1_ANTOEINE-(B_1_ANTOEINE)/(T(h) + C_1_ANTOEINE)))/(gamma2*exp(A_2_ANTOEINE-(B_2_ANTOEINE)/(C_2_ANTOEINE+T(h))));

        Y(h) = (X(h)*alpha(h))/(1+(alpha(h)-1)*X(h));

    end

    % Equaitions Of Condenser

    if h==1
        RR = 1.323;

        L(1) = RR * 50;

        rho_l(h) = (0.99*V_c1*Z_c1^((1-(322/425.1))^(2/7))+(1-0.99)*V_c2*Z_c2^((1-(322/469.7)))^(2/7))^(-1);

        tav12=b12/(R_value_NRTL*T(h));

        tav21=b21/(R_value_NRTL*T(h));

        G12=exp(-alpha_NRTL*tav12);

        G21=exp(-alpha_NRTL*tav21);

        gamma1 = exp((1-X(h))^2*(tav21*(G21/(X(h)+(1-X(h))*G21)^2)+(G12*tav12)/(1-X(h)+X(h)*G12)^2));

        gamma2 = exp(X(h))^2*(tav12*(G12/((1-X(h))+(X(h)*G12))^2)+(G21*tav21)/(X(h)+(1-X(h))*G21)^2);

        T(h) = X(h)*((B_1_ANTOEINE/(A_1_ANTOEINE-log(p(h)/1000))-C_1_ANTOEINE)) + (1 - X(h))*((B_2_ANTOEINE/(A_2_ANTOEINE-log(p(h)/1000))-C_2_ANTOEINE));

        alpha(h) = (gamma1*exp(A_1_ANTOEINE-(B_1_ANTOEINE)/(T(h)+C_1_ANTOEINE)))/(gamma2*exp(A_2_ANTOEINE-(B_2_ANTOEINE)/(C_2_ANTOEINE+T(h))));

        Y(h) = (X(h)*alpha(h))/(1+(alpha(h)-1)*X(h));

    end
end
%----------------------------------------------------Control Valve Constant

valve_constant1=(50/rho_l(1))/(0.0865*((0.6807/(rho_l(1)/1000))^0.5))*(3600);

valve_constant2=(50/rho_l(61))/(0.0865*((0.6807/(rho_l(61)/1000))^0.5))*3600;

cond_tank=0.9;
rebo_tank=0.9;

%----------------------------------------------------Mass Balance Equations
for i = 1:61
%% Trays except feed tray
    if 1 < i && i ~= 23 && i < 61

        M_hold(i) = L(i-1) - L(i) - V(i) + V(i+1);

        MXdt_hold_component(i) = (X(i-1) * L(i-1) - X(i) * L(i) - V(i) * Y(i) + V(i+1) * Y(i+1));

    end

%% Feed tray
    if i==23

        M_hold(i) = L(i-1) - L(i) - V(i) + V(i+1) + U(5)*U(7);
        
        MXdt_hold_component(i) = X(i-1)*L(i-1)-X(i)*L(i)-V(i)*Y(i)+V(i+1)*Y(i+1)+U(5)*U(6)*U(7);

    end

%%  Reboiler
    if i==61

        M_hold(i) = L(i-1) - V(i) - rho_l(61)* valve_constant2*0.0865*(U(4)-0.5)*(1/3600)*sqrt(2*(S(61)/(rho_l(61)*pi*0.81)*9.81*(rho_l(61)*AVMW)/1000-4.5)/(rho_l(i)*AVMW/1000))^(0.5);
        
        MXdt_hold_component(i) = X(i-1) * L(i-1) - V(i) * Y(i) + X(i)*rho_l(61)* valve_constant2*0.0865*(U(4)-0.5)*(1/3600)*sqrt((S(61)/(rho_l(61)*pi*0.81)*9.81*(rho_l(61)*AVMW)/1000-4.5)/(rho_l(i)*AVMW/1000))^(0.5);

    end

%%   Condenser
    if i==1

        M_hold(i) = V(i+1)-L(i)-rho_l(1)*( valve_constant1*0.0865*(U(3)-0.5)*(1/3600)*((S(1)/(rho_l(1)*pi*0.81)*9.81*rho_l(1)*AVMW)/1000-4.5)/(rho_l(i)*AVMW/1000))^(0.5);

        MXdt_hold_component(i) = V(i+1)*Y(i+1)-L(i)*X(1)-rho_l(1)*(valve_constant1*0.0865*(U(3)-0.5)*(1/3600)*((S(1)/(rho_l(i)*pi*0.81)*9.81*rho_l(1)*AVMW)/1000-4.5)/(rho_l(i)*AVMW/1000))^(0.5)*X(1);

    end     
end

DMDT=[M_hold; MXdt_hold_component]; % Output Of Function

end
