%This script gives a solution to the function mass_balance=0, which yields
%FNH3OUT of ONE disc in kmolNH3/h

global FNH3IN FN2 FH2 FTOTIN T

%Initialise
p = BuildReactor;
T0 = p.T; %Initial inlet feed temperature
InletMass = p.m;
V = p.V;
Area = p.Area;
N = p.NDiscs;
FN20 = p.FN2; %store initial feed N2 amount as FN20 to get conversion of X later
FH2 = p.FH2;
FAR = p.FAR;
FNH30 = p.FNH3; %store initial feed NH3 amount as FNH30
FTOTIN = p.FEED;

FN2 = FN20; %assign the first FN2 value as FN20
FNH3IN = FNH30;
T = T0; %assign the first temperature as T0

%Assign space for the vector storing each FNH3OUT value for each disc
DISCNH3IN = zeros(N+1,1);
DISCN2IN = zeros(N+1,1);
DISCH2IN = zeros(N+1,1);
DISCTIN = zeros(N+1,1);
X       = zeros(N+1,1);
RATE    = zeros(N+1,1);

DISCNH3IN(1) = FNH3IN ;
DISCN2IN(1) = FN20 ;
DISCH2IN(1) = FH2 ;
DISCTIN(1) = T0 ;
X(1) = 0;
RATE(1) = 0; %assume first instance of rate is 0


for P =1:400
    for T = 400:1000
        %Now repeat the calculation for N discs, where FNH3IN(j+1) = FNH3OUT(j)
        for j = 1:1:N
            %The initial value is the inital FNH3OUT, which is estiamted to be FNH3IN,
            %which is FNH3 from BuildReactor.m
            
            FNH3IN = DISCNH3IN(j);
            F0 = FNH3IN;
            
            %Solve for FNH3OUT
            [FNH3OUT, rNH3] = mass_balance(F0);
            
            if rNH3 >= 0
                CHANGEFNH3 = FNH3OUT - FNH3IN;
            else
                CHANGEFNH3 = -(FNH3OUT - FNH3IN);
            end
            
            %Update the new FNH3IN as the previous FNH3OUT
            %New estimation
            CHANGEFN2  = -(1/2)*CHANGEFNH3;
            CHANGEFH2  = -(3/2)*CHANGEFNH3;
            
            %Third equation, concentrations CNH3
            %Update the other values
            if rNH3 >=0
                FNH3OUT = FNH3OUT; % this is the variable we want to compute in the end
            else
                FNH3OUT = FNH3OUT + CHANGEFNH3;
            end
            
            FN2= FN2 + CHANGEFN2;
            FH2 = FH2 + CHANGEFH2;
            FNH3IN = FNH3OUT;
            FTOTIN = FN2 + FH2 + FAR + FNH3IN;          %not sure?
            %T = dTdL(rNH3,j);   %assume isothermal 
            
%             %Store the updated values
%             DISCNH3IN(j+1) = FNH3OUT;
%             DISCN2IN(j+1) = FN2;
%             DISCH2IN(j+1) = FH2;
%             RATE(j+1) = rNH3;
%             DISCTIN(j+1) = T;
%             X(j+1) = 100 * (FN20 - FN2) / FN20;
        end
        
        % %Sum up all the produced (extra) NH3 in each disc
        % FOUTTOTALNH3 = sum(DISCNH3OUT);
        
        %Total conversion
        % XTotNH3 = 100 * FOUTTOTALNH3 / FNH30
        XTotN2 = 100 * (FN20 - FN2) / FN20;
        X((P), (T-399)) = XTotN2;
    end
end

P = 1:1:400;
T = 400:1:1000;

surf(T,P,X);
% zlim([-1e1 1.3e2])
xlabel('Temperature / K') % x-axis label
ylabel('Pressure, atm') % y-axis label
zlabel('N2 Conversion') % z-axis label
set(gca,'fontsize',12, 'FontWeight', 'bold')
