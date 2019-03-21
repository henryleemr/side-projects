% Input Parameters

% X is the max power demand required for any period of insufficient supply
% this includes a "capacity margin" of 10%
% Y is the power produced by the turbine for a known amount of fuel
% mu is the mechanical efficiency of the turbine
% Ynew is the electrical output of the turbine
% Z is the scaling factor between X and Y which can be used to calculate
% the amounts of fuel needed
% SF is a safety factor for the ammonia storage
% minAmmoniaStorage is the minimum amount(kmol) of ammonia storage needed for the
% longest period of insufficient supply
% minAmmoniaStorageVol(m^3) is the volume required store the ammonia needed
% A is the storage requirements of ammonia
% H2cracked is the amount(kmol) of H2 needed from cracking of ammonia
% O2needed is the amount(kmol) of Oxygen needed to stoichiometrically combust the
% NH3 and H2 mix to get NO2 and water

X = 4306;
Y = 31;
mu = 0.6;
SF = 1.5;
A = 0.025;

% Calculating Ynew

Ynew = Y*mu;

% Calculating Z
Z = X/Ynew;

% Calculating minAmmoniaStorage and minAmmoniaStorageVol
minAmmoniaStorage = (SF*(Z*0.471 + (2*Z/3)*0.0471))/1000
minAmmoniaStorageVol = minAmmoniaStorage*A

% Calculating O2needed and H2cracked
O2needed = (Z*1.825*0.471)/1000
H2cracked = (SF*(2*Z/3)*0.0471)/1000