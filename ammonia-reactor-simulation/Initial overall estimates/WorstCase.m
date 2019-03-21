%To estimate the fuel, NH3, H2 stream flow rate into turbine and also the
%required storage capacity of N2, with corresponding power required in
%reactor and ammonia pre-cracker during zero wind power input and maximum
%output demand over period time.

%Input parameters
%MaxDemand is the max demand W ie J/s
%Efficiency is the efficiency of the turbine
%z is the amount of fuel burnt in kmol/s
%FuelFlow is the amount of fuel burnt in kg/s
%Heat is the total amount of heat power generated from burning fuel in W
%time is the max time duration of zero wind and max demand in s (assume 1 week)

%A is the stored ammonia in m^3/kmol in certain pressure and temperature
%B is the stored hydrogen in m^3/kmol in certain pressure and temperature
%C is the stored nitrogen in m^3/kmol in certain pressure and temperature

%SF is safety factor
%Heat of combustion of ammonia is -382.81kJ/mol
%Heat of combustion of hydrogen gas is -286kJ/mol
%Density of ammonia gas is 17.031kg/kmol
%Density of hydrogen gas is 0.08988 g/L * 22.4L/kmol (ideal, stp)=
%2.013kg/kmol

% Turbine operating conditions:
% Temperature = 800-1073k (Average = 936.5K)	
% Pressure    = 2-5 bar (Average =3.5 bar)	
% 0.8g NH3 and 0.094g H2 (50/50 by vol) burnt produces 31kW of power.

%Turbine input flow rates:
% O2Flow  =0.04-0.07 (Average = 0.055 kmol/s)
% NH3Flow =0.01-0.06 (Average = 0.035 kmol/s)
% H2Flow  =0.009-0.01 (Average = 0.0095 kmol/s)

MaxDemand = 4.306 * 10^6;
Efficiency= 0.6;
time      = 4 * 24 * 3600;
A         =22.4; %m^3/kmol  stp 1 kmol produces 22.4m^3 of gas
B         =22.4;
C         =22.4;
NH3percent= 0.5;
H2percent = 0.5;
SF        = 1.5;

%Obtain amount of fuel burnt kmol/s
%z is fuel burnt in kmol/s = J per kmol of fuel / demand J per s
z = MaxDemand / (NH3percent * 382.81 * 1000 + H2percent * 286 * 1000);

%Account for efficiency
%z is the fuel flow rate in kmol/s
z = z / Efficiency;

%z2 in kg/s where
%Density of ammonia gas is 17.031kg/kmol
%Density of hydrogen gas is 0.08988 g/L * 22.4L/kmol (ideal, stp)=
%2.013kg/kmol
FuelFlow = z * (NH3percent*2.013 + H2percent*17.031);

%Calculate NH3, H2, N2 flow rates in kmol/s
% (0.5)N2 + (1.5) H2 ->  NH3    
NH3Flow = 1.0 * z * NH3percent;
H2Flow = 0.5 * z * NH3percent;
N2Flow = 1.5 * z * NH3percent;

%Calculate the NH3 storage space in kmol
%Note 1.5 is the safety factor
Ammoniastorage = NH3Flow * time * SF;
Hydrogenstorage = H2Flow * time * SF;
Nitrogenstorage = N2Flow * time * SF;

%Calculate component specs in m^3 of gas and power J/s
%Calculate ammonia storage specs in m^3 with safety factor of 1.5
Ammoniastorage = Ammoniastorage * SF * A / 10^3;
Hydrogenstorage = Hydrogenstorage * SF * B / 10^3;
Nitrogenstorage = Nitrogenstorage * SF * C / 10^3;

%Calculate power requirement of reactor in Haber process, excluding power
%for operating conditions
%N2 + 3 H2 -> 2 NH3     (H° = 91.8 kJ) => (H° = 45.8 kJ·mol?1)
Reactorpower = (-45.8 * 10^6) * NH3Flow / 10^6;

%Calculate power requirement of ammonia pre-cracker, excluding power for
%operating conditions
%Assume same enthapy but sign is reversed
Crackerpower = (45.8 * 10^6) * NH3Flow / 10^6;

%Put all results in p for ease of calling
p = struct;

p.FuelFlow          = FuelFlow;
p.NH3Flow           = NH3Flow;
p.N2Flow            = N2Flow;
p.H2Flow            = H2Flow;
P.Ammoniastorage    = Ammoniastorage;
p.Hydrogenstorage  = Hydrogenstorage;
p.Nitrogenstorage   = Nitrogenstorage;
p.Reactorpower      = Reactorpower;
p.Crackerpower      = Crackerpower;

p = p
%FormatSpec = 'Fuel burn rate in kmol/s is';
fprintf('Units: kg/s Kmol/s Kmol/s Kmol/s km^3(gas) km^3(gas) MW MW')

