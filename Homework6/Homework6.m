% Laurel Hales
% Nicholas McKibben 
% March 29, 2108
% Image Recon 
% Homework 6 

close all;
clear all;

%% Problem 1: Design Windowed Sinc RF Pulses 
figure 
hold on
for ii = [4,8,12]
    rf = wsinc(ii,100);
    plot(rf)
end
title ('Normalized Windowed Sinc Function')
legend ('TBW = 4', 'TBW = 8', 'TBW = 12')
hold off

%% Problem 2: Plot RF Amplitude
rf = (pi/2)*wsinc(8, 256);

rfs = rfscaleg(rf, 3.2);

figure
t = linspace(0,3.2,length(rfs));
plot(t, rfs)
xlabel('pulse duration (ms)')
ylabel('RF pulse magnitude (Gauss)')

%% Problem 3: Simulated Slice Profiles
x = -15:1:15;
G = 0.6; %G/cm
pulseDur = 3.2;

figure
plot(gt2cm(x,G,pulseDur), abs(ab2ex(abrm(rf,x))));
title('Slice Selection Profile')
xlabel('position (cm)')
ylabel('Amplitude')

% Given that our time bandwidth is about 8, we would expect the width of
% the pulse to be TBW * 1/(gamma/(2*pi) * G * pulseDur) Which in this case
% is about 0.97 cm, which roughly matches the width from the image. 


%% Problem 4: Design a Slab Select Pulse 
pulseDur = 6;
RF_max = 0.17;

%a. Try a few different values of TBW
trial1 = max(rfscaleg(pi/2*wsinc(10, 256), pulseDur))
trial2 = max(rfscaleg(pi/2*wsinc(20, 256), pulseDur))
trial3 = max(rfscaleg(pi/2*wsinc(18, 256), pulseDur))
trial4 = max(rfscaleg(pi/2*wsinc(17, 256), pulseDur))

% 17 is an appropriate value for the time bandwidth. It does not create a
% pulse larger than the maximum RF strength in Gauss. 

% b. Given the formulas as explained above, it is easy enough to solve for G 

G = 17/8 *1/(4.257*pulseDur)

%c. 

x = -15:0.25:15;
rf=pi/2*wsinc(17,256);

figure
subplot(2,1,1)
plot(gt2cm(x,G,pulseDur), abs(ab2ex(abrm(rf,x))));
title('Slice Selection Profile')
xlabel('position (cm)')
ylabel('Amplitude')

passband_lim = 0.95 * max(abs(ab2ex(abrm(rf,x))));
stopband_lim = 0.05 * max(abs(ab2ex(abrm(rf,x))));

subplot(2,1,2)
hold on 
plot(gt2cm(x,G,pulseDur), abs(ab2ex(abrm(rf,x))));
xlim([3 5])
plot([3 5],[stopband_lim, stopband_lim])
plot([3 5],[passband_lim, passband_lim])
hold off
title('Slice Selection Profile')
xlabel('position (cm)')
ylabel('Amplitude')

% The passband is about 8cm, as we expected. We found that the transition
% band is about 0.8cm, We would expect the transition bad to be 8cm/(17/2)
% = 0.94 cm. We are on the same order which is about what we would be
% expecting. 

