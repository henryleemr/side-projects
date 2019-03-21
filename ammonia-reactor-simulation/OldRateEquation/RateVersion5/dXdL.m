%Conversion calculation
%% Description
% Calculates the conversion, X of N2 with respect to length etc.

%% Initialise

p = BuildReactor();
EFactor = p.EFactor;
Area = p.Area;
FN2O = p.FN2O;

rNH3 = TemkinPyzhev();

%From dXdL =  -EFactor * rN2* A/ FN2O where FN2O is the initial flow rate
%FN2O in mole/ hr...
dxdl =  EFactor * rNH3* Area/ 2*FN2O


