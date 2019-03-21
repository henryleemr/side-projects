function [p] = BuildReactor
%% Description
%BuildReactor.m
% Contains all the parameters describing the reactor
p = struct;
%% Reactor operating conditions:
p.P = 200; %bars
p.T = 450; %kelvin of first stage
%% Temkin-Pyzhev:
% Constants:
p.ko = 8.849*10^14; %Arrhenius coefficient; (8.849 x10^14)
p.E = 40765; %E = Activation energy with temperature its mean value is 40765 Kcal/kmol
p.R = 8.314; % Universal Gas constant R (8.314 kJ/kmol.K)
p.k = p.ko*exp(-p.E/(p.R*p.T)); %reaction rate constant for reverse reaction
% Variables
p.FH2 = 0.1; %feed of species in kmol/h
p.FN2 = 0.04;
p.FNH3 = 0;
p.FN2O = 1;
p.FAR = 1;
p.m = p.FH2*2 + p.FN2*14 + p.FAR*40 + p.FNH3*17; %mass flow in kg/h
p.s1 = 1;
p.Alpha = 0.5; %range from 0.5-0.75
%% dX/dL:
p.Area = 1; %CSA of reactor
p.EFactor = 1; %Effectiveness factor due to catalyst
p.HR = 4.184 * (-(0.54426 + 846.609/p.T + (459.734*10^6)/p.T^3)*p.P - 5.34685*p.T - (0.2525*10^(-3))*p.T^2 + (1069197*10^(-6)*p.T^3) - 9157.09);



