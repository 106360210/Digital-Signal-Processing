% downsampling & upsampling 
clear; clc; close all
fp = fopen('..\audio\test_1.wav','rb');

% Spectrum parameters setup
window = hamming(128); 
noverlap = 120; % Number of overlapping samples per segment
nfft = 128; % Length of FFT transformation

x = fread(fp,'short'); 
Fs = 16000; 
subplot(3,1,1); plot(x); 
xlabel('time in samples') 
title('audio sampled at 16kHz') % sound(x./32766,Fs,16)  

% downsampling 
y = decimate(x,2); 
subplot(3,1,2); plot(y); 
xlabel('time in samples') 
title('audio downsampled from 16kHz to 8kHz'); %sound(y./32766,Fs/2,16) 
% upsampling 
z = interp(x,2); 
subplot(3,1,3); plot(z); 
xlabel('time in samples') 
title('audio upsampled from 16kHz to 32kHz'); %sound(z./32766,Fs*2,16) 

subplot(3,1,1); spectrogram(x,window,noverlap,nfft,Fs,'yaxis'); title('audio sampled at 16kHz'); %spectrogram(x,512,Fs,320); 
subplot(3,1,2); spectrogram(y,window,noverlap,nfft,Fs,'yaxis'); title('downsampling to 8kHz'); %spectrogram(y,512,Fs/2,320); 
subplot(3,1,3); spectrogram(z,window,noverlap,nfft,Fs,'yaxis'); title('upsampling to 32kHz'); %spectrogram(z,512,Fs*2,320);
