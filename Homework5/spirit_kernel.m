function [ sk ] = spirit_kernel(mc, Nk)
%
%  sk = spirit_kernel(mc, Nk)
%
%  Compute the SPIRiT kernel for a calibration region mc
%
%  mc -- calibration region
%  Nk -- kernel size, should be odd (like 5)
%
%  sk -- SPIRiT kernel 
%        sk is [Nk Nk Nc Nc] in size
%

[Nx Ny Nc] = size(mc);

% set up a matrix with all of the calibration data 
nd = [];
for kk=1:Nc
    nd = [nd im2col(mc(:,:,kk),[Nk Nk], 'sliding').'];
end

% regularization parameter, from Miki Lustig's code
lambda = norm(nd'*nd,'fro')/size(nd,2)*0.01;

% initialize kernel
sk = zeros(Nk,Nk,Nc,Nc);

% offset of the synthesized sample for first coil
ndx1 = floor(Nk*Nk/2)+1;

% calculate weights for each channel
for k=1:Nc
    
   % index of synthesized sample for coil k
   ndx = ndx1 + (k-1)*Nk*Nk;
   
   % find weights by removing corresponding column and fitting to it
   A = [nd(:,1:ndx-1) nd(:,ndx+1:end)];
   AtA = A'*A;
   temp = inv(AtA + eye(size(AtA))*lambda)*A'*nd(:,ndx);
   
   % add a zero placeholder at synthesized sample so we can implement as
   % convolution later
   temp = [temp(1:ndx-1).' 0 temp(ndx:end).'];
   
   % save kernel
   sk(:,:,:,k)  = reshape(temp,Nk,Nk,Nc);
   
end

end
