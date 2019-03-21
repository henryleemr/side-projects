%Temperature calculation
function NewT = dTdL(rNH3,j)
%% Description
% Calculates the temperature variable along the reactor, T 
global FN2 FTOTIN T
%% Initialise

p = BuildReactor();
EFactor = p.EFactor;
P = p.P;
T0 = p.T;
Vol = p.V;
Area = p.Area;
N = p.NDiscs;
m = p.m;
FN20 = p.FN2; %store initial feed N2 amount as FN20 to get conversion of X later

TotLength = Vol/Area;
dL = TotLength/N;

CpMix = HeatCap(P, T);

%Heat of Reaction 
HR = 4.184 * (-(0.54426 + 846.609/T + (459.734*10^6)/T^3)*P - 5.34685*T - (0.2525*10^(-3))*T^2 + (1069197*10^(-6)*T^3) - 9157.09);

X= 100 * (FN20 - FN2) / FN20;

%From dXdL =  -EFactor * rN2* A/ FN2o where FN2o is the initial flow rate
%FN2o in mole/ hr...
%Using dTdL = EFactor * -HR * rNH3 * Area/ (m*CpMix); 

% dT = dL * EFactor * -HR * rNH3 * Area/ (m*CpMix); 
% NewT = T + dT;

% density of N2 is using PV= nRT, density = P(RMM)/RT
N2DENSITY = P * 14 / 8.314 / T;
NewT = T - HR * (FN2 / FTOTIN) * (1/N2DENSITY) * (1/CpMix) * X;

% NewT = T - HR * (FN20)  * (1/m/CpMix) * X/j;
