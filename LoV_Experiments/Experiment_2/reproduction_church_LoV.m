clc;
clear;
%% Set up
frameLength = 256;
numLoudspeakers = 24;
loudspeakers = zeros(frameLength, numLoudspeakers);
fs_record = 8000;

numChannels = 1;
numFrames = 100000; % ± 26 minuten

load('air_binaural_aula_carolina_0_1_3_0_3.mat');
fs = air_info.fs;
h_air = h_air.';

% Start - Without the direct wave
win = hann(1000);                              
h = h_air(1350:end, :); 
h(1:500, :) = h(1:500, :) .* win(1:500); 
h(1:500, :) = h(1:500, :) .* win(1:500); 
% End -  Without the direct wave

h = h(1:2.5e5); % Lower the signal length for performance boost

[p, q] = rat(fs_record/fs);
Hre{1} = resample(h, p, q) * 2;

%% Create audio player and recorder object

playRec = audioPlayerRecorder('SampleRate', fs_record, ... 
            'BitDepth', '24-bit integer', ...
            'RecorderChannelMapping', 1:4);

load('recordedAudio_Church_7.mat');
%% Play the audio and at the same time, record the audio

result = zeros(frameLength * numFrames + size(Hre{1}, 1), numLoudspeakers);
micAudio = zeros(frameLength, 1);

numFrames = idx;

for idx = 1 : numFrames - 1
     notUsed = playRec(result(1 + (idx - 1) * frameLength : idx * frameLength, :));
%      micAudio = sum(micAudio.').'; % Take the mean of all microphones     
      micAudio = recordedAudio(1 + (idx - 1) * frameLength : idx * frameLength) * 3;
     audio = [micAudio ; zeros(size(Hre{1}, 1), 1)]; % Zeropadding to N >= L + M
    
    conv_audio = fftfilt(Hre{1}, audio);
    for lsp = 1:numLoudspeakers
          result(idx * frameLength + 1 : (idx + 1) * frameLength + size(Hre{1}, 1), lsp) = result(idx * frameLength + 1 : (idx + 1) * frameLength + size(Hre{1}, 1), lsp) + conv_audio;
    end
end

release(playRec);