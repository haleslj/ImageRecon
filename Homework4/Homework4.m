% Nicholas McKibben
% Laurel Hales
% March 15 
% Image Recon 
% Homework 4
clear all;
close all;

load('brain_8ch.mat');

%% part 1: Displaying the data
imax = 1e3;
% imax = 1.5e3;
% imax = 2e3;
figure(1)
montage(reshape(abs(im),160,220,1,8), [0 imax])

%% part 2:  Multicoil Reconstruction
im_rsos = sqrt(sum(im.*conj(im),3)); % changed
figure(2)
subplot(2,1,2)
imshow(abs(im_rsos),[])
title('Multicoil RSOS Approximation Reconstruction')

im_mcr = 1./sum(abs(map).^2,3).*sum(conj(map).*im,3);
subplot(2,1,1)
imshow(abs(im_mcr),[])
title('Multicoil Reconstruction')

%% part 3: g-Factor Maps

figure(3)
subplot(3,3,1)
g = gfactor(map, 2, 1);
imshow(abs(g),[0,5])

subplot(3,3,2)
map2 = map(1:end-1,:,:);
g = gfactor(map2, 3, 1);
imshow(abs(g),[0, 5])

subplot(3,3,3)
g = gfactor(map, 4, 1);
imshow(abs(g),[0, 5])

subplot(3,3,4)
g = gfactor(map, 1, 2);
imshow(abs(g),[0, 5])

subplot(3,3,5)
map2 = map(:,1:end-1,:);
g = gfactor(map2, 1, 3);
imshow(abs(g),[0, 5])

subplot(3,3,6)
g = gfactor(map, 1, 4);
imshow(abs(g),[0, 5])

subplot(3,3,8)
g = gfactor(map, 2, 2);
imshow(abs(g),[0, 5])

%% part 4: Generate Undersampled Images
ima = undersample(im, 2, 2);
figure(4)
montage(reshape(abs(ima),160,220,1,8), [ 0 imax])

%% part 5: SENSE Reconstruction 
xs = [2 4 1 1 2];
ys = [1 1 2 4 2];

figure(5)
for ii = 1:length(xs)
    ima = undersample(im, xs(ii), ys(ii));
    im2 = sense(ima, map, xs(ii), ys(ii));
    subplot(3,2,ii)
    imshow(abs(im2),[])
    title(sprintf('Rx=%d and Ry =%d', xs(ii), ys(ii)))
end



