clc;
close all;

%Input Signal
[input, fs]= audioread('../audio/test_1.wav'); % Read wav file
input=(input(:,1)+input(:,2))/2; % Mix dual channel

% Time of the wav file, from 0 to length of y, 1/fs for intervals 
t = (( 0 : numel(input) - 1 ) / fs )'; 
num = 5; % Specify number of subplots

% Plot Input signal
figure;
subplot(num,1,1);
plot(t, input);
title('Input');
xlabel('Time (s)');
ylabel('Amplitude');


% Spectrum parameters setup
window = hamming(128); 
noverlap = 120; % Number of overlapping samples per segment
nfft = 128; % Length of FFT transformation

% Plot spectrum of Input signal
subplot(num,1,2);spectrogram(input,window,noverlap,nfft,fs,'yaxis')
title('Input Spectrum');
xlabel('Time (s)');
ylabel('Frequency (kHz)');


f = 3; % Carrier frequency     

% Get carrier's negative part to positive and normalize            
carrier = 0.5 * sin( 2 * pi * f * t ) + 0.5; 
% Plot carrier
subplot(num,1,3);plot( t , carrier );
title('Carrier Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Formula of Amplitude Modulation
s = input .* carrier;

% Plot AM signal
subplot(num,1,4);plot( t , s );
title('AM');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot spectrum of AM signal
subplot(num,1,5);spectrogram(s,window,noverlap,nfft,fs,'yaxis');
title('AM Spectrum');
xlabel('Time (s)');
ylabel('Frequency (kHz)');
