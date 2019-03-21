% Temkin-Pyzhev Equation
%% Description
%This script uses the Temkin-Pyzhev equation to estimate the rate of NH3
%reaction per m^3 catalyst per hour given the partial pressures of hydrogen
%H2 and reaction constants, k

% Constraints of equation:
% -Accurate around 100-300 bar
% -Inaccurate at low partial pressures of ammonia, PNH3 as X~=0
% -Constant, alpha ranges from 0.5-0.75

% Model Assumptions:
% -Ideal,adiabatic, 3-stage, plug flow reactor(PFR)
% -Steady state operation
% -Constant gas density
% -Pseudo-homogenous reactor, i.e. catalyst characteristics modelled by
% introducing a coefficient
%% Initialise
% Obtain all reactor parameters from BuildReactor.m
p = BuildReactor;
k1 = p.k1; 
k2 = p.k2;
PH2 = p.PH2; 
PN2 = p.PN2;
PNH3 = p.PNH3;
pAlpha = p.Alpha;
% Obtain StoicTable from Stoichiometry.m
StoicTable = Stoichiometry();
% Name the indices for retrieving information from StoicTable
% The rows...
IN = 1;
CHANGE = 2;
OUT = 3;
FRAC = 4;
% The columns...Hence e.g. N2 feed into,INN2 = StoicTable(IN,NN2)
NN2 = 1;
NH2 = 2;
NAR = 3;
NNH3 = 4;
%% Calculate
% Applying the unmodified version of the equation

% rNH3 is rate of ammonia production 
% Units kmolNH3/hour/m^3 catalyst
rNH3 = k1*PN2*(PH2^3/PNH3^2)^Alpha - k2*(PNH3^2/PH2^3)^(1-Alpha);






