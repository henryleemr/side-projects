function [PhiN2, PhiH2, PhiNH3, Ka, k, HR] = TemkinVariables(P, T)

PhiH2 = exp( exp(-3.802*T^0.125 + 0.541)*P - exp(-0.1263*T^0.5 - 15.98)* P^2 + 300 * exp(-0.011901*T - 5.941) *exp(P/300) );
            
PhiN2 = 0.93431737 + 0.2028538*10^(-3) * T + (0.295896*10^(-3))*P - (0.270727*10^(-6))*T^2 + (0.4775207*10^(-6))*P^2;

PhiNH3 = 0.1438996 + (0.2028538*10^-2)*T - (0.4487672*10^(-3))*P - (0.1142945*10^(-5))*T^2 + (0.2761216*10^(-6))*P^2;

% LIMITING Equilibrium constant, From Smith R. Ka = Kphi*Kp = ratio of Phi i  * ratio of
%Pi
Ka0 = 10^ (-2.69112 * log(T) - (5051925*10^(-5))*T + (1.848863*10^(-7))*T^2 + 2001.6/T + 2.689);

StoicTable = Stoichiometry();
SUM = StoicTable(4,1)*1.3445^0.5 + StoicTable(4,2)*0.1975^0.5 + StoicTable(4,4)*2.3930^0.5;
Ka = Ka0 * 10^ (0.1191849/T + 25122730/T^4 + SUM*38.76816/T^2 + (SUM^2)*64.49429/T^2) * P;

ko = 8.849*10^14; %Arrhenius coefficient; (8.849 x10^14)
% ko = 1.7698*10^15;
E = 40765; %E = Activation energy with temperature its mean value is 40765 kcal/kmol
R = 1.98722; % Universal Gas constant kcal/Kmol/K (8.314 kJ/kmol/K)
k = ko*exp(-E/(R*T)); %reaction rate constant for reverse reaction

%Heat of Reaction 
HR = 4.184 * (-(0.54426 + 846.609/T + (459.734*10^6)/T^3)*P - 5.34685*T - (0.2525*10^(-3))*T^2 + (1069197*10^(-6)*T^3) - 9157.09);

