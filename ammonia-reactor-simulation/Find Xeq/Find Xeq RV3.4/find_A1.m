function A1 = find_A1(Xeq, E1, E2, A2, a,b,c, T)

% find_A1 is a function that calculates A1 from Xeq for a specific PRESSURE
% defined by the calling script from the data used to form
% "coefficients"

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


