function [rNH3, Vdisc] = find_Vdisc(FNH3OUT,P,p)
% This functions finds the volume of the disc for a defined P,T X overall
% defined from BuildReactor, and a corresponding dX, LENGTH and CSA, within the loop in
% V_L_A_3D 

global FNH3IN FN2 FH2 FTOTIN T

%Extract needed info from the struct, p from BuildReactor, called in
%V_L_A_3D.m
Alpha = p.Alpha;
T= p.T; %delete this for adiabatic situation in Vdisc calculation, now it is isothermal

%Form first equation, changes in NH3 feed, kmol/hr
CHANGEFNH3 = FNH3OUT - FNH3IN;
CHANGEFN2  = -(1/2)*CHANGEFNH3;
CHANGEFH2  = -(3/2)*CHANGEFNH3;

%Second equation, FTOTALOUT
FTOTOUT = FTOTIN + (1 - 1/2 - 3/2)*CHANGEFNH3;

%Third equation, concentrations CNH3
FNH3OUT = FNH3OUT; 
FN2OUT = FN2 + CHANGEFN2;
FH2OUT = FH2 + CHANGEFH2;
CNH3 = FNH3OUT / FTOTOUT;
CN2 =  FN2OUT / FTOTOUT;
CH2 =  FH2OUT / FTOTOUT;

%Send to Temkin Pyzhev equation to obtain rNH3, kmolNH3/h/m^3 cat
% Calculate Phi values, fugacity coefficients
%[PhiN2, PhiH2, PhiNH3, Ka, k, HR] = TemkinVariables(P, T);

%Expressing the equation in terms of effective partial pressures
fN2 = CN2 * P; %*PhiN2  ;
fH2 = CH2 * P; %*PhiH2 ;
fNH3 = CNH3 * P; %*PhiNH3;

% Applying the unmodified version of the equation
% rNH3 is rate of ammonia production
% Units kmolNH3/hour/m^3 catalyst
R = 8.314; % Universal Gas constant kcal/Kmol/K (8.314 kJ/kmol/K)
k1 = (1.79e4)*exp(-87090/(R*T));  
k2 = (2.75e16)*exp(-198464/(R*T));
rNH3 = k1 * fN2*(fH2^3/fNH3^2)^Alpha - k2 * (fNH3^2/fH2^3)^(1-Alpha) ;

%For unknown dV, and known single pass X situation
%(Vdisc is to be determined)
% from mol accumulation  = FNH3IN - FNH3OUT + rNH3*dV = 0;
Vdisc = (FNH3OUT-FNH3IN)/rNH3;
