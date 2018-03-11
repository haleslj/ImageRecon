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

% We want to look at the whole map first without masking out any
% frequencies:
subplot(1,3,3);
imshow(abs(fm), []);
title('Field Map');

% Limit our attention to pixels whose amplitude is greater than 10% of the
% maximum
msk = double(abs(im1) > .1*max(max(abs(im1))));

% What range of frequencies do we observe?
fprintf('Range of frequencies in field map: %f -> %f\n', ...
    min(min(fm.*msk)),max(max(fm.*msk)));

%% 2. Multfrequency Reconstruction 

tad = size(d1,1)*samp;
fmin = -128;
fmax = 128; 
fstep = 16; 
n = 160;

im_mf = mf_recon(d1, ks, wt, n, te1, tad, fmin, fmax, fstep);
fs = fmin:fstep:fmax;

des_freqs = [ -128 -64 0 64 128 ];
figure(2);
for ii = 1:numel(des_freqs)
    subplot(1,numel(des_freqs),ii);
    imshow(abs(im_mf(:,:,fs == des_freqs(ii))),[]);
    title(sprintf('@ %d Hz',des_freqs(ii)));
end

%% 3. Field Map Based Reconstruction


im1_fm = im1.*exp(-1i*2*pi*fm);
figure(9)
imshow(abs(im1_fm),[])
