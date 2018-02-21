function du = trial(dn,xn,xu)
% 
% inputs
%     dn -- non-uniformly sampled data points
%     xn -- non-uniform sample locations
%     xu -- uniform sample points, spaced by 1
% outputs
%     du -- uniformly sampled data
dn=dn.';
E=zeros(length(xn),length(xu));
X=abs(xu(2)-xu(1));
for ii=1:length(xn)
    for jj=1:length(xu)
        E(ii,jj)=((xn(ii)-xu(ii))/X);
    end
end
du=E\dn;
        

