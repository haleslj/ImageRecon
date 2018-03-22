function [ ima,ku ] = undersample( im, Rx, Ry )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[Nx, Ny, L] = size(im);

IM = fftshift(fft2(fftshift(im))); 
IM1 = zeros(size(IM));

idx = 1:Rx:Nx;
idy = 1:Ry:Ny;
IM1(idx,idy,:) = IM(idx,idy,:);
ima = ifft2(IM1);
ku = IM1;
end

