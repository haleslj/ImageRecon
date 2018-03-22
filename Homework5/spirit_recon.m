function [ mr, msed] = spirit_recon(ma, mc, Nk, Ni)
%
% reconstruct an undersampled data set, using a calibration set mc, which
% need not be the same
%
% ma -- k-space data
% mc -- calibration data
% Nk -- kernel size
% Ni -- number of interations
%
% mr -- reconstructed k-space data
%
% keep a mask of the known data
known_data = (ma ~= 0);
unknown_data = (ma == 0);
% perform the calibration
sk = spirit_kernel(mc, Nk);
%initialize reconstruction

mr = ma;
msed = [];
mrp = mr;
% iterate applying kernel, and enforcing data consistency
for n =1:Ni
    mr = apply_spirit(mr, sk);
    mr = (ma.*known_data) + mr.*unknown_data;
    msed = [msed sum(sum(sum(abs(mr-mrp).^2)))];
    mrp = mr;
end

end