% Author: hrosseel
clear; 
clc;

fs = 44100;     % Sampling frequency
f1 = 0.01;      % Start frequency
f2 = 22050;     % Stop frequency
Tsweep = 5;     % Sweep duration in seconds
Tidle = 1;
wlen = 4000;    % Window size
numSweeps = 4;

[multiSweep, inverse] = ESS_generator_multi(f1, f2, Tsweep, Tidle, fs, wlen, numSweeps);
[sweep, ir] = ESS_parser_multi(multiSweep, inverse, Tidle, Tsweep, fs);

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
plot(t1, sweep);
title('\textbf{Excitation signal $$s(t)$$}', 'Interpreter', 'Latex');
xlabel('Time (s)')
ylabel('Magnitude')

subplot(3, 1, 2); 
plot(t2, inverse);
title('\textbf{Inverse filter $$v(t)$$}', 'Interpreter', 'Latex');
xlabel('Time (s)')
ylabel('Magnitude')

% Only keep the causal part of the RIR. This is the part starting when the sweep has ended
ir_causal = ir(Tsweep * fs : end - 1);
ir_causal = ir_causal / max(abs(ir_causal)); % Scale the IR

subplot(3, 1, 3); 
plot(t1, ir_causal);
title('\textbf{Room Impulse Response $$\hat{h}(t)$$}', 'Interpreter', 'Latex');
xlabel('Time (s)')
ylabel('Magnitude')
