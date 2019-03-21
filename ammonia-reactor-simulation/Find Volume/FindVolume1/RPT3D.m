% This script plots the 3D graph of the rate of NH3 production vs pressure
% and temperature for a fixed conversion X and feed ratio

%% Initialise
% Obtain all reactor parameters from BuildReactor.m
p = BuildReactor;
% % Operating conditions
% P = p.P;
% T = p.T;

% Temkin pyzhev
Alpha = p.Alpha;
% Name the indices for retrieving information from StoicTable
% The rows...
IN = 1;
CHANGE = 2;
OUT = 3;
FRAC = 4;
% The columns...Hence e.g. N2 feed into,INN2 = StoicTable(IN,NN2)
NN2 = 1;
NH2 = 2;
NAR = 3;
NNH3 = 4;

%Assign space for the rate values
r = zeros(291,731);

for P =10:300
    for T = 600:1330
        
        % Obtain StoicTable from Stoichiometry.m
        StoicTable = Stoichiometry();
        
        %% Calculate Phi values
        [PhiN2, PhiH2, PhiNH3, Ka, k, HR] = TemkinVariables(P, T);
        
        %% Build fugacities fi which is also the activity
        % Define fugacity as f, not partial pressure, but fugacities where
        % f = Phi*FRAC*P ; P is total pressure
        fN2 =  StoicTable(FRAC, NN2) * P * 101325; %convert to pascals
        fH2 =  StoicTable(FRAC, NH2) * P * 101325;
        fNH3 =  StoicTable(FRAC, NNH3) * P * 101325;
        
        % Applying the unmodified version of the equation
        % rNH3 is rate of ammonia production
        % Units kmolNH3/hour/m^3 catalyst
        rNH3 = -2 * k* (( Ka^2 * fN2*(fH2^3/fNH3^2)^Alpha) - (fNH3^2/fH2^3)^(1-Alpha) );
        
        r((P-9),(T-599)) = rNH3;
    end
end

P = 10:1:300;
T = 600:1:1330;
surf(T,P,r);
zlim([-100 1000])
xlabel('Temperature / K') % x-axis label
ylabel('Pressure, atm') % y-axis label
zlabel('Rate, kmolNH3/h/m^3 cat') % z-axis label
