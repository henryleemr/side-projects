%This script gives a solution to the function mass_balance=0, which yields
%FNH3OUT of ONE disc in kmolNH3/h

global FNH3IN FN2 FH2 FTOTIN

%Initialise
p = BuildReactor;
V = p.V;
Area = p.Area;
N = p.NDiscs;
FN20 = p.FN2; %store initial feed N2 amount as FN20 to get conversion of X later
FH2 = p.FH2;
FAR = p.FAR;
FNH30 = p.FNH3;
FTOTIN = p.FEED;

FN2 = FN20; %assign the first FN2 value as FN20
FNH3IN = FNH30;

%Assign space for the vector storing each FNH3OUT value for each disc
DISCNH3OUT = zeros(N+1,1);
DISCNH3IN = zeros(N+1,1);
RATE = zeros(N+1,1);

DISCNH3IN(1) = FNH3IN ;
%Now repeat the calculation for N discs, where FNH3IN(j+1) = FNH3OUT(j)
for j = 1:1:N
    %The initial value is the inital FNH3OUT, which is estiamted to be FNH3IN,
    %which is FNH3 from BuildReactor.m
    
    FNH3IN = DISCNH3IN(j);
    F0 = FNH3IN;
   
    %Solve for FNH3OUT
    [FNH3OUT, rNH3] = mass_balance(F0);
    
    %Store the values into vectors
    DISCNH3OUT(j) = FNH3OUT;
    RATE(j) = rNH3;
    
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
    
    DISCNH3IN(j+1) = FNH3OUT;
    
end

%Sum up all the produced (extra) NH3 in each disc
FOUTTOTALNH3 = sum(DISCNH3OUT);

%Total conversion
% XTotNH3 = 100 * FOUTTOTALNH3 / FNH30
XTotN2 = 100 * (FN20 - FN2) / FN20

massflow = FH2*2 + (FN2)*14 + FAR*40 + DISCNH3IN(N)*17 %NOTE: mass flow in kg/h

%Plot
Length = linspace(0,V/Area,length(DISCNH3IN));
plot (Length,DISCNH3IN, Length, RATE)
xlabel('Length along PFR, m')
ylabel('kmol/h')
legend('NH3 flow','RateNH3')
