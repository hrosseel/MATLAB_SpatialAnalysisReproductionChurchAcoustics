% Author: hrosseel
clear;
clc;

%% Initialize all variables

fs = 8000;
gainFactor = 1;
frameLength = 256;

playRec = audioPlayerRecorder('SampleRate', fs, ... 
            'BitDepth', '24-bit integer', ...
            'RecorderChannelMapping', 1:4);

%% Load the first SDM Experiment
load('experiment1_SDM.mat');

%% Load the second Church Experiment
load('experiment2_church.mat');

%% Start the playback
for idx = 1 : (length(res) / frameLength)
    playRec(res(1 + (idx - 1) * frameLength : idx * frameLength, :) * gainFactor);
end