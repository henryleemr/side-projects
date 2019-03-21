function [p, StoicTable]= TemkinPyzhevSanity(p, StoicTable)

% Extract all info to be tested
k = p.k; 
Alpha = p.Alpha;

% Test for Alpha
if  Alpha< 0.5 || Alpha>0.75
    error('Alpha is out of range 0.5-0.75');
end

