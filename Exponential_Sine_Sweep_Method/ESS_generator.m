function [sweep, inverse] = ESS_generator(fa, fb, Tsweep, fs, wlen)
%ESS_GENERATOR Generates an exponential sine sweep and its time-inverse used for generating a RIR.
%
%   Input:
%       fa: Starting frequency
%       fb: Stop frequency
%       Tsweep:  Duration of the sweep
%       fs: Sampling frequency in Hz
%       wlen: smoothing hanning window length
%   Output: 
%       sweep(t): generated exponential sine sweep
%       inverse(t): scaled time-inverse exponential sine sweep

R = fb / fa; % Sweep rate
C = (2 * fb * log(R)) / ((fb - fa) * Tsweep); % Normalization constant
t = ((0:(fs*Tsweep) - 1) / fs).';

sweep = (sin(((2 * pi * fa * Tsweep) / log(R)) .* R.^(t / Tsweep)));

win = hann(wlen);
sweep(1:(wlen / 2)) = sweep(1:(wlen / 2)) .* win(1:(wlen / 2));
sweep(end-((wlen / 2)-1) : end) = sweep(end-((wlen / 2)-1) : end) .* win(((wlen / 2)+1):end);

inverse = C * R.^-(t/Tsweep) .* flip(sweep);

end

