%Temperature calculation
%% Description
% Calculates the temperature variable along the reactor, T, wrt rate etc. 
%% Initialise
p = BuildReactor();
EFactor = p.EFactor;
Area = p.Area;
m = p.m;

rNH3Sym = TemkinPyzhevSym();
[Phi] = TemkinVariablesSym();

% Obtain equation of heat capacity of mixture Cpmix ito P and T
CpMixSym = HeatCapSym();

% Now build the ODE
%From dXdL =  -EFactor * rN2* A/ FN2o where FN2o is the initial flow rate
%FN2o in mole/ hr...
% HR is Phi(6)
syms dtdl(P,T)
dtdl = EFactor * -Phi(6) * rNH3Sym * Area/ (m*CpMixSym) ;

% %Obtain P,T conditions from BuildReactor
Pressure = p.P;
Temperature = p.T;
%Now call it a symbolic function to find one dtdl value for one set of P,T
dtdl = symfun(dtdl, [P,T]);
dtdlValue = dtdl(Pressure,Temperature);
%Convert to a double numerical value
dtdlValue = double(dtdlValue);

L = [0 5];
T0 = 400;
[L,T] = ode23(@(L,T) dtdl, L, T0);
plot(L,T,'-o')
