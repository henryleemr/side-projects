%This script gives a solution to the function mass_balance=0, which yields
%FNH3OUT of ONE disc in kmolNH3/h

global FNH3IN FN2 FH2 FTOTIN

%Initialise
p = BuildReactor;
N = p.NDiscs;
FN2 = p.FN2;
FH2 = p.FH2;
FAR = p.FAR;
FNH3IN = p.FNH3;
FTOTIN = p.FEED;

%Assign space for the vector storing each FNH3OUT value for each disc
DISCNH3OUT = zeros(N+1,1);
DISCNH3IN = zeros(N+1,1);

DISCNH3IN(1) = FNH3IN ;
%Now repeat the calculation for N discs, where FNH3IN(j+1) = FNH3OUT(j)
for j = 1:1:N;
    %The initial value is the inital FNH3OUT, which is estiamted to be FNH3IN,
    %which is FNH3 from BuildReactor.m
    
    FNH3IN = DISCNH3IN(j);
    F0 = FNH3IN;
    
    %Solve for FNH3OUT
    FNH3OUT = fsolve(@mass_balance, F0);
      
    %Store the value into the vector
    DISCNH3OUT(j) = FNH3OUT;
    
    %Update the new FNH3IN as the previous FNH3OUT
    %New estimation
    CHANGEFNH3 = FNH3OUT - FNH3IN;
    CHANGEFN2  = -(1/2)*CHANGEFNH3; 
    CHANGEFH2  = -(3/2)*CHANGEFNH3;
    
    %Third equation, concentrations CNH3
    %Update the other values
    FNH3OUT = FNH3OUT; % this is the variable we want to compute in the end
    FN2= FN2 + CHANGEFN2;
    FH2 = FH2 + CHANGEFH2;
    FNH3IN = FNH3OUT;
    FTOTIN = FN2 + FH2 + FAR + FNH3IN;          %not sure??
    
    DISCNH3IN(j+1) = FNH3OUT;
    
end

%Sum up all the produced (extra) NH3 in each disc
FOUTTOTALNH3 = sum(DISCNH3OUT);

%Total conversion, XTOT
XTOT = FOUTTOTALNH3 / p.FEED;

%Cumulative NH3 produced over length 
CUMDISCNH3OUT = zeros(length(DISCNH3OUT),1);
for j = 2:length(DISCNH3OUT)
CUMDISCNH3OUT(1) = DISCNH3OUT(1);
CUMDISCNH3OUT(j) = DISCNH3OUT(j) + CUMDISCNH3OUT(j-1);
end

%Plot
Length = linspace(1,100,length(CUMDISCNH3OUT));
plot (Length,CUMDISCNH3OUT) 
xlabel('Reference Length along PFR')
ylabel('Cumulative NH3 flow produced kmol/s')
