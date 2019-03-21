function Func = mass_balance(FNH3OUT)

global FNH3IN FN2 FH2 FTOTIN

%This builds the function Func that expresses the mass balance equation of
%ammonia feed, Fin - Fout + rNH3*dV = dC/dt (accumulation of NH3) = O i.e.
% func = Fin - Fout + rNH3*dV in terms of FNH3OUT only for a specific P,T,V
% and N taken from BuildReactor.m

%Initialise

% FN2 = p.FN2;
% FH2 = p.FH2;
% FTOTIN  = p.FEED;
p = BuildReactor();
P = p.P;
T = p.T;
dV = p.dV;
Alpha = p.Alpha;

%Form first equation, changes in NH3 feed, kmol/hr
CHANGEFNH3 = FNH3OUT - FNH3IN;
CHANGEFN2  = -(1/2)*CHANGEFNH3;  
CHANGEFH2  = -(3/2)*CHANGEFNH3;

%Second equation, FTOTALOUT
FTOTOUT = FTOTIN + (1 - 1/2 - 3/2)*CHANGEFNH3;

%Third equation, concentrations CNH3   
FNH3OUT = FNH3OUT; % this is the variable we want to compute in the end
FN2OUT = FN2 + CHANGEFN2;
FH2OUT = FH2 + CHANGEFH2; 
CNH3 = FNH3OUT / FTOTOUT;
CN2 =  FN2OUT / FTOTOUT;   
CH2 =  FH2OUT / FTOTOUT;

%Send to Temkin Pyzhev equation to obtain rNH3, kmolNH3/h/m^3 cat
% Calculate Phi values, fugacity coefficients
[PhiN2, PhiH2, PhiNH3, Ka, k, HR] = TemkinVariables(P, T);

%Expressing the equation in terms of effective partial pressures, i.e.
%fugacities
% Define fugacity as f, not partial pressure, but fugacities where
% f = Phi*FRAC*P ; P is total pressure 
fN2 = PhiN2 * CN2 * P;
fH2 = PhiH2 * CH2 * P;
fNH3 = PhiNH3 * CNH3 * P;

% Applying the unmodified version of the equation
% rNH3 is rate of ammonia production 
% Units kmolNH3/hour/m^3 catalyst
rNH3 = 2*k* ( Ka^2 * fN2*(fH2^3/fNH3^2)^Alpha - (fNH3^2/fH2^3)^(1-Alpha) );

%Finally, build the mass balance equation to be solved
Func = FNH3IN - FNH3OUT + rNH3*dV;

