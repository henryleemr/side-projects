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

DISCNH3IN(1) = FNH3IN ;
%Now repeat the calculation for N discs, where FNH3IN(j+1) = FNH3OUT(j)
for j = 1:1:N
    %The initial value is the inital FNH3OUT, which is estiamted to be FNH3IN,
    %which is FNH3 from BuildReactor.m
    
    FNH3IN = DISCNH3IN(j);
    F0 = FNH3IN;
    
    %% mass_balance
    
    %This builds the function Func that expresses the mass balance equation of
    %ammonia feed, Fin - Fout + rNH3*dV = dC/dt (accumulation of NH3) = O i.e.
    % func = Fin - Fout + rNH3*dV in terms of FNH3OUT only for a specific P,T,V
    % and N taken from BuildReactor.m
    
    %Initialise
    
    % FN2 = p.FN2;
    % FH2 = p.FH2;
    % FTOTIN  = p.FEED;
    p = BuildReactor();
    P = p.P;
    T = p.T;
    dV = p.dV;
    Alpha = p.Alpha;
    
    %Form first equation, changes in NH3 feed, kmol/hr
    CHANGEFNH3 = FNH3OUT - FNH3IN;
    CHANGEFN2  = -(1/2)*CHANGEFNH3;
    CHANGEFH2  = -(3/2)*CHANGEFNH3;
    
    %Second equation, FTOTALOUT
    FTOTOUT = FTOTIN + (1 - 1/2 - 3/2)*CHANGEFNH3;
    
    %Third equation, concentrations CNH3
    FNH3OUT = FNH3OUT; % this is the variable we want to compute in the end
    FN2OUT = FN2 + CHANGEFN2;
    FH2OUT = FH2 + CHANGEFH2;
    CNH3 = FNH3OUT / FTOTOUT;
    CN2 =  FN2OUT / FTOTOUT;
    CH2 =  FH2OUT / FTOTOUT;
    
    %Send to Temkin Pyzhev equation to obtain rNH3, kmolNH3/h/m^3 cat
    % Calculate Phi values, fugacity coefficients
    % [PhiN2, PhiH2, PhiNH3, Ka, k, HR] = TemkinVariables(P, T);
    
    %Expressing the equation in terms of effective partial pressures, i.e.
    %fugacities
    % Define fugacity as f, not partial pressure, but fugacities where
    % f = Phi*FRAC*P ; P is total pressure
    fN2 = CN2 * P; %*PhiN2  ;
    fH2 = CH2 * P; %*PhiH2 ;
    fNH3 = CNH3 * P; %*PhiNH3;
    
    % Applying the unmodified version of the equation
    % rNH3 is rate of ammonia production
    % Units kmolNH3/hour/m^3 catalyst
    R = 8.314; % Universal Gas constant kcal/Kmol/K (8.314 kJ/kmol/K)
    k1 = (1.79e4)*exp(-87090/(R*T));
    k2 = (2.75e16)*exp(-198464/(R*T));
    rNH3 = k1 * fN2*(fH2^3/fNH3^2)^Alpha - k2 * (fNH3^2/fH2^3)^(1-Alpha) ;
    
    %%
    %Solve for FNH3OUT
    FNH3OUT = fsolve(@mass_balance, F0) + FNH30;
    
    %Store the value into the vector
    DISCNH3OUT(j) = FNH3OUT;
    
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

% %Cumulative NH3 produced over length
% CUMDISCNH3OUT = zeros(length(DISCNH3OUT),1);
% for j = 2:length(DISCNH3OUT)
%     CUMDISCNH3OUT(1) = DISCNH3OUT(1);
%     CUMDISCNH3OUT(j) = DISCNH3OUT(j) + CUMDISCNH3OUT(j-1);
% end

massflow = FH2*2 + (FN2)*14 + FAR*40 + DISCNH3IN(N)*17 %NOTE: mass flow in kg/h

%Plot
Length = linspace(0,V/Area,length(DISCNH3IN));
plot (Length,(DISCNH3IN))
xlabel('Length along PFR, m')
ylabel('NH3 flow kmol/h')
