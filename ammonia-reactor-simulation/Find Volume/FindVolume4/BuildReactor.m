function [p] = BuildReactor
%% Description
%BuildReactor.m
% Contains all the parameters describing the reactor
p = struct;
%% Reactor operating conditions:
p.P = 225; %atm
p.T = 723; %kelvin of first stage
p.X = 15.0650; % Total conversion of first stage
%% Temkin-Pyzhev:
% Vaiables
p.FEED = 100; %Total feed stream in kmol/h

% Mole Fractions/ concentrations where Yj = Fj / FEED NOTE: the mole
% fractions, yj in the StoicTable is different! That represents after
% conversion!
p.YH2 = 0.7425;
p.YN2 = 0.2475;
p.YNH3 = 0.000;
p.YAR = 0.010;
 
p.FH2 = p.YH2*p.FEED; %feed of species in kmol/h as % of FEED
p.FN2 = p.YN2*p.FEED;
p.FNH3 = p.YNH3*p.FEED;
p.FAR = p.YAR*p.FEED;
p.m = p.FH2*2 + p.FN2*14 + p.FAR*40 + p.FNH3*17; %NOTE: mass flow in kg/h

p.V = 0.2; %total volume of reactor, in m^3
p.NDiscs = 1; %number of divisions of disc of reactor
p.dV = p.V/p.NDiscs; %volume of a disc in reactor
p.s1 = 1;
p.Alpha = 0.5; %range from 0.5-0.75
p.DELTAX = p.X / p.NDiscs;  %the conversion in EACH DISC
%% dX/dL and dT/dL:
p.Area = 0.5; %CSA of reactor
p.EFactor = 1; %Effectiveness factor due to catalyst



