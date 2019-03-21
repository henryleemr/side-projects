%Temperature calculation
%% Description
% Calculates the temperature variable along the reactor, T, wrt rate etc. 

%% Initialise
p = BuildReactor();
EFactor = p.EFactor;
Area = p.Area;
m = p.m;

rNH3 = TemkinPyzhev();
CpMix = HeatCap(p.P, p.T);
[PhiN2, PhiH2, PhiNH3, Ka, k, HR] = TemkinVariables(p.P, p.T);

%From dXdL =  -EFactor * rN2* A/ FN2o where FN2o is the initial flow rate
%FN2o in mole/ hr...
dtdl = EFactor * -HR * rNH3 * Area/ (m*CpMix); 


