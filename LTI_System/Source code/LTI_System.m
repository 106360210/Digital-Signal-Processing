clc;clear;close all;

% Input signal & process of stereo
[x,fs] = audioread('../Audio/test.wav');
x = (x(:,1)+x(:,2))'/2;

% Specify subplot size for Frequency Response
sub_row = 5;
sub_col = 2;

% Parameters for frequency response
denominator = 1;
w = 0:pi/1023:pi;

% Ideal Delay 
nd = 3500;
h_ideal = zeros(1,5000); h_ideal(nd) = 1;
H_1 = my_freqz(h_ideal,denominator,w);

figure(1);
subplot(sub_row,sub_col,1)
plot(w/pi,20*log10(abs(H_1))); % mtlb_grid
xlabel('\omega /\pi'); ylabel('Amplitude (dB)'); title('Ideal Delay')

subplot(sub_row,sub_col,2)
plot(w/pi,angle(H_1));% mtlb_grid
xlabel('\omega /\pi'); ylabel('Phase in radians'); title('Ideal Delay')

% Moving Average
h_mov = zeros(1,length(x));
M1 = -20;
M2 = 10;
h_mov((length(x)/2)+M1:(length(x)/2)+M2) = 1/(abs(M2-M1)+1);

H_2 = my_freqz(h_mov,denominator,w);



subplot(sub_row,sub_col,3)
plot(w/pi,20*log10(abs(H_2))); % mtlb_grid
xlabel('\omega /\pi'); ylabel('Amplitude (dB)'); title('Moving Average')

subplot(sub_row,sub_col,4)
plot(w/pi,angle(H_2));% mtlb_grid
xlabel('\omega /\pi'); ylabel('Phase in radians'); title('Moving Average')

% Accmulator
%h_acc = ones(1,length(x));
h_acc = ones(1,30);
H_3 = my_freqz(h_acc,denominator,w);

subplot(sub_row,sub_col,5)
plot(w/pi,20*log10(abs(H_3))); % mtlb_grid
xlabel('\omega /\pi'); ylabel('Amplitude (dB)'); title('Accumulator')

subplot(sub_row,sub_col,6)
plot(w/pi,angle(H_3));% mtlb_grid
xlabel('\omega /\pi'); ylabel('Phase in radians'); title('Accumulator')


% Forward Difference
h_forw = [1 -1 0];
H_4 = my_freqz(h_forw,denominator,w);

subplot(sub_row,sub_col,7)
plot(w/pi,20*log10(abs(H_4))); % mtlb_grid
xlabel('\omega /\pi'); ylabel('Amplitude (dB)'); title('Forward Difference')


subplot(sub_row,sub_col,8)
plot(w/pi,angle(H_4));% mtlb_grid
xlabel('\omega /\pi'); ylabel('Phase in radians'); title('Forward Difference')

% Backward Difference
h_back = [0 1 -1];
H_5 = my_freqz(h_back,denominator,w);

subplot(sub_row,sub_col,9)
plot(w/pi,20*log10(abs(H_5))); % mtlb_grid
xlabel('\omega /\pi'); ylabel('Amplitude (dB)'); title('Backward Difference')

subplot(sub_row,sub_col,10)
plot(w/pi,angle(H_5));% mtlb_grid
xlabel('\omega /\pi'); ylabel('Phase in radians'); title('Backward Difference')

sgtitle('Frequency Response');

% Plot for In/Output figure

figure(2);
subplot(611);
plot(x);xlabel('sample points'); ylabel('Amplitude'); title('Input Signal');
Y_1 = my_conv(x,h_ideal);subplot(612);
plot(Y_1);xlabel('sample points'); ylabel('Amplitude'); title('Ideal Delay'); audiowrite('../Audio/ideal.wav',Y_1,fs);
Y_2 = my_conv(x,h_mov);subplot(613);
plot(Y_2);xlabel('sample points'); ylabel('Amplitude'); title('Moving Average'); audiowrite('../Audio/moving.wav',Y_2,fs);
Y_3 = my_conv(x,h_acc);subplot(614);
plot(Y_3);xlabel('sample points'); ylabel('Amplitude'); title('Accumulator'); audiowrite('../Audio/accumulator.wav',Y_3,fs);
Y_4 = my_conv(x,h_forw);subplot(615);
plot(Y_4);xlabel('sample points'); ylabel('Amplitude'); title('Forward Difference'); audiowrite('../Audio/forward.wav',Y_4,fs);
Y_5 = my_conv(x,h_back);subplot(616);
plot(Y_5);xlabel('sample points');ylabel('Amplitude'); title('Backward Difference'); audiowrite('../Audio/backward.wav',Y_5,fs);
sgtitle('In/Output figure');

% Spectrum parameters setup
window = hamming(128); 
noverlap = 120; % Number of overlapping samples per segment
nfft = 128; % Length of FFT transformation

% Spectrum for In/Output Signal

figure(3);
subplot(611);
spectrogram(x,window,noverlap,nfft,fs,'yaxis'); title('Input Signal');
subplot(612);
spectrogram(Y_1,window,noverlap,nfft,fs,'yaxis'); title('Ideal Delay');
subplot(613);
spectrogram(Y_2,window,noverlap,nfft,fs,'yaxis'); title('Moving Average');
subplot(614);
spectrogram(Y_3,window,noverlap,nfft,fs,'yaxis'); title('Accumulator');
subplot(615);
spectrogram(Y_4,window,noverlap,nfft,fs,'yaxis'); title('Forward Difference');
subplot(616);
spectrogram(Y_5,window,noverlap,nfft,fs,'yaxis'); title('Backward Difference');
sgtitle('Spectrum for In/Output Signal');

% Figure for Impulse response

figure(4);
subplot(511);
stem(h_ideal);xlabel('n'); ylabel('h[n]'); title('Ideal Delay');
subplot(512);
stem(h_mov);xlabel('n'); ylabel('h[n]'); title('Moving Average');
subplot(513);
stem(h_acc);xlabel('n'); ylabel('h[n]'); title('Accumulator');
subplot(514);
stem(h_forw);xlabel('n'); ylabel('h[n]'); title('Forward Difference');
subplot(515);
stem(h_back);xlabel('n'); ylabel('h[n]'); title('Backward Difference');
sgtitle('Impulse response');

function [Y] = my_conv(x,h)
    m=numel(x);
    n=numel(h);
    X=[x,zeros(1,n)];
    H=[h,zeros(1,m)];

    for i=1:n+m-1
        Y(i)=0;
        for j=1:m
            if(i-j+1>0)
                Y(i)=Y(i)+X(j)*H(i-j+1);
            else
            end
        end
    end
end

function [hh,ff] = my_freqz(b,a,n,dum,Fs)
minArgs = 1;
maxArgs = 5;
narginchk(minArgs, maxArgs);
if nargin == 1
    a = 1;  n = 512;  whole = 'no';  samprateflag = 'no';
elseif nargin == 2
    n = 512;  whole = 'no';  samprateflag = 'no';
elseif nargin == 3
    whole = 'no';  samprateflag = 'no';
elseif nargin == 4
    if ischar(dum)
        whole = 'yes';  samprateflag = 'no';
    else
        whole = 'no';  samprateflag = 'yes';  Fs = dum;
    end
elseif nargin == 5
    whole = 'yes';  samprateflag = 'yes';
end
a = a(:).';
b = b(:).';
na = max(size(a));
nb = max(size(b));
nn = max(size(n));
if (nn == 1)
    if strcmp(whole,'yes')
        s = 1;
    else
        s = 2;
    end
    w = (0:n-1)'*2*pi/n/s;
    if s*n < na || s*n < nb
        nfft = lcm(n,max(na,nb));
        h=(fft([b zeros(1,s*nfft-nb)])./fft([a zeros(1,s*nfft-na)])).';
        h = h(1+(0:n-1)*nfft/n);
    else
        h = (fft([b zeros(1,s*n-nb)]) ./ fft([a zeros(1,s*n-na)])).';
        h = h(1:n);
    end
else
%	Frequency vector specified.  Use Horner's method of polynomial
%	evaluation at the frequency points and divide the numerator
%	by the denominator.
    a = [a zeros(1,nb-na)];  % Make sure a and b have the same length
    b = [b zeros(1,na-nb)];
    if strcmp(samprateflag,'no')
        w = n;
        s = exp(sqrt(-1)*w);
    else
        w = 2*pi*n/Fs;
        s = exp(sqrt(-1)*w);
    end
    h = polyval(b,s) ./ polyval(a,s);
end

if strcmp(samprateflag,'yes')
    f = w*Fs/2/pi;
else
    f = w;
end

if nargout == 0   % default plots - magnitude and phase
    if 0   % do the same thing for all filters
%    if (length(a) == 1) & ( all(abs(b(nb:-1:1)-b)<sqrt(eps)) ...
%         | all(abs(b(nb:-1:1)+b)<sqrt(eps)) ),
%         linear phase FIR case - just plot magnitude
        if strcmp(samprateflag,'no')
            plot(f/pi,abs(h));
            xlabel('Normalized frequency (Nyquist == 1)')
        else
            plot(f,abs(h));
            xlabel('Frequency (Hertz)')
        end
        set(gca,'xgrid','on','ygrid','on');
        ylabel('Magnitude Response')
    else
    % plot magnitude and phase
        newplot;
        if strcmp(samprateflag,'no')
            subplot(211)
            plot(f/pi,20*log10(abs(h)));
            set(gca,'xgrid','on','ygrid','on');
            xlabel('Normalized frequency (Nyquist == 1)')
            ylabel('Magnitude Response (dB)')
            ax = gca;
            subplot(212)
            plot(f/pi,unwrap(angle(h))*180/pi);
            set(gca,'xgrid','on','ygrid','on');
            xlabel('Normalized frequency (Nyquist == 1)')
            ylabel('Phase (degrees)')
            subplot(111)
            axes(ax)
        else
            subplot(211)
            plot(f,20*log10(abs(h)));
            set(gca,'xgrid','on','ygrid','on');
            xlabel('Frequency (Hertz)')
            ylabel('Magnitude Response (dB)')
            ax = gca;
            subplot(212)
            plot(f,unwrap(angle(h))*180/pi);
            set(gca,'xgrid','on','ygrid','on');
            xlabel('Frequency (Hertz)')
            ylabel('Phase (degrees)')
            subplot(111)
            axes(ax)
        end
    end
elseif nargout == 1
    hh = h;
else
    hh = h;
    ff = f;
end
end