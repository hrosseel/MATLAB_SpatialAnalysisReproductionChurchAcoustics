% Author: hrosseel
function showMagdB(X,fs)
%SHOWMAGDB Plots the magnitude response of an input frequency domain signal
%   Input: 
%     X:  Input frequency domain signal
%     fs: Sampling frequency in Hz

L = length(X);
freq = fs * (0:(L/2) - 1) / L;
ref = max(abs(X));
magnitude = 20 * log10(abs(X) / ref);

plot(freq, magnitude(1:length(freq)));

xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
end