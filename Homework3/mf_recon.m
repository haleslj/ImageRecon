function [ im_mf ] = mf_recon( d, k, w, n, te, tad, fmin, fmax, fstep)
% Takes a data set and returns a reconstruction over a set of frequencies
% using the discrete time algorithm (Actually I'm not using that method,
% I'm using the less elegant but easier to implement method of doing a full
% gridding for each frequency.
%   d - acquired data set
%   k - k space trajectory
%   w - preweighting factor
%   n - size of final image
%   te - echo time for data set
%   tad - A/D or readout time
%   fmin - starting frequency for reconstruction 
%   fmax - ending frequency for reconstruction
%   fstep - frequency step size for reconstruction 

f = fmin:fstep:fmax;
nf = length(f);
[ns, ni] = size(d); 
t = te + [0:ns-1]*tad/ns;
t = t'; 
t = repmat(t,1,ni);
im_mf = zeros(n,n,nf);

for ii = 1:length(f)
   data = d.*exp(-1i*2*pi*f(ii)*t);
   im = gridkb(data, k, w, n, 1, 4, 'image');
   im = flipud(im);
   im_mf(:,:,ii) = im;  
end
end

