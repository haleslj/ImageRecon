function [ rf ] = wsinc( timebw, samples )
%computes a Hamming windowed sinc pulse given a time-bandwith product and
%number of samples

%   rf - magnitude Hamming windowed sinc pulse
%   timebw - time-bandwidth 
%   samples - the number of samples

t = linspace(-timebw/2,timebw/2,samples);

hamm = hamming(samples);
sincpulse = sinc(t);

rf = sincpulse'.*hamm;
rf = rf/sum(rf);

end

