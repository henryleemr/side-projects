function rNH3Sym = TemkinPyzhevSym()

% Temkin-Pyzhev Equation
%% Description
% Same as Temkin Pyzhev but outputs an equation ito P,T of rNH3 instead of
% a single value corresponding to a particular set of P,T as in
% TemkinPyzhev.m
%% Initialise
% Obtain all reactor parameters from BuildReactor.m
p = BuildReactor;
% Operating conditions
% P = p.P;              %NOW THESE ARE VARIABLES SO COMMENT OUT
% T = p.T;
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
[Phi] = TemkinVariablesSym();
%% Build fugacities fi which is also the activity
% Define fugacity as f, not partial pressuer, but fugacities where
% f = Phi*FRAC*P ; P is total pressure 
syms P T
fN2 = Phi(1) * StoicTable(FRAC, NN2) * P;
fH2 = Phi(2) * StoicTable(FRAC, NH2) * P;
fNH3 = Phi(3) * StoicTable(FRAC, NNH3) * P;

% Applying the unmodified version of the equation
% rNH3 is rate of ammonia production 
% Units kmolNH3/hour/m^3 catalyst 
syms rNH3Sym(T,P)
%Phi(5) is reaction rate constant k, %Phi(4)=Ka equilibrium constant
rNH3Sym = 2*Phi(5)* ( Phi(4)^2 * fN2*(fH2^3/fNH3^2)^Alpha - (fNH3^2/fH2^3)^(1-Alpha) ); 
                        

