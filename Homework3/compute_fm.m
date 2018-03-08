function [ fm ] = compute_fm( im1, te1, im2, te2 )
% Creates a field map using two GRE echos.
del_te = te2 - te1;

fm = (angle(im2) - angle(im1))/del_te;

threshold = 0.1 * max(max(fm));

fm = fm.* (fm > threshold);

end

