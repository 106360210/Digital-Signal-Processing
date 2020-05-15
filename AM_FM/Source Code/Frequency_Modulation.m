clc;
close all;

[input, fs] = audioread('../audio/test_1.wav'); % Read wav file
    
input = ( input(:,1) + input(:,2) ) / 2; % Mix dual channel

num = 5; % Specify number of subplots

fc = 10; % Carrier Frequency


% Spectrum parameters setup
window = hamming(128); 
noverlap = 120; % Number of overlapping samples per segment
nfft = 128; % Length of FFT transformation

% Time of the wav file, from 0 to length of y, 1/fs for intervals 
t = ( 0 : length(input)-1 )' / fs ;
dev = 1000; % Modulation index of FM

% Use cumsum function to make discrete integral come true,
% Principle : y multiply by small interval 1/fs, and accumalate
integratedX = cumsum( input ) / fs;

% Formula of Frequency Modulation
s = cos( 2 * pi * ( fc * t  + dev * integratedX ));

% Plot input signal
subplot(num,1,1);
plot( time, input );xlabel('Time (s)');ylabel('Amplitude');
title('Input');

% Plot Input spectrum 
subplot(num,1,2);spectrogram(input,window,noverlap,nfft,fs,'yaxis');
title('Input Spectrum');

% Plot Carrier 
carrier = cos( 2 * pi * fc * time );
subplot(num,1,3);
plot(time,carrier);xlabel('Time (s)');ylabel('Amplitude');
title('Carrier Signal');

% Plot FM signal 
subplot(num,1,4);
plot(time,s);xlabel('Time (s)');ylabel('Amplitude');
title('FM');

% Plot spectrum of FM signal 
subplot(num,1,5);spectrogram(s,window,noverlap,nfft,fs,'yaxis');
title('FM Spectrum');
