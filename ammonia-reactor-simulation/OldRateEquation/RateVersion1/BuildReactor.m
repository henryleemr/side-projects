function [p] = BuildReactor
%% Description
%BuildReactor.m
% Contains all the parameters describing the reactor
%% Define the values of parameters in appriopriate ranges specified
% Temkin-Pyzhev:
p = struct;
% Constants:
p.A = 8.849*10^14; %Arrhenius coefficient; (8.849 x10^14)
p.B = 8.849*10^14;
p.E1 = 40765; %E = Activation energy with temperature its mean value is 40765 Kcal/kmol
p.E2 = 40765;
p.R = 8.314; % Universal Gas constant R (8.314 kJ/kmol.K)
p.T = 1;
% Variables
p.k1 = p.A*exp(-p.E1/(p.R*p.T)); 
p.k2 = p.B*exp(-p.E2/(p.R*p.T));

p.PN2 = 1; %partial pressures of species(concentration)
p.PH2 = 1; 
p.PNH3 = 1;

p.FH2 = 0.1; %feed of species in kmol/h
p.FN2 = 0.04;
p.FNH3 = 0;
p.FN2O = 1;
p.FAR = 1;

p.s1 = 1;
p.Alpha = 0.5; %range from 0.5-0.75

%% OLD Then put it inside p 
% p.k1 = k1; 
% p.k2 = k2;
% p.PH2 = PH2; 
% p.PN2 = PN2;
% p.PNH3 = PNH3;
% p.Alpha = Alpha;
% p.FN2 = FN2;
% p.FH2 = FH2; 
% p.FNH3 = FNH3;
% p.FN2O = FN2O; 
% p.FAR = FAR;
% p.s1 = s1; 

