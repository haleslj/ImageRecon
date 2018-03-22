function [ima ma] = sol_undersample(im,Rx,Ry)
%
%[ima ma] = undersample(im,Rx,Ry)
% generate an accelerated data set
%
% im -- original images
% Rx -- acceleration in x
% Ry -- acceleration in y
%
% ima -- aliased image data
% ma -- undersampled k-space data (optional)
%
%
% written by John Pauly
% (c) Board of Trustees, Leland Stanford Jr University, 2011
%
 fft2c = @(x) fftshift(fft2(fftshift(x)));
 ifft2c = @(x) ifftshift(ifft2(ifftshift(x)));

[Nx Ny L] = size(im);
ima = zeros(Nx,Ny, L);
ma = zeros(Nx,Ny,L);
msk = zeros(Nx,Ny);
for ii=1:Rx:Nx,
    for jj=1:Ry:Ny,
        msk(ii,jj) = 1;
    end
end
% for each coil
for ll=1:L
    ma(:,:,ll) = fft2c(im(:,:,ll)).*msk;
    ima(:,:,ll) = ifft2c(ma(:,:,ll));
end;