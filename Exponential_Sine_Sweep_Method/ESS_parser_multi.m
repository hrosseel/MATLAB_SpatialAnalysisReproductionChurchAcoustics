function [sweep, ir] = ESS_parser_multi(multiSweep, inverse, Tidle, Tsweep, fs)
%ESS_PARSER_MULTI Processes multiple exponential sine sweeps and outputs
%the resulting Impulse Response.
%
%   Input:
%       multiSweep(t): multiple exponential sine sweeps
%       inverse(t): scaled time-inverse exponential sine sweep
%       Tsweep:  Duration of the sweep (seconds)
%       Tidle:   Time between sweeps (seconds)
%       fs: Sampling frequency in Hz

%   Output: 
%       sweep(t): the average exponential sine sweep response
%       ir(t): resulting impulse response

t_sweep = Tsweep * fs;
t_idle = Tidle * fs;
t_period = t_sweep + t_idle;

numSweeps = (length(multiSweep) - t_idle) / t_period;
sweep = zeros(t_sweep + t_idle, 1);
for i = 1 : numSweeps
    delay = t_idle + ((i - 1) * t_period) : (i * t_period) + t_idle - 1;
    sweep = sweep + multiSweep(delay);
end

sweep = sweep ./ numSweeps;                     % Take the average value

S = fft([sweep ; zeros(length(inverse), 1)]);      % Zeropad so that N >= L1 + L2
I = fft([inverse ; zeros(length(sweep), 1)]);    % Zeropad so that N >= L1 + L2
IR = I .* S;
ir = ifft(IR);

end

