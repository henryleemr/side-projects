function [ KernelEstimate ] = FindKernelEstimate(Matrix )
%Matrix will have no 'real' kernel due to noise
%(x, where Ax = 0) where Matrix is the regressor
%So find vector x that minimises norm of Ax using svd

%Input check
s = size(Matrix);
if rank(Matrix) ~= s(2)
    error('Regressor should be full rank')
end

% Find the singular value decomposition
[~,D,V] = svd(Matrix,'econ');

%Check D is square
sizeD = size(D);
if sizeD(1)  ~= sizeD(2)
    error('Matrix D not square')
end

% Convert the diagonal matrix D into a vector
d = diag(D);  

if length(d) ~= 6
    error('d vector must be length 6')
end

% Find the smallest singular value, element I
[m,I] = min(d);

BestI = BestIValue(d,I,m);

KernelEstimate = V(:,BestI);
