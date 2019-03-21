function Xeq = find_Xeq(coefficients, a,b,c, T)
% This function calculates the Xeq at the said parameters for a FIXED
% PRESSURE defined by the calling script from the data used to form
% "coefficients"

%forming yNH3 calculator for Temp
yNH3 = polyval(coefficients,T);
%Xeq = (yN20 - yNH2_OUT)*FTOTIN/ (yN20*FTOTOUT)by definition;

% N2 Xeq: (pg 97,108 logbook) with reference to a stoichiometric table
Xeq = (yNH3*(1+a+b+c) - c) / (2 * (yNH3 +1));