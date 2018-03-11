% Laurel Hales
% Nicholas McKibben
% Image Reconstruction 
% Homework 3

close all;
clear;

load('resphantom2.mat'); clear ans;

% Field Maps
n = 160;
osf = 2;
kosf = 5;

im1 = gridkb(d1, ks, wt, n, osf, kosf, 'image');
im2 = gridkb(d2, ks, wt, n, osf, kosf, 'image');

% Trim down to size and flip
idy = round((.5*n*(osf-1)+1):(.5*n*(osf+1)));
idx = fliplr(idy);
im1 = im1(idx,idy);
im2 = im2(idx,idy);

figure(1);
subplot(1,3,1);
imshow(abs(im1), []);
title('Reconstruction of 1st echo');

subplot(1,3,2);
imshow(abs(im2),[]);
title('Reconstruction of 2nd echo');

fm = compute_fm(im1, te1, im2, te2);

subplot(1,3,3);
imshow(fm, []);
title('Field Map');

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


im1_fm = im1.*exp(-1i*2*pi*fm);
figure(9)
imshow(abs(im1_fm),[])
