%This script gives a solution to the function mass_balance=0, which yields
%FNH3OUT of ONE disc in kmolNH3/h

%Initialise
p = BuildReactor;
N = p.NDiscs;
FNH3IN = p.FNH3;

F0 = FNH3IN;
%Solve for FNH3OUT
FNH3IN = DiscUpdate(FNH3IN);
FNH3OUT = fsolve(@Testmass_balance, F0);



