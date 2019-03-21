% This script plots the 3D graph of volume of catalyst vs CSA and LENGTH
% for a fixed single pass conversion X and feed ratio, P, and T (assume
% isothermal)

global FNH3IN FN2 FH2 FTOTIN T
%% Initialise
% Obtain all reactor parameters from BuildReactor.m
p = BuildReactor;
P = p.P;
T = p.T;
Alpha = p.Alpha;
X = p.X;
N = p.NDiscs;

T0 = p.T; %Initial inlet feed temperature
FN20 = p.FN2; %store initial feed N2 amount as FN20 to get conversion of X later
FH2 = p.FH2;
FAR = p.FAR;
FNH30 = p.FNH3; %store initial feed NH3 amount as FNH30
FTOTIN = p.FEED;

FN2 = FN20; %assign the first FN2 value as FN20
FNH3IN = FNH30;
T = T0; %assign the first temperature as T0

% %% Calculate Phi values
% [PhiN2, PhiH2, PhiNH3, Ka, k, HR] = TemkinVariables(P, T);

dX = X/N;
MaxLength = 10; %defined arbitrarily based on ballpark figures for reasonable X values
MaxCSA = 5;

LENGTH = 0: MaxLength/N :MaxLength;
CSA = 0: MaxCSA/N :MaxCSA;

%Assign space for the total PFR Volume values
Volume = zeros(length(LENGTH),length(CSA));

%Assign space for the vector storing each FNH3OUT value & volume for each disc,
%Vdisc
DISCNH3IN = zeros(N+1,1);
DISCV = zeros(N+1,1);

DISCNH3IN(1) = FNH3IN ;
DISCV(1) = 0;

for l = 1:length(LENGTH)
    
    for a = 1:length(CSA)        
        
        %Repeat the calculation for N discs, where FNH3IN(j+1) = FNH3OUT(j)
        for j = 1:1:N
            %The initial value is the inital FNH3OUT, which is estiamted to be FNH3IN,
            %which is FNH3 from BuildReactor.m
            
            FNH3IN = DISCNH3IN(j);
            
            FNH3OUT = find_FNH3OUT(dX);
            [rNH3, Vdisc] = find_Vdisc(FNH3OUT,P,p);
            
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
            %T = dTdL(rNH3,j);
            
            %Store the updated values
            DISCNH3IN(j+1) = FNH3OUT;
            DISCV(j+1) = Vdisc;
        end
        
        Volume(l,a) = sum(DISCV);
    end
end

ax1 = subplot(2,1,1);
surf(CSA,LENGTH, Volume);
zlim([-0.5 5])
xlabel('Cross-sectional Area, m^2') % x-axis label
ylabel('Length/m') % y-axis label
zlabel('Volume Catalyst, m^3') % z-axis label
set(gca,'fontsize',12, 'FontWeight', 'bold')

ax2 = subplot(2,1,2);
surf(sqrt(4*CSA/pi),LENGTH, Volume);
zlim([0 0.025])
xlabel('Diameter, m') % x-axis label
ylabel('Length/m') % y-axis label
zlabel('Volume Catalyst, m^3') % z-axis label
set(gca,'fontsize',12, 'FontWeight', 'bold')
