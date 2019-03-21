function A1 = Estimate_A1(coefficients, E1, E2, A2, yN2,yH2,yNH3, yAR, T)
%This function estimates A1, teh forward pre-exponential factor in the
%Arrhenius equation in the Haber Bosch, Temkin-Pyzhev equation

%NOTE: -This whole function is valid depending on the important CSV data for
%a specific concentration and pressure! 
%For the case of 200 bar, initial yN2 = 0.2475, yH2 = 0.7425, yAR= 0.1...

% %Extract data from table
% data = csvread('Temp (C) 200 bar data.csv');
% 
% [ROW, COL] = size(data);
% 
% DATA_TEMP = zeros(ROW,1);
% DATA_yNH3 = zeros(ROW, 1);
% 
% DATA_TEMP(:,1) = data(:,1) + 273.15; %convert to kelvin
% DATA_yNH3(:,1) = data(:,2) / 100; % convert percentage to mole fraction
% 
% %forming yNH3 calculator for Temp
% coefficients = polyfit(DATA_TEMP,DATA_yNH3,12);

%Initial mole ratios, since Fj = Fj / FN2 = yj*Ftot / yN2*Ftot = yj / yN2
a = yH2/yN2;
b = yAR/yN2;
c = yNH3/yN2;

%Find Xeq
Xeq = find_Xeq(coefficients, a,b,c, T);

%Find A1
%Initial feed concentrations are expressed in a,b,c, i.e. yj/yN2 ratios
%Find the final equilibrium concentrations, Yj, from stoichiometric table
YN2 = (1-Xeq)/((1+a+b+c) - 2*Xeq);
YH2 = (a-3*Xeq)/((1+a+b+c) - 2*Xeq);
%YAR = (b)/((1+a+b+c) - 2*Xeq); % Not needed
YNH3 = (c+2*Xeq)/((1+a+b+c) - 2*Xeq);

%Find Ka: Is a function of the the FINAL concentrations of the species in
%equilibrium, Yj (BIG Y, not small y)
Ka = YNH3^2 / ( YN2 * (YH2)^3 );

%At equil, concentration of N2, yN2 is a function of Xeq

%We want to find A1:
R = 8.314; % Universal Gas constant kcal/Kmol/K (8.314 kJ/kmol/K)
k2 = A2*exp(-E2/(R*T));
%rNH3 = k1 * fN2*(fH2^3/fNH3^2)^Alpha - k2 * (fNH3^2/fH2^3)^(1-Alpha) ;

%From literature Ka^2 = k1/k2, k1 = k2 * Ka^2 AND k1 = A1*exp(-E1/(R*T))
k1 = k2 * Ka^2;
A1 = k1 * exp(E1/(R*T));

