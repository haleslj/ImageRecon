%Laurel Hales
%Nicholas McKibben
%March 22, 2018
%Image Recon
%Homework 5

close all; clear all;

load('brain_8ch.mat');

[Nx, Ny, Nc] = size(map);

m2 = reshape(map, Nx*Ny, Nc);

[ev, ed] = eig(m2'*m2);

eigval = diag(ed); 
[eigval, I] = sort(eigval, 'desc');
eigval = eigval/sum(eigval);

ev = ev(:,I);

ecmap = reshape(m2*ev, Nx, Ny, Nc);

figure(1)

for ii = 1:size(ecmap,3)
subplot(8,2,2*ii-1) 
imshow(abs(ecmap(:,:,ii)),[])
title(sprintf('Magnitude of eigenmap number %d',ii));

subplot(8,2,2*ii)
imshow(angle(ecmap(:,:,ii)),[])
title(sprintf('Phase of eigenmap number %d',ii));    
end

% The first four maps cary the majority of the energy. The first map itself
% contains 65% of the energy. The last four terms contain only 0.58% of the
% energy. 

%The number of phase wraps in the phase of the eigencoils is approximately
%the the same as the ranked number of the eigencoil. This isn't a perfect
%approximation 

%% 1.b: the g-factor
addpath('../Homework4')

gall = gfactor(ecmap,2,2);

g4 = gfactor(ecmap(:,:,1:4),2,2);

g5 = gfactor(ecmap(:,:,1:5),2,2);

g6 = gfactor(ecmap(:,:,1:6),2,2);

figure(2)
subplot(2,2,1)
imshow(abs(gall),[]);
title('g-factor of eigen maps with all eigencoils')

subplot(2,2,2)
imshow(abs(g4),[]);
title('g-factor of eigen maps with 4 eigencoils')

subplot(2,2,3)
imshow(abs(g5),[]);
title('g-factor of eigen maps with 5 eigencoils')

subplot(2,2,4)
imshow(abs(g6),[]);
title('g-factor of eigen maps with 6 eigencoils')

% The g-factor maps allow us to see the effect of using more eigen coils.
% There is some slight improvement after adding the 5th eigencoil but
% adding the 6th eigencoil makes no discernable difference. 

%% 1c: Coil Compression 
im2 = reshape(im, Nx*Ny, Nc);

ecim = reshape(im2*ev, Nx, Ny, Nc);

figure(3)

for ii = 1:size(ecim,3)
subplot(4,2,ii) 
imshow(abs(ecim(:,:,ii)),[0, abs(max(max(ecim(:,:,1))))/1])
title(sprintf('Image reconstructed using eigencoil number %d',ii));
end

%% 1d: SENSE Reconstruction 
num_eigcoils = [4, 5, 6];

figure(4)
for ii = 1:length(num_eigcoils)
    ima = undersample(ecim(:,:,1:num_eigcoils(ii)), 2, 2);
    im2 = sense(ima, ecmap(:,:,1:num_eigcoils(ii)), 2, 2);
    subplot(numel(num_eigcoils),1,ii)
    imshow(abs(im2),[])
    title(sprintf('SENSE Recon using %d of the eigencoils',num_eigcoils(ii)))
end

%% 2: Parallel Imaging with SPIRiT

 fft2c = @(x) fftshift(fft2(fftshift(x)));
 ifft2c = @(x) ifftshift(ifft2(ifftshift(x)));
%  for ii = 1:8
%  IM(:,:,ii) = fft2c(im(:,:,ii));
%  end
 IM = fft2c(im);
 
 x_start = Nx/2-12;
 x_end = Nx/2+11;
 y_start = Ny/2-12;
 y_end = Ny/2+11;
 
mc = IM(x_start:x_end, y_start:y_end,:);
sk = spirit_kernel(mc, 5);

mr = IM;

for ii =1:10
    mr = apply_spirit(mr, sk);
end

% for ii = 1:8
%     spim = ifft2c(ms(:,:,ii));
% end

 spim = ifft2c(mr);

figure(5)
subplot(1,3,1)
imshow(abs(im(:,:,1)),[])
title('Original Coil 1 Image')

subplot(1,3,2)
imshow(abs(spim(:,:,1)),[])
title('SPIRiT Recon after 10 iters');

subplot(1,3,3)
imshow(abs(im(:,:,1) - spim(:,:,1))*10,[])
title('Difference Image*10')

%% 2b

Rx = 2;
Ry = 2;

[~,uim] = undersample(im,Rx,Ry);
[ mr,ed ] = uspirit(uim,mc,5,100);

recon = ifft2c(mr);

% Plot 'em
figure(6)
montage(reshape(abs(recon),160,220,1,8), [ 0 1000 ])
title('SPIRiT Reconstruction Coil Images after 100 Iterations')

figure(7)
semilogy(ed);
title('Energy difference between iterations')

figure(8)
montage(reshape(abs(recon - im)*10,160,220,1,8), [ 0 500 ])
title('10x Difference Between Origial and SPIRiT')

figure(9)
imshow(sqrt(sum(recon.*conj(recon),3)),[])
title('RSOS SPIRiT Recon')


[~,uim] = undersample(im,Rx,Ry);

uim(x_start:x_end, y_start:y_end,:) = mc;

[ mr,ed ] = uspirit(uim,mc,5,100);
recon = ifft2c(mr);

% Plot 'em
figure(10)
montage(reshape(abs(recon),160,220,1,8), [ 0 2000 ])
title('SPIRiT Reconstruction of individual coil data including Calibration Data after 100 Iterations')

figure(11)
semilogy(ed);
title('Energy difference between iterations (Calibration data included)')

figure(12)
montage(reshape(abs(recon - im)*10,160,220,1,8), [ 0 500 ])
title('10x Difference Between Origial and SPIRiT with Calibration Data')

figure(13)
imshow(sqrt(sum(recon.*conj(recon),3)),[])
title('RSOS SPIRiT Recon with Calibration Data')

%We ran the the reconstruction for 100 iterations. There is significant
%change in the error during these 100 iterations but the error does not
%decrease as much after that. 

% We found that including the calibration data did improve the
% reconstruction. The error between iterations was improved by a factor of
% 10. 

%% 2c: Random Sampling 
% choose random phase encodes
msk1 = (rand(size(IM(:,:,1))) > 0.60);
% copy to all coils
msk = repmat(msk1,[1 1 8]);
% mask the data off
mr = IM.*msk;

mr(x_start:x_end, y_start:y_end,:) = mc;

[ mr,ed ] = uspirit(mr,mc,5,300);

recon = ifft2c(mr);

% Plot 'em
figure(14)
montage(reshape(abs(recon),160,220,1,8), [ 0 1000 ])
title('SPIRiT Reconstruction Coil Images after 100 Iterations')

figure(15)
semilogy(ed);
title('Energy difference between iterations')

figure(16)
montage(reshape(abs(recon - im)*10,160,220,1,8), [ 0 500 ])
title('10x Difference Between Origial and SPIRiT')

figure(17)
imshow(sqrt(sum(recon.*conj(recon),3)),[])
title('RSOS SPIRiT Recon')

% The SPIRiT reconstrcuction worked fairly well with 100 iterations and a
% 50% undersmapling. However if we removed 75% of the data the visual image
% quality was poor even after tripling the number of iterations. The number
% of iterations did not seem to matter as much in the actual convergence 