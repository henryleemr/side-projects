function [PhiN2, PhiH2, PhiNH3, Ka, k, HR] = TemkinVariables(P, T)

PhiH2 = exp( exp(-3.802*T^0.125 + 0.541)*P - exp(-0.1263*T^0.5 - 15.98)* P^2 + 300 * exp(-0.011901*T - 5.941) *exp(P/300) );
            
PhiN2 = 0.93431737 + 0.2028538*10^(-3) * T + (0.295896*10^(-3))*P - (0.270727*10^(-6))*T^2 + (0.4775207*10^(-6))*P^2;

PhiNH3 = 0.1438996 + (0.2028538*10^-2)*T - (0.4487672*10^(-3))*P - (0.1142945*10^(-5))*T^2 + (0.2761216*10^(-6))*P^2;

%Equilibrium constant, From Smith R. Ka = Kphi*Kp = ratio of Phi i  * ratio of
%Pi
Ka = 10^ (-2.69112 * log(T) - (5051925*10^(-5))*T + (1.848863*10^(-7))*T^2 + 2001.6/T + 2.689);

ko = 8.849*10^14; %Arrhenius coefficient; (8.849 x10^14)
E = 40765; %E = Activation energy with temperature its mean value is 40765 Kcal/kmol
R = 8.314; % Universal Gas constant R (8.314 kJ/kmol.K)
k = ko*exp(-E/(R*T)); %reaction rate constant for reverse reaction

%Heat of Reaction 
HR = 4.184 * (-(0.54426 + 846.609/T + (459.734*10^6)/T^3)*P - 5.34685*T - (0.2525*10^(-3))*T^2 + (1069197*10^(-6)*T^3) - 9157.09);

