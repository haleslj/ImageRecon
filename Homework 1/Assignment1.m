% Laurel Hales
% Image Reconstruction
% January 13, 2017
% Homework 1
close all
clear all


%% Problem 1
d = [zeros(1,10) [10:-1:1] 0 [1:10] zeros(1,10)];
x = [-20:20];

figure(1)
subplot(211)
stem(x,d);
xlabel('x')
print -dpdf plot1.pdf

xi = [-20:0.1:20];
di=sinc_interp(d,x,xi);
% for ii=1:length(xi)
%     di(ii)=sum(d.*sinc(1/T*(xi(ii)-x*T)));
% end


figure(2)
subplot(211)
plot(xi,di); 
hold on
stem(x,d)
print -dpdf plot2.pdf



%% Problem 2

db = [di(3:20:end) di(8:20:end)];
xb = [xi(3:20:end) xi(8:20:end)];

figure(3)
stem(xb,db);
hold
plot(xi,di)
hold off


% x2=x(1:40);
% d2=d(1:40);
du=sinc_resample(db,xb,x);
figure(4)
stem(x,du)

%% Problem 3: Random Samples
ndx=unique(randi(length(di),1,50));
dr=di(ndx)
xr=xi(ndx);
stem(xr,dr)
hold
plot(xi,di)

du=sinc_resample(dr,xr,x);
figure(5)
stem(x,du)

%% Problem 4: Interpolators
dp15=zeros(1,length(dr));
dp15(15)=1;
dp15u=sinc_resample(dp15,xr,x);

figure(6)
stem(xr,ones(1,length(xr)))
hold 
plot(xi,sinc_interp(dp15u',x,xi))


%% Problem 5: Signal Noise and Sample Timing Jitter
drn = dr + 0.25*randn(size(dr));
du = sinc_resample(drn,xr,x);
figure, plot(xi,di);  % ground truth
hold; 
stem(x, du);    % uniform samples
plot(xr,drn,'r.');    % random samples, with noise



ndx=unique(randi(length(di),1,100));
dr=di(ndx);
xr=xi(ndx);
xrn = xr + 0.05*randn(size(xr));
du = sinc_resample(dr,xrn,x);
figure, plot(xi,di);  % ground truth
hold; stem(x, du);    % uniform samples
plot(xrn,dr,'r.');    % random samples, with jitter
hold off