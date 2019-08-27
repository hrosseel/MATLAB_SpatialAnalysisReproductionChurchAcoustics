% Author: hrosseel
clc;
clear;
%% Set up
frameLength = 256;
numLoudspeakers = 24;
loudspeakers = zeros(frameLength, numLoudspeakers);
fs_record = 8000;

numChannels = 2;
numFrames = 100000; % � 26 minuten

load('../RIR_24channel_NoDirectWave.mat');

[p, q] = rat(fs_record/fs);

Hre{1} = resample(H{1}, p, q);
Hre{2} = resample(H{2}, p, q);

Hre{1} = Hre{1}(1:(fs_record/2), :) * 150;
Hre{2} = Hre{1}(1:(fs_record/2), :) * 150;


%% Create audio player and recorder object

playRec = audioPlayerRecorder('SampleRate', fs_record, ... 
            'BitDepth', '24-bit integer', ...
            'RecorderChannelMapping', 1:4);
        
%% Play the audio and at the same time, record the audio

result = zeros(frameLength * numFrames + size(Hre{1}, 1), numLoudspeakers);
recordedAudio = zeros(frameLength * numFrames, 1);
micAudio = zeros(frameLength, 1);

for idx = 1 : numFrames - 1
     micAudio = playRec(result(1 + (idx - 1) * frameLength : idx * frameLength, :));
     micAudio = sum(micAudio.').'; % Take the mean of all microphones     
     recordedAudio(idx * frameLength + 1 : (idx + 1) * frameLength) = micAudio;
     
     audio = [micAudio ; zeros(size(Hre{1}, 1), 1)]; % Zeropadding to N >= L + M
    
    for channel = 1:numChannels
        for lsp = 1:numLoudspeakers
              result(idx * frameLength + 1 : (idx + 1) * frameLength + size(Hre{1}, 1), lsp) = result(idx * frameLength + 1 : (idx + 1) * frameLength + size(Hre{1}, 1), lsp) + fftfilt(Hre{channel}(:, lsp), audio);
        end
    end
end
release(playRec);
release(echoCanceller);