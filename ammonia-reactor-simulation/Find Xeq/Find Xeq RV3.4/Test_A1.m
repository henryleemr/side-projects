%Test_A1
%This script tests the sensitivity of the estimation of A1 wrt a few
%parameters

%Initialise
% For the case of 200 bar, initial yN2 = 0.2475, yH2 = 0.7425, yAR= 0.1
yN2 = 0.2475;
yH2 = 0.7425;
yNH3 = 0;
yAR= 0.1;

%Find the other pre-exponential factor, via calculating Ka in the function
%find_A1
E1 = 87090; %activation energy of forward rxn
E2 = 198464; %activation energy of backward rxn
A2 = 2.75e16; %pre-exponential factor of second equation, assumed to be correct (large magnitude, less sensitive to change)

%% IF estimate A2 instead and assume A1 is correct :
%NOTE: Have to alter the for loop for plot! Because there is an e16 in the loop
%Swap E1 and E2
E = E1; 
E1 = E2;
E2 = E;
%Define the assumed Correct A1, called A2:
A = 1.79e4; %(this is the A1 value in literature)
%Swap A1 and A2
A2 = A;
%%

%Test sensitivity of A1 to A2 and T:
%Assign space for the vector
VECTOR_A2 = 1:0.01:5; %in 10^16
VECTOR_T = 450:900;
VECTOR_A1 = zeros(length(VECTOR_A2), 1);

warning('off','all')
warning
%% Extract data from table
data = csvread('Temp (C) 200 bar data.csv');

[ROW, COL] = size(data);

DATA_TEMP = zeros(ROW,1);
DATA_yNH3 = zeros(ROW, 1);

DATA_TEMP(:,1) = data(:,1) + 273.15; %convert to kelvin
DATA_yNH3(:,1) = data(:,2) / 100; % convert percentage to mole fraction

%forming yNH3 calculator for Temp
coefficients = polyfit(DATA_TEMP,DATA_yNH3,12);

%% Single A value calculation case
T = 678;
A1 = Estimate_A1(coefficients, E1, E2, A2, yN2,yH2,yNH3, yAR, T)

%% PLOTS
% for a = 1:length(VECTOR_A2)   
%     A2 = VECTOR_A2(a)*10^16;    
%     for t = 1:length(VECTOR_T)
%         T = VECTOR_T(t);
%         
%         A1 = Estimate_A1(coefficients,E1, E2, A2, yN2,yH2,yNH3, yAR, T);
%         
%         %Store A1 results
%         VECTOR_A1(t,a) = A1;
%     end
% end
% 
% %ax1 = subplot(2,1,1);
% surf(VECTOR_A2 * 10^16 ,VECTOR_T, VECTOR_A1);
% zlim([0 10^20])
% xlabel('A2') % x-axis label
% ylabel('T/K') % y-axis label
% zlabel('A1') % z-axis label
% set(gca,'fontsize',12, 'FontWeight', 'bold')

% ax2 = subplot(2,1,2);
% surf(sqrt(4*CSA/pi),LENGTH, Volume);
% zlim([0 0.025])
% xlabel('Diameter, m') % x-axis label
% ylabel('Length/m') % y-axis label
% zlabel('Volume Catalyst, m^3') % z-axis label
% set(gca,'fontsize',12, 'FontWeight', 'bold')


