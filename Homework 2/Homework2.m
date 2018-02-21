clear all;
close all;

load('rt_spiral_03.mat')

%% Problem 1: Normal weighting
m1 = grid1(d, k, 128);
im1 = ifftshift(ifft2(ifftshift(m1)));

figure
subplot(2, 1, 1)
imshow(abs(im1), [])
title('Basic 1x Recon')

pw_d = d.*w;
pw_m = grid1(pw_d, k, 128);
pw_im = ifftshift(ifft2(ifftshift(pw_m)));
subplot(2,1,2)
imshow(abs(pw_im), [])
title('Prewhitened 1x Recon')

%The dominant low-frequency artifact is due to the fact that a spiral
%trajectory oversamples the center of k-space, or the low-spatial
%frequencies. 

%% Problem 2: Oversampled Gridding Reconstruction
m2 = grid2(pw_d, k, 256);
im2 = ifftshift(ifft2(ifftshift(m2))); 

figure
imshow(abs(im2), [])
title ('Prewhitened 2x Recon')

%% Problem 3: Deapodization Corection 

x = [-128:127]/128;
cx = sinc(x/2).^2;
cx = cx/cx(128);
cxy = cx'*cx;
im3 = im2.*cxy;
figure 
imshow(

