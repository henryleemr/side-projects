function [ d_reduced ] = ReducedVector( I,d )
%ReducedVector removes row I from a vector d of length 6

if I > length(d) || I < 0
    error('row to be removed must be within the vector d')
end

if I == 1
    d_reduced = d(2:6);
elseif I == 6
    d_reduced = d(1:5);
else
    d_reduced = [d(1:I-1) ; d(I+1:6)];
end

end

