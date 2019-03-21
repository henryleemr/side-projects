function [p, StoicTable]= TemkinPyzhevSanity(p, StoicTable)

% Extract all info to be tested
P = p.P;
T = p.T;
k = p.k; 
Alpha = p.Alpha;

% Test for P/ atm
if  P< 150 || Alpha>300
    error('P is out of range 150-300 atm');
end

% Test for T/ Kelvin
if  T< 600 || T>900
    error('Alpha is out of range 600-900 Kelvin');
end

% Test for Alpha
if  Alpha< 0.5 || Alpha>0.75
    error('Alpha is out of range 0.5-0.75');
end