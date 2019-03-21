function [p, StoicTable]= TemkinPyzhevSanity(p, StoicTable)

% Extract all info to be tested
k1 = p.k1; 
k2 = p.k2;
PH2 = p.PH2; 
PN2 = p.PN2;
PNH3 = p.PNH3;
Alpha = p.Alpha;

% Test for Alpha
if  Alpha< 0.5 || Alpha>0.75
    error('Alpha is out of range 0.5-0.75');
end

