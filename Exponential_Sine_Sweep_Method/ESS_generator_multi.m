function [result, inverse] = ESS_generator_multi(f1, f2, Tsweep, Tidle, fs, wlen, numSweeps, draw)
%ESS_GENERATOR Generates multiple exponential sine sweeps and its time-inverse used for generating a RIR.
%
%   Input:
%       1)  f1: Starting frequency
%       2)  f2: Stop frequency
%       3)  Tsweep:  Duration of the sweep (seconds)
%       4)  Tidle:   Time between sweeps (seconds)
%       5)  fs: Sampling frequency in Hz
%       6)  wlen: smoothing window length
%       7)  numSweeps: number of sweeps
%       8)  draw: specify wether to plot the resulting sweeps (optional)
%   Output: 
%       1)  sweep(t): generated exponential sine sweep
%       2)  inverse(t): scaled time-inverse exponential sine sweep
        
    [sweep, inverse] = ESS_generator(f1, f2, Tsweep, fs, wlen);
    
    t_sweep = Tsweep * fs;
    t_idle = Tidle * fs;
    t_period = t_sweep + t_idle;
    
    result = zeros(t_period * numSweeps + t_idle, 1); 

    for i = 1 : numSweeps
        delay = t_idle + ((i - 1) * t_period) : (i * t_period) - 1;
        result(delay) = sweep;
    end
    
    if (nargin >= 8 && draw) 
        plot(((0:(t_period * numSweeps + t_idle) - 1) / fs).', result);
    end
end

