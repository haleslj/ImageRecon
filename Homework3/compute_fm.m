function [ fm ] = compute_fm( im1, te1, im2, te2 )
% Creates a field map using two GRE echos.
    dphi = angle(im2.*conj(im1));
    del_te = abs(te2 - te1);
    w = dphi/del_te;
    fm = 1/(2*pi)*w;

%     fm = (angle(im2) - angle(im1))/del_te;
%     threshold = 0.1 * max(max(fm));
%     fm = fm.* (fm > threshold);

end

