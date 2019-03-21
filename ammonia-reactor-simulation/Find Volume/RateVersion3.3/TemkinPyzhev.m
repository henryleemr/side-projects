function rNH3 = TemkinPyzhev()

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
% Operating conditions
P = p.P;
T = p.T;
% Temkin pyzhev
Alpha = p.Alpha;
% Obtain StoicTable from Stoichiometry.m
StoicTable = Stoichiometry();

% Sanity checks
%[p, StoicTable] = TemkinPyzhevSanity(p, StoicTable);

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
%% Calculate Phi values
[PhiN2, PhiH2, PhiNH3, Ka, k, HR] = TemkinVariables(P, T);

%% Build fugacities fi which is also the activity
% Define fugacity as f, not partial pressure, but fugacities where
% f = Phi*FRAC*P ; P is total pressure 
fN2 = PhiN2 * StoicTable(FRAC, NN2) * P;
fH2 = PhiH2 * StoicTable(FRAC, NH2) * P;
fNH3 = PhiNH3 * StoicTable(FRAC, NNH3) * P;

% Applying the unmodified version of the equation
% rNH3 is rate of ammonia production 
% Units kmolNH3/hour/m^3 catalyst
rNH3 = 2*k* ( Ka^2 * fN2*(fH2^3/fNH3^2)^Alpha - (fNH3^2/fH2^3)^(1-Alpha) );

%use fsolve to solve for one disc