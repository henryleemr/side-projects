function [ I_out ] = BestIValue( d,I,m )
%It is necessary that the next smallest singular value, m(n) is bigger than m(n-1). If
%this is not true, this code searches through d for the smallest singular
%value where this is true, and returns the corresponding I value

%Initialise
SuccessFlag = 0;
mvect = zeros(6,1);
Ivect = zeros(6,1);
%Vectors used to store m and I values for successive runs 
mvect(1) = m;
Ivect(1) = I;
j=1;
while SuccessFlag == 0
    d_reduced = ReducedVector(Ivect(j),d); %takes out min. sing. value in
                                           %d so next smallest can be found
    if isempty(d) == 1                     
        error('Suitable kernel estimate could not be found')
    end
    
    j = j+1;
    [mvect(j),Ivect(j)] = min(d_reduced);   %Next smallest sing. value
    if d_reduced(Ivect(j)) >= 100*mvect(j-1)    %this must be >> m 
        SuccessFlag = 1;
        I_out = Ivect(j-1);                     %if true return this and exit loop
    end
    d = d_reduced;                          %if not, go around loop again
end
end


