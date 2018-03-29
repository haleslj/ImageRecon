function [ xs ] = gt2cm( x, g, t )
% Takes a demensionless x to true spacial position (cm) using 

%   g - gradient amplitude (G/cm)
%   t - pulse duration (ms)

gamma = 4.257; % rad/G;
k_max = gamma*g*t/2;
dx = 1/(2*k_max);
xs = x*dx;
end

