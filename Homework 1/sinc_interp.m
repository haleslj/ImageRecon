function di = sinc_interp(d,x,xi)
% perform sinc interpolation on a sampled signal.

% inputs
%     d -- uniformly sampled data points, spaced by 1
%     x -- uniform sample locations
%     xi -- locations to evalution for the sinc interpolation
%     
% outputs
%     di -- since interpolated values at locations xi

% di=zeros(length(xi),1)';
X=x(2)-x(1);
s=zeros(length(x),length(xi));
for ii=1:length(x)
    s(ii,:)=sinc((xi-x(ii))/X);
end
% for ii=1:length(xi)
% %     di(ii)=sum(d.*sinc(1/T*(xi(ii)-x*T)));
% end
% 

di=d*s;
