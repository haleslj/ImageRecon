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
% des_freqs = des_freqs/2;
figure(2);
for ii = 1:numel(des_freqs)
    subplot(1,numel(des_freqs),ii);
    imshow(abs(im_mf(:,:,fs == des_freqs(ii))),[]);
    title(sprintf('@ %d Hz',des_freqs(ii)));
end

%% 3. Field Map Based Reconstruction
fms = round((fm - fmin)/fstep) + 1;
fms = max(fms,1);
fms = min(fms,numel(fs));

im_mp = zeros(n,n);
for ii = 1:n
    for jj = 1:n
        im_mp(ii,jj) = im_mf(ii,jj,fms(ii,jj));
    end
end

figure(3);
imshow(abs(im_mp),[]);
title('Field Map Based Reconstruction');

%% (4) Autofocus Reconstruction
im_r=mf_recon(d1(1:256,:),ks(1:256,:),wt(1:256,:),n,te1,tad/8,fmin,fmax,fstep);
pc = exp(-1i*angle(im_r));
des_freqs_2 = [-128, -64, 0, 64];
for ii = 1:numel(des_freqs_2)
    figure (3+ ii)
    imshow(abs(imag(im_mf(:,:,fs==des_freqs_2(ii)).*pc(:,:,fs==des_freqs_2(ii)))),[])
    title(sprintf('Unfocused metric with frequency of %dHz',des_freqs_2(ii)))
end

% part b Focused metric
fc = abs(imag(im_mf.*pc));
fcf = 0*fc;

%for each frequency we integrate over a 5x5 window
for ii = 1:numel(fs)
    fcf(:,:,ii) = conv2(fc(:,:,ii), ones(5,5)/25, 'same');
end

for ii = 1:numel(des_freqs_2)
    figure (6 + ii)
    imshow(abs(fcf(:,:,fs==des_freqs_2(ii))),[])
    title(sprintf('Focused metric with frequency of %dHz',des_freqs_2(ii)))
end

%part c Autofocus reconstruction 
im_af = zeros(n);
[minval, minloc] = min(fcf,[],3);
fm_af = fs(minloc);

for ii = 1:n
    for jj = 1:n
        im_af(ii,jj) = im_mf(ii,jj,minloc(ii,jj));
    end
end
figure
imshow(abs(im_af), [])
title('Autofocus Reconstructed Image')

figure
imshow(abs(fm_af), [])
title('Autofocus Fieldmap')

%%
% In order to fix the image we should restrict ourselves to the range of
% values representing one complete clycle so +/-64 Hz. When using that
% range you can see that the image is much clearer, paricularly the ends of
% the tines of the comb. 


fmin2 = -64;
fmax2 = 64; 
fstep = 16; 
n = 160;

im_mf2 = mf_recon(d1, ks, wt, n, te1, tad, fmin2, fmax2, fstep);
fs2 = fmin2:fstep:fmax2;

im_r2=mf_recon(d1(1:256,:),ks(1:256,:),wt(1:256,:),n,te1,tad/8,fmin2,fmax2,fstep);
pc2 = exp(-1i*angle(im_r2));

fc2 = abs(imag(im_mf2.*pc2));
fcf2 = 0*fc2;

%for each frequency we integrate over a 5x5 window
for ii = 1:numel(fs2)
    fcf2(:,:,ii) = conv2(fc2(:,:,ii), ones(5,5)/25, 'same');
end

%part c Autofocus reconstruction 
im_af2 = zeros(n);
[minval2, minloc2] = min(fcf2,[],3);
fm_af2 = fs2(minloc2);

for ii = 1:n
    for jj = 1:n
        im_af2(ii,jj) = im_mf2(ii,jj,minloc2(ii,jj));
    end
end
figure
imshow(abs(im_af2), [])
title('Improved Autofocus Reconstructed Image')

figure
imshow(abs(fm_af2), [])
title('Improved Autofocus Fieldmap')
