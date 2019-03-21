%This script gives a solution to the function mass_balance=0, which yields
%FNH3OUT of ONE disc in kmolNH3/h

global FNH3IN FN2 FH2 FTOTIN

%Initialise
p = BuildReactor;
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

%Assign space for the vector storing each FNH3OUT value for each disc
DISCNH3IN = zeros(N+1,1);
DISCN2IN = zeros(N+1,1);
DISCH2IN = zeros(N+1,1);
RATE = zeros(N+1,1);
CONCENH3IN = zeros(N+1,1);
CONCN2IN = zeros(N+1,1);
CONCH2IN = zeros(N+1,1);

DISCNH3IN(1) = FNH3IN ;
DISCN2IN(1) = FN20 ;
DISCH2IN(1) = FH2 ;
CONCNH3IN(1) = FNH3IN / p.FEED ;
CONCN2IN(1) = FN20 / p.FEED ;
CONCH2IN(1) = FH2 / p.FEED ;
RATE(1) = 0; %assume first instance of rate is 0

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
    
    %Update flow rates
    FN2= FN2 + CHANGEFN2;
    FH2 = FH2 + CHANGEFH2;
    FNH3IN = FNH3OUT;
    FTOTIN = FN2 + FH2 + FAR + FNH3IN;          %not sure
    
    %Store the updated values
    DISCNH3IN(j+1) = FNH3OUT;
    DISCN2IN(j+1) = FN2;
    DISCH2IN(j+1) = FH2;
    CONCNH3IN(j+1) = FNH3IN / FTOTIN ;
    CONCN2IN(j+1) = FN20 / FTOTIN ;
    CONCH2IN(j+1) = FH2 / FTOTIN ;    
    RATE(j+1) = rNH3;
end

% %Sum up all the produced (extra) NH3 in each disc
% FOUTTOTALNH3 = sum(DISCNH3OUT);

%Total conversion
% XTotNH3 = 100 * FOUTTOTALNH3 / FNH30
XTotN2 = 100 * (FN20 - FN2) / FN20

OutletMass = FH2*2 + (FN2)*14 + FAR*40 + DISCNH3IN(N+1)*17; %NOTE: mass flow in kg/h

PercentageMassError = 100*(OutletMass - InletMass)/InletMass

%Plot flow
Length = linspace(0,V/Area,length(DISCNH3IN));
plot (Length,RATE, Length, DISCNH3IN, Length, DISCN2IN, Length, DISCH2IN);
xlabel('Length along PFR, m')
ylabel('Molar flow rate, kmol/h')
legend('Rate NH3','NH3 flow', 'N2 flow', 'H2 flow')

%Plot concentration
Length = linspace(0,V/Area,length(DISCNH3IN));
plot (Length, CONCNH3IN, Length, CONCN2IN, Length, CONCH2IN);
xlabel('Length along PFR, m')
ylabel('Molar concentration')
legend('NH3 conc', 'N2 conc', 'H2 conc')

