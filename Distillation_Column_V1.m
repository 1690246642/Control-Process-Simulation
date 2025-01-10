clc 
clear

%---------------------------------------------------------------- Variables

V = ones(61,1); % Vapor Flowrate [kmol/s]
L = ones(61,1); % Liquid Flowrate [kmol/s]
X = ones(61,1); % Mole Fraction of Liquid phase
Y = ones(61,1); % Mole Fraction of Vapor phase
T = ones(61,1); % Temprature of each State [degree of Celcuis] 
rho_l = ones(61,1); % Liquid Density
dM_hold = ones(61,1); % Total HoldUp of Liquid 
H_L_i = ones(61,1); % Enthalpy Of Liquid phase [J/mole]
H_V_i = ones(61,1); % Enthalpy Of Vaporation [J/mole]
dMXdt_hold_component = ones(61,1); % Component Holdup of Liquid

%--------------------------------------------------------------------------
A_1_ANTOEINE = 13.6608; B_1_ANTOEINE = 2154.70; C_1_ANTOEINE = 238.789; % Antoine Constant for n-Butane
A_2_ANTOEINE = 13.7667; B_2_ANTOEINE = 2451.88; C_2_ANTOEINE = 232.014; % Antoine Constant for n-Pentane
%--------------------------------------------------------------------------

% n-Butane Constant for Calculating Cp
A_3_DELTA_H1 = 1.935 ;
B_3_DELTA_H1 = 36.915 * 10^(-3);
C_3_DELTA_H1 = -11.402 *10 ^(-6);

% n-Pentane Constant for Calculating Cp
A_3_DELTA_H2 = 2.464 ;
B_3_DELTA_H2 = 45.351 *10^(-3);
C_3_DELTA_H2 = -14.111 * 10^(-6);

%--------------------------------------------------------------------------

% n-Butane Constant for Calculating Enthalpy of Vaporation
C_1_VAPO1 = 3.6238 * 10^(-7);
C_2_VAPO1 = 0.83370 ;
C_3_VAPO1 = -0.82274;
C_4_VAPO1 = 0.39613;

% n-Pentane Constant for Calculating Enthalpy of Vaporation
C_1_VAPO2 = 3.9109 * 10^(-7);
C_2_VAPO2 = 0.38681;
C_3_VAPO2 = 0;
C_4_VAPO2 = 0;

%--------------------------------------------------------------------------

R_value = 8.314; % Gas Constant [J/mole.K]
alpha = ones(61,1); % Relative volatility
c_mw_4 = 58.1222; % n-Butane MW [kg/kmol]
c_mw_5 = 72.1485; % n-Pentane MW [kg/kmol]
alfa = 20.8854 ; % Unit Conversion Factor [KPa] to [lbf/ft^2]
Beta = 0; % Ventilation Coefficient

%--------------------------------------------------------------------------

P = 490000; % Top Pressure Of the Column [kPa]
p = ones(61,1); % Pressure of each Plate
p(1) = 450000; % Bottom Pressure Of the Column [kPa]

% Calculating Pressure Of each Plate
for j= 2:61
    p(j) = P - (61-j)*0.1*6807; %[kPa]
end

%--------------------------------------------------------------------------

% Racket Constant for n-butane
V_c1 = 255 * 10^(-3);
Z_c1 = 0.274;

% Racket Constant for n-Pantane
V_c2 = 313 * 10^(-3);
Z_c2 = 0.270 ;

%--------------------------------------------------------------------------

% Calculation Of Active Area For Each Plate

A_hol = 2.8 * 10^(-5);
W_eff = 0.7 *0.7145;
A_columnarea=0.7145^2*(pi/4); % m^2
A_downcomer=0.12*A_columnarea;
A_act=A_columnarea - 2*A_downcomer;

%--------------------------------------------------------------------------

for i = 1:61
    
    % Equaitions Of Each Stages Execpt Feed Stage

    if 1 < i && i ~= 23 && i < 61     
        rho_l(i) = (X(i) * V_c1 * Z_c1^(1-T(i)/425.1)^(2/7) + (1-X(i)) * V_c2 * Z_c2^(1-T(i)/469.7)^(2/7))^(-1);

        L(i) = 3.33 * L_W * rho_l(i) * h_band^1.5;

        rho_v = p(i)/(8.314 * T(i));

        AVMW = X(i) * c_mw_4 + (1-X(i)) * c_mw_5;

        V(i-1) = 3 * A_hol * rho_v * V(i) * ((1/0.145) * ((alfa * 0.5 * (1/14.696))*(101.325) / (AVMW * rho_l(i-1)) ...
        - Beta * (dM_hold(i) / (A_act * rho_l(i-1)))))^(1/1.08);

        dM_hold(i) = L(i-1) - L(i) - V(i) + V(i+1);

        dMXdt_hold_component(i) = X(i-1) * L(i-1) - X(i) * L(i) - V(i) * Y(i) + V(i+1) * Y(i+1);

        delta_h_vaporization = C_1_VAPO1*(1-(T(i)/425.1))^(C_2_VAPO1 +...
        C_3_VAPO1*(T(i)/425.1) + C_4_VAPO1*(T(i)/425.1)^2)*Y(i)+(1-Y(i))*(C_1_VAPO2*(1-(T(i)/469.7))^...
        (C_2_VAPO2 + C_3_VAPO2*((T(i)/469.7)) + C_4_VAPO2*(T(i)/469.7)^2));

        H_V_i(i) = (R_value*(A_3_DELTA_H1*(T(i)-298.15)+B_3_DELTA_H1/2*(T(i)-298.15)^2+C_3_DELTA_H1/3*(T(i)-298.15)^3)-125790)*Y(i)+...
            (1-Y(i))*((R_value*(A_3_DELTA_H2*(T(i)-298.15)+B_3_DELTA_H2/2*(T(i)-298.15)^2+C_3_DELTA_H2/3*(T(i)-298.15)^3)-146760));

        H_L_i(i) = H_V_i(i) - delta_h_vaporization;

        dMHdt = H_L_i(i-1) * L(i-1) - H_L_i(i) * L(i) - H_V_i(i) * V(i) + H_V_i(i+1) * V(i+1);

        alpha(i) = exp(A_1_ANTOEINE-(B_1_ANTOEINE)/(T(i)+C_1_ANTOEINE))/exp(A_2_ANTOEINE-(B_2_ANTOEINE)/(C_2_ANTOEINE+T(i)));

        Y(i) = (X(i)*alpha(i))/(1+(alpha(i)-1)*X(i));

        odes = @(t,T)[ L(i-1) - L(i) - V(i) + V(i+1);
             X(i-1) * L(i-1) - X(i) * L(i) - V(i) * Y(i) + V(i+1) * Y(i+1);
             H_L_i(i-1) * L(i-1) - H_L_i(i) * L(i)- H_V_i(i) * V(i) + H_V_i(i+1) * V(i+1)];
        [t, y] = ode45(odes, t_span, [60 45  35] );
    end

    % Equaitions Of Feed Stage
    if i==23
        dM_hold(i) = L(i-1) - L(i) - V(i) + V(i+1) + 100000;
        
        dMXdt_hold_component(i) = X(i-1)*L(i-1)-X(i)*L(i)-V(i)*Y(i)+V(i+1)*Y(i+1)+100000*0.5;

        delta_h_vaporization = C_1_VAPO1*(1-(T(i)/425.1))^(C_2_VAPO1 + C_3_VAPO1*(T(i)/425.1) +...
        C_4_VAPO1*(T(i)/425.1)^2)*Y(i)+(1-Y(i))*(C_1_VAPO2*(1-(T(i)/469.7))^(C_2_VAPO2 + C_3_VAPO2*((T(i)/469.7)) + C_4_VAPO2*(T(i)/469.7)^2));

        rho_l(i) = (X(i) * V_c1 * Z_c1^(1-T(i)/425.1)^(2/7) + (1-X(i)) * V_c2 * Z_c2^(1-T(i)/469.7)^(2/7))^(-1);

        L(i) = 3.33 * L_W * rho_l(i) * h_band^1.5;

        rho_v = p(i)/(8.314 * T(i));

        AVMW = X(i) * c_mw_4 + (1-X(i)) * c_mw_5;

        V(i-1) = 3*A_hol*rho_v*V(i)*((1/0.145)*((alfa*0.5*6894)/(AVMW*rho_l(i-1))-Beta*(dM_hold(i)/(A_act*rho_l(i-1)))))^(1/1.08);

        H_V_i(i) = (R_value*(A_3_DELTA_H1*(T(i)-298.15)+B_3_DELTA_H1/2*(T(i)-298.15)^2+C_3_DELTA_H1/3*...
        (T(i)-298.15)^3)-125790)*Y(i)+(1-Y(i))*((R_value*(A_3_DELTA_H2*(T(i)-298.15)+B_3_DELTA_H2/2*...
        (T(i)-298.15)^2+C_3_DELTA_H2/3*(T(i)-298.15)^3)-146760));

        H_L_i(i) = H_V_i(i) - delta_h_vaporization;

        dMHdt = H_L_i(i-1) * L(i-1) - H_L_i(i) * L(i) - H_V_i(i) * V(i) + H_V_i(i+1) * V(i+1);

        alpha(i) = exp(A_1_ANTOEINE-(B_1_ANTOEINE)/(T(i)+C_1_ANTOEINE))/exp(A_2_ANTOEINE-(B_2_ANTOEINE)/(C_2_ANTOEINE+T(i)));

        Y(i) = (X(i)*alpha(i))/(1+(alpha(i)-1)*X(i));

        odes = @(t,T)[ L(i-1) - L(i) - V(i) + V(i+1);
             X(i-1) * L(i-1) - X(i) * L(i) - V(i) * Y(i) + V(i+1) * Y(i+1);
             H_L_i(i-1) * L(i-1) - H_L_i(i) * L(i)- H_V_i(i) * V(i) + H_V_i(i+1) * V(i+1)];
        [t, y] = ode45(odes, t_span, [60 45 20] );
    end

    % Equaitions Of Reboiler
    if i==61
        dM_hold(i) = L(i-1) - V(i) - 50000;
        
        dMXdt_hold_component = X(i-1) * L(i-1) - V(i) * Y(i) + X(i)*50000;

        delta_h_vaporization = C_1_VAPO1*(1-(367/425.1))^(C_2_VAPO1+C_3_VAPO1*(367/425.1)+...
        C_4_VAPO1*(367/425.1)^2)*0.01+(1-0.01)*(C_1_VAPO2*(1-(367/469.7))^(C_2_VAPO2 + C_3_VAPO2 * ((367/469.7)) + C_4_VAPO2 *(367/469.7)^2));

        rho_l(i) = (0.01*V_c1*Z_c1^(1-367/425.1)^(2/7)+(1-0.01)*V_c2*Z_c2^(1-367/469.7)^(2/7))^(-1);

        rho_v = p(i)/(8.314 * 367);

        H_V_i(i)=(R_value*(A_3_DELTA_H1 * (367-298.15) + B_3_DELTA_H1 /2*(367-298.15)^2+...
        C_3_DELTA_H1/3*(367-298.15)^3)-125790)*0.01+(1-0.01)*((R_value*(A_3_DELTA_H2 *(367-298.15)+...
        B_3_DELTA_H2/2*(367-298.15)^2+C_3_DELTA_H2/3*(367-298.15)^3)-146760));

        H_L_i(i) = H_V_i(i) - delta_h_vaporization;

        dMHdt = H_L_i(i-1) * L(i-1)-H_V_i(i) * V(i)-50000 * H_L_i(i-1) + 758000;

        alpha(i) = exp(A_1_ANTOEINE-(B_1_ANTOEINE)/(367+C_1_ANTOEINE))/exp(A_2_ANTOEINE-(B_2_ANTOEINE)/(C_2_ANTOEINE+367));

        Y(i) = (X(i)*alpha(i))/(1+(alpha(i)-1)*X(i));

        odes = @(t,T)[L(i-1) - V(i) - 50000;
             X(i-1) * L(i-1) - V(i) * Y(i) + X(i)*50000;
           H_L_i(i-1) * L(i-1)-H_V_i(i) * V(i)-50000 * H_L_i(i-1) + 758000];
        [t, y] = ode45(odes, t_span, [6  4 400] );
    end

    % Equaitions Of Condenser
    if i==1
        L(1) = 1.323 * 50000;

        RR = 1.323;

        dM_hold(i) = V(i+1)-(L(i)+50000);

        dMXdt_hold_component(i) = V(i+1)*Y(i+1)-(L(i)+50000)*0.99;

        rho_l(i) = (0.99*V_c1*Z_c1^(1-322/425.1)^(2/7)+(1-0.99)*V_c2*Z_c2^(1-322/469.7)^(2/7))^(-1);

        rho_v = 450000/(8.314 * 322);

        delta_h_vaporization = C_1_VAPO1*(1-(322/425.1))^(C_2_VAPO1 +C_3_VAPO1*(322/425.1)+...
        C_4_VAPO1*(322/425.1)^2)*0.99+(1-0.99)*(C_1_VAPO2*(1-(322/469.7))^(C_2_VAPO2+C_3_VAPO2 * ((322/469.7)) + C_4_VAPO2*(322/469.7)^2));

        H_V_i(i) = (R_value*(A_3_DELTA_H1*(322-298.15)+B_3_DELTA_H1/2*(322-298.15)^2+...
        C_3_DELTA_H1/3*(322-298.15)^3)-125790)*0.99+(1-0.99)*((R_value*(A_3_DELTA_H2*(322-298.15)+...
        B_3_DELTA_H2/2*(322-298.15)^2+C_3_DELTA_H2/3*(322-298.15)^3)-146760));

        H_L_i(i) = H_V_i(i) - delta_h_vaporization;

        dMHdt = H_V_i(i+1) * V(i+1) - (L(i) + 50000) * H_L_i(i)-632200;

        alpha(i) = exp(A_1_ANTOEINE-(B_1_ANTOEINE)/(322+C_1_ANTOEINE))/exp(A_2_ANTOEINE-(B_2_ANTOEINE)/(C_2_ANTOEINE+322));

        Y(i) = (X(i)*alpha(i))/(1+(alpha(i)-1)*X(i));

        odes = @(t,T)[  V(i+1)-(L(i)+50000);
                 V(i+1)*Y(i+1)-(L(i)+50000)*0.99;
                 H_V_i(i+1) * V(i+1)-(L(i)+50000) * H_L_i(i)-632200];
  
        [t, y] = ode45(odes, t_span, [45 25 20] );
       
    end

end