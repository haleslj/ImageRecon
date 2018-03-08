% Laurel Hales
% Nicholas McKibben
% Image Reconstruction 
% Homework 3

close all; clear all; 

load('resphantom2.mat');

% Field Maps
im1 = gridkb(d1, ks, wt, 160, 1, 4, 'image');
im2 = gridkb(d2, ks, wt, 160, 1, 4, 'image');
im1 = flipud(im1);
im2 = flipud(im2);

figure (1)
imshow(abs(im1), [])
title('Reconstruction of 1st echo')

figure(2) 
imshow(abs(im2),[])
title('Reconstruction of 2nd echo')

fm = compute_fm(im1, te1, im2, te2);

figure (3)
imshow(fm, [])
title('Field Map')

%% 2. Multfrequency Reconstruction 

tad = 8.192e-3; 
fmin = -128;
fmax = 128; 
fstep = 16; 
n = 160; 
images = [1, 5, 9, 13, 17];

im_mf = mf_recon(d1, ks, wt, n, te1, tad, fmin, fmax, fstep);
freqs = fmin:fstep:fmax;

for ii = 1:length(images)
figure(ii+3) 
imshow(abs(im_mf(:,:,images(ii))),[])
title(sprintf('Reconstruction at %d Hz', freqs(images(ii))))
end

%% 3. Field Map Based Reconstruction


