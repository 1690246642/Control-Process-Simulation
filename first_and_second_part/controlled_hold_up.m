function firststep=controlled_hold_up(t,X) 

%           includes level control of condenser and reboiler 
%           using two P-controllers 
%
%            Inputs are reflux (LT) and boilup (VB). 
%            Disturbances are feedrate (F) and feed composition (zF)

LT = 1.323;                          % Reflux
VB = 2.322;                            % Boilup
F  = 100 ;                           % Feedrate
zF = 0.5;                            % Feed composition
qF = 1.0;                            % liquid fraction

%% P-Controllers for holdup (level) control of reboiler and condenser.
KcD= 1.5;  KcB=1.5;         % controller gains
MDs=0.5;   MBs=0.5;       % st.st hold_up 
Ds=0.5;    Bs=0.5;        % st.st

MD=X(1); MB=X(61);  % Actual condenser AND reboiler holdup

D= Ds + (MD - MDs) * KcD;       % Distillate flow
B= Bs + (MB - MBs) * KcB;       % Bottoms flow     

U(1)=LT; U(2)=VB; U(3)=D; U(4)=B; U(5)=F; U(6)=zF; U(7)=qF;

firststep=Distillation_column_last_version(t,X,U);
