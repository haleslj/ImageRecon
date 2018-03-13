% Nicholas McKibben
% Laurel Hales
% March 15 
% Image Recon 
% Homework 4
clear all;
close all;

load('brain_8ch.mat');

%% part a: Displaying the data
imax = 1e3;
% imax = 1.5e3;
% imax = 2e3;
figure
montage(reshape(abs(im),160,220,1,8), [0 imax])

%% part b:  Multicoil Reconstruction
im_rsos = (sum(im.^2,3)).^(1/2);
figure
subplot(2,1,2)
imshow(abs(im_rsos),[])
title('Multicoil RSOS Approximation Reconstruction')

im_mcr = 1./sum(abs(map).^2,3).*sum(conj(map).*im,3);
subplot(2,1,1)
imshow(abs(im_mcr),[])
title('Multicoil Reconstruction')