function [p] = BuildReactor
%% Description
%BuildReactor.m
% Contains all the parameters describing the reactor
p = struct;
%% Reactor operating conditions:
p.P = 200; %bars
p.T = 450; %kelvin of first stage
%% Temkin-Pyzhev:
% Variables
p.FEED = 5828; %Total feed stream in kmol/h
p.FH2 = 0.65*p.FEED; %feed of species in kmol/h as % of FEED
p.FN2 = 0.07*p.FEED;
p.FNH3 = 0.07*p.FEED;
p.FN2O = 0.14*p.FEED; %for X1= 0.5 50% conversion of N2, FN20 = 
p.FAR = 0.07*p.FEED;
p.m = p.FH2*2 + p.FN2*14 + p.FAR*40 + p.FNH3*17; %NOTE: mass flow in kg/h
p.s1 = 1;
p.Alpha = 0.5; %range from 0.5-0.75
%% dX/dL and dT/dL:
p.Area = 1; %CSA of reactor
p.EFactor = 1; %Effectiveness factor due to catalyst




