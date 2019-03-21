%Conversion calculation
%% Description
% Calculates the conversion, X of N2 with respect to length etc.

%% Initialise

p = BuildReactor();
EFactor = p.EFactor;
A = p.Area;
FN2O = p.FN2O;

rNH3 = TemkinPyzhev();

%From dXdL =  -EFactor * rN2* A/ FN2o where FN2o is the initial flow rate
%FN2o in molef/ hr...
dxdl =  EFactor * rNH3* A/ 2*FN2O


