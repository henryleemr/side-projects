% For the case of 200 bar, initial yN2 = 0.2475, yH2 = 0.7425, yAR= 0.1
yN2 = 0.2475; % Not sure!
yH2 = 0.7425;
yAR= 0.1;

%Extract data from table
data = csvread('Temp (C) 200 bar data.csv');

[ROW, COL] = size(data);

DATA_TEMP = zeros(ROW,1);
DATA_yNH3 = zeros(ROW, 1);

DATA_TEMP(:,1) = data(:,1) + 273.15; %convert to kelvin
DATA_yNH3(:,1) = data(:,2) / 100; % convert percentage to mole fraction

%% Plotting to confirm validity of fit from data
% plot(DATA_TEMP,DATA_yNH3, 'LineWidth', 0.9);
% title('NH3 eq conc vs Temperature ')
% xlabel('T/K')
% ylabel('NH3 eq conc, mole fraction')
% 
% Hence, polyval(coefficients, T) is now the function that returns a
% specific equilibrium NH3 mole fraction at equilibrium at 200 bar
% coefficients = polyfit(DATA_TEMP,DATA_yNH3,5);
% 
% yNH3 = polyval(coefficients,DATA_TEMP);
% hold on
% plot(DATA_TEMP,yNH3,'--r')

%% Plot Xeq vs T
TEMP = 450:1:900;
XEQUIL = zeros(length(TEMP),1);

for i = 1:length(TEMP)
    
    T = TEMP(i);
    %forming yNH3 calculator for Temp
    coefficients = polyfit(DATA_TEMP,DATA_yNH3,12);
    yNH3 = polyval(coefficients,T);
    
    %Xeq = (yN20 - yNH2_OUT)*FTOTIN/ (yN20*FTOTOUT)by definition;
    %Since Fj = Fj / FN2 = yj*Ftot / yN2*Ftot = yj / yN2
    a = yH2/yN2;
    b = yAR/yN2;
    c = yNH3/yN2;
    
    % N2 Xeq: (pg 97, 108 logbook) with reference to a stoichiometric table
    Xeq = (yNH3*(1+a+b+c) - c) / (2 * (yNH3 +1));
    
    %Store Xeq values into XEQUIL
    XEQUIL(i) = Xeq;
end
figure
plot(TEMP,XEQUIL, 'LineWidth', 0.9);
title('XEQUIL vs Temperature ')
xlabel('T/K')
ylabel('N2 Equilibrium Conversion')
grid on
set(gca,'fontsize',12, 'FontWeight', 'bold')
