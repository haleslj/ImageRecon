function [ rfs ] = rfscaleg( rf, t )
% Takes a pulse measured in radians and converts it into gauss
%   t - pulse duration (in ms)

gamma = 2*pi * 4.257; %kHz/G
dt = t/length(rf);
rfs = rf/(gamma*dt);
end

