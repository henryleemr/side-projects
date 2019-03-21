function [p] = BuildCamera

% Define the values of the parameters in appriopriate ranges specified...
FocalLength   = 10;
PixelWidth    = 0.001;
PixelHeight   = 0.001;
Skewness      = 0;
P_u           = 0.25;
P_v           = 0.25;
FuPixels      = FocalLength / PixelWidth;
FvPixels      = FocalLength / PixelHeight;
CameraHeight  = 2500;
CameraWidth   = 2000;
KMatrix       = [FuPixels   Skewness    P_u*CameraWidth;...
                  0         FvPixels    P_v*CameraHeight;...
                  0         0           1];

% and then put it inside p for ease of calling
% Note that CameraHeight is ChipHeight and CameraWidth is Chipwidth
p = struct;

p.FocalLength   = FocalLength;
p.PixelWidth    = PixelWidth;
p.PixelHeight   = PixelHeight;
p.Skewness      = Skewness;
p.P_u           = P_u;
p.P_v           = P_v;
p.FuPixels      = FuPixels;
p.FvPixels      = FvPixels;
p.CameraHeight  = CameraHeight;
p.CameraWidth   = CameraWidth;
p.KMatrix       = KMatrix;






