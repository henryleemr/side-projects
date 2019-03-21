function [p] = BuildReactor
%% Description
%BuildReactor.m
% Contains all the parameters describing the reactor
p = struct;
%% Reactor operating conditions:
p.P = 225; %atm
p.T = 723; %kelvin of first stage
%% Temkin-Pyzhev:
% Vaiables
p.FEED = 100; %Total feed stream in kmol/h

% Mole Fractions/ concentrations where Yj = Fj / FEED NOTE: the mole
% fractions, yj in the StoicTable is different! That represents after
% conversion!
p.YH2 = 0.7425;
p.YN2 = 0.2475;
p.YNH3 = 0.001;
p.YN2O = 0.0000000000000000001;
p.YAR = 0.009;
 
p.X = 0.3; % Total conversion of first stage

p.FH2 = p.YH2*p.FEED; %feed of species in kmol/h as % of FEED
p.FN2 = p.YN2*p.FEED;
p.FNH3 = p.YNH3*p.FEED;
p.FN2O = p.YN2O*p.FEED; %for X1= 0.5 50% conversion of N2, FN20 = 
p.FAR = p.YAR*p.FEED;
p.m = p.FH2*2 + p.FN2*14 + p.FAR*40 + p.FNH3*17; %NOTE: mass flow in kg/h

p.V = 10; %total volume of reactor, in m^3
p.NDiscs = 1; %number of divisions of disc of reactor
p.dV = p.V/p.NDiscs; %volume of a disc in reactor
p.s1 = 1;
p.Alpha = 0.5; %range from 0.5-0.75
p.DELTAX = p.X / p.NDiscs;  %the conversion in EACH DISC
%% dX/dL and dT/dL:
p.Area = 1; %CSA of reactor
p.EFactor = 1; %Effectiveness factor due to catalyst



