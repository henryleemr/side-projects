function [CpmixSym] = HeatCapSym()

%% Symbolically outputs a Cpmixsym that is a function of P,T
%Input data
Coefficients = [6.903 6.952 4.9675; [-0.03753, -0.04567, 0]*10^(-2); [0.193, 0.095663, 0]*10^(-5); [-0.6861, -0.2079, 0 ]* 10^(-5)];
%Indexing
NA = 1;
NB = 2;
NC = 3;
ND = 4;
NN2 = 1;
NH2 = 2;
NAR = 3;
%Assign symbolic space for equations
syms Ci(T)
syms T 
Cp = sym('Cp', [1 4]);
%Calculate Ci for each species
for col = 1:3
    A= Coefficients(NA,col);
    B= Coefficients(NB,col);
    C= Coefficients(NC,col);
    D= Coefficients(ND,col);
    
    Ci = 4.1884*(A + B*T + C*T^2 + D*T^3);
    %store in C to later sum up
    Cp(1,col) = Ci;   
end

%Add in the Ci for NH3 (CHECK THIS AGAIN)
syms CNH3(T,P)
CNH3 = 6.5846 - 0.61251*10^(-2)*T + 0.23663*10^(-5)*T^2 - 1.5981*10^(-9)*T^3 + 96.1678 - 0.067571*P + (0.2225 + 1.6847*10^(-4)*P)*T + (1.289*10^(-4) - 1.0095*10^(-7)*P)*T^2;

Cp(1,4) = CNH3;

%Now sum up to find Cpmix
syms CpmixSym(T,P)
CpmixSym = sum(Cp);