function [ ms ] = apply_spirit(m, sk)
%
%  ms = apply_spirit(m, sk)
%
%  Apply a SPIRiT kernel to a data set m
%
%    m  -- k-space data
%    sk -- SPIRiT kernel
%
%    ms -- operator sk applied to m
%

[Nx Ny Nc] = size(m);

% zero out output array
ms = zeros(Nx, Ny, Nc);

% for each output channel
for k=1:Nc
    % sum over all of the input channels
    for kk = 1:Nc
        ms(:,:,k)  = ms(:,:,k) + filter2(sk(:,:,kk, k),m(:,:,kk));
    end
end

end
