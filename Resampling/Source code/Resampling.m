clc;clear;close all;

% Spectrum parameters setup
window = hamming(128); 
noverlap = 120; % Number of overlapping samples per segment
nfft = 128; % Length of FFT transformation

% load wav
[x,Fs] = audioread('../Audio/test.wav');
x = (x(:,1)+x(:,2))'/2;
audiowrite('../Audio/test_5x.wav',5 * x , Fs);

% upsampling to 22kHz by zero padding
X_22 = myUpsampling(x,2.2);
audiowrite('../Audio/up-22k.wav',5 * X_22 , Fs * 2.2);

% Apply IIR low-pass filter
[b,a] = butter(10,1/2.2);
X_LOW_22 = 2.2*filter(b,a,X_22);
audiowrite('../Audio/lp-22k.wav', 5 * X_LOW_22 , Fs * 2.2);

% Upsampling to LCM 40kHz by zero padding
X_40 = myUpsampling(x,4);

% Apply IIR low-pass filter
[b,a] = butter(10,1/4);
X_LOW_40 = 4*filter(b,a,X_40);

% decimation to 8kHz
X_DOWN = myDownsampling(X_LOW_40,5);
audiowrite('../Audio/down-8k.wav', 5 * X_DOWN , Fs * 0.8); 

% Plot waveforms and specgrams
subplot(421); plot(x);axis('tight');title('origional 10k');
subplot(422); spectrogram(x,window,noverlap,nfft,Fs,'yaxis');

subplot(423); plot(X_22);axis('tight');title('zero padding 22k');
subplot(424); spectrogram(X_22,window,noverlap,nfft,Fs,'yaxis');

subplot(425); plot(X_LOW_22);axis('tight');title('low-pass filtered 22k');
subplot(426); spectrogram(X_LOW_22,window,noverlap,nfft,Fs,'yaxis');

subplot(427); plot(X_DOWN);axis('tight');title('decimated 8k');
subplot(428); spectrogram(X_DOWN,window,noverlap,nfft,Fs,'yaxis');
sgtitle("Up-sampling & Down-sampling & Spectrum");

function [X_UP] = myUpsampling(x,n)
    X_UP = zeros( length(x) * n , 1);

    for g = 0 : length(x) - 1
        X_UP(round(1+n*g)) = x(g+1);
    end
end
function [X_DOWN] = myDownsampling(x,n)
    f = 1;
    g = 1;
    X_DOWN = zeros( length(x)/n , 1);
    while f <= length(x) / n
        X_DOWN(f) = x(g);
        g = g + n;
        f = f + 1;
    end
end