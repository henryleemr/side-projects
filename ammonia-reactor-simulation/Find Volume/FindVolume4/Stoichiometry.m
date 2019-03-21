function [StoicTable] = Stoichiometry()
%% Description
%Stoichiometry.m
% This function calculates the mass balances of only the first stage of the
% reactor adn outputs it in the form of a table, StoicTable
% The output to be determined are the design variables X1, f, Delta, and r
%% Initialise 
% First extract information
p = BuildReactor;
FH2 = p.FH2; 
FN2 = p.FN2; 
FNH3 = p.FNH3;
FAR = p.FAR;
s1 = p.s1; % Note that for a one-stage reactor, s1 = 1

% Define conversion of first stage, X1
% X1 is the conversion in EACH DISC
X1 = p.DELTAX;

% T = p.T;   % Temperature in K
% R = 8.314; % Universal Gas constant R (8.314 kJ/kmol.K) (same value from TemkinVariables.m

%% Now convert all parameters into new parameters expressed as ratios
% Define feed ratio, f
f = FH2/FN2;
% Define Inert ratio, Delta
Delta = FAR/FN2;
% Define Recycle ratio, r
r = FNH3/FN2;
%% Define feed into reactor IN
% For N2
INN2 = s1*FN2;
% For H2
INH2 = s1*f*FN2;
% For Ar
INAR = s1*Delta*FN2;
% For NH3
INNH3 = s1*r*FN2;
%% Define change in reactor CHANGE
CHANGEN2 = -X1*(s1*FN2);
CHANGEH2 = -3*X1*(s1*FN2);
CHANGEAR = 0;
CHANGENH3 = 2*X1*(s1*FN2);
%% Define output from reactor OUT
OUTN2 = INN2 + CHANGEN2;
OUTH2 = INH2 + CHANGEH2;
OUTAR = INAR + CHANGEAR;
OUTNH3 = INNH3 + CHANGENH3;
TOTALOUT = OUTN2 + OUTH2 + OUTAR + OUTNH3;
%% Now calculate the mole fractions FRAC/ Concentration at OUTLET FRAC = yj, NOT Yj at inlet FEED!
FRACN2 = OUTN2 / (TOTALOUT);
FRACH2 = OUTH2 / (TOTALOUT);
FRACAR = OUTAR / (TOTALOUT);
FRACNH3 = OUTNH3 / (TOTALOUT);

%% Put all info inside a table to ease checking
StoicTable = [INN2      INH2        INAR        INNH3;
              CHANGEN2  CHANGEH2    CHANGEAR    CHANGENH3;
              OUTN2     OUTH2       OUTAR       OUTNH3;
              FRACN2    FRACH2      FRACAR      FRACNH3];
          
          







