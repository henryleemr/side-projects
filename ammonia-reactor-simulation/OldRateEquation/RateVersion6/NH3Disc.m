%This script gives a solution to the function mass_balance=0, which yields
%FNH3OUT of ONE disc in kmolNH3/h

%Initialise
p = BuildReactor;
N = p.NDiscs;
FNH3IN = p.FNH3;

%Assign space for the vector storing each FNH3OUT value for each disc
DISCNH3OUT = zeros(1,N+1);
DISCNH3IN = zeros(1,N+1);

DISCNH3IN(1) = FNH3IN ;
%Now repeat the calculation for N discs, where FNH3IN(j+1) = FNH3OUT(j)
for j = 1:1:N;
    %The initial value is the inital FNH3OUT, which is estiamted to be FNH3IN,
    %which is FNH3 from BuildReactor.m
    
    %Pass FNH3IN to mass_balance via DiscUpdate.m
    FNH3IN = DISCNH3IN(j);
    F0 = FNH3IN;
    
    %Solve for FNH3OUT
    FNH3OUT = fsolve(@mass_balance, F0);
    
    %Store the value into the vector 
    DISCNH3OUT(j) = FNH3OUT;
    
    %Update the new FNH3IN as the previous FNH3OUT
    %New estimation
    DISCNH3IN(j+1) = FNH3OUT;
    
end
