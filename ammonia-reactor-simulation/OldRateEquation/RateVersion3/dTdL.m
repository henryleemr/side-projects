%Temperature calculation
%% Description
% Calculates the temperature variable along the reactor, T, wrt rate etc. 

%% Initialise
p = BuildReactor();
EFactor = p.EFactor;
A = p.Area;
HR = p.HR;
m = p.m;

rNH3 = TemkinPyzhev();
Cpmix = HeatCap(p.P, p.T);

%From dXdL =  -EFactor * rN2* A/ FN2o where FN2o is the initial flow rate
%FN2o in mole/ hr...
dtdl = EFactor * -HR * rNH3 * A/ (m*Cpmix) 


