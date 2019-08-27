% Author: hrosseel
clear;
clc;

%% Define Parameters

fs = 44100;     % Sampling frequency
f1 = 80;        % Starting frequency
f2 = 22050;     % Stop frequency
Tsweep = 4;     % Sweep duration in seconds
Tidle = 2;
wlen = 4000;    % Window size
numSweeps = 4;

%% Generate multiple sweeps

[multiSweep, inverse] = ESS_generator_multi(f1, f2, Tsweep, Tidle, fs, wlen, numSweeps);

%% Play it back and record simultanously

aPR = audioPlayerRecorder('BitDepth', '24-bit integer', 'SampleRate', fs, 'RecorderChannelMapping', [1 2 3 4]);

frameLength = 256;  % Number of samples to be sent to the speakers in 1 loop
numFrames = floor(length(multiSweep) / frameLength);

recordedSweep = zeros(length(multiSweep), 4);
for i = 1 : numFrames
    frame = 1 + (i-1) * frameLength : (i * frameLength);
    audioToPlay = multiSweep(frame);
    [recordedFragment,nUnderruns,nOverruns] = aPR(audioToPlay);
    recordedSweep(frame, :) = recordedFragment;
    
    if nUnderruns > 0
        fprintf('Audio player queue was underrun by %d samples.\n',nUnderruns);
    end
    if nOverruns > 0
        fprintf('Audio recorder queue was overrun by %d samples.\n',nOverruns);
    end
end

release(aPR);
%% 

averageRecordedSweep = mean(recordedSweep.').';

[sweep, ir] = ESS_parser_multi(averageRecordedSweep, inverse, Tidle, Tsweep, fs);
ideal_sweep = ESS_parser_multi(multiSweep, inverse, Tidle, Tsweep, fs);

%% Calculate the RIR.

S = fft([sweep ; zeros(length(inverse), 1)]);      % Zeropad so that N >= L1 + L2
I = fft([inverse ; zeros(length(sweep), 1)]);    % Zeropad so that N >= L1 + L2
IR = I .* S;

figure;
hold on;
showMagdB(S, fs);
showMagdB(I, fs);
showMagdB(IR, fs);
legend('Exponential Sweep Sine', 'Inverse', 'Impulse Response');
hold off;

t1 = ((0:(length(sweep)) - 1) / fs).';
t2 = ((0:(fs*Tsweep) - 1) / fs).';

figure;
subplot(3, 1, 1);
hold on;
plot(t1, ideal_sweep);
plot(t1, sweep);
title('Exponential Sweep Sine');
subplot(3, 1, 2); 
plot(t2, inverse);
title('Inverse');

%% Only keep the causal part of the RIR. This is the part starting when the sweep has ended
ir_causal = ir(Tsweep * fs : end - 1);

subplot(3, 1, 3); 
plot(t1, ir_causal);
title('Impulse Response');