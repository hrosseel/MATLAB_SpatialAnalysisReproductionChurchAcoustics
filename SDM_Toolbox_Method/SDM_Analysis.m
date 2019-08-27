% Author: hrosseel
clear;
clc;

%% Loading the measured impulse response

% INFO: Microphone orientation = [front, back, left, right, top, down]
load('not_able_to_share_IRs.mat'); % RIR with a RT = 0.12 sec

ir_l = IRcut(:,:,1);
ir_r = IRcut(:,:,2);

%% SDM Toolbox analysis

fs = 192000;    % Sampling frequency (Hz)

SDMstruct = createSDMStruct('DefaultArray', 'GRASVI50', 'fs', fs, 'showArray', true);

% Solve the DOA of each time window assuming wide band reflections, 
% white noise in the sensors and far-field (plane wave propagation model 
% inside the array)
DOA{1} = SDMPar(ir_l, SDMstruct);
DOA{2} = SDMPar(ir_r, SDMstruct);

% % Here we are using the top-most microphone as the estimate for the
% % pressure in the center of the array
% P{1} = ir_l(:,5);
% P{2} = ir_r(:,5);

% Take the average of all the microphone to generate a virtual
% omnidirectional microphone in the middle of the array.
P{1} = mean(ir_l.').';
P{2} = mean(ir_r.').';

%% SDM Toolbox visualization

visual = createVisualizationStruct('DefaultRoom','Medium', 'name', ...
     'Recording GRAS 50 VI','fs',fs);

set(0,'DefaultTextInterpreter','latex');

parameterVisualization(P, visual);
timeFrequencyVisualization(P, visual);
visual.plane = 'lateral';
spatioTemporalVisualization(P, DOA, visual);
visual.plane = 'transverse';
spatioTemporalVisualization(P, DOA, visual);
visual.plane = 'median';
spatioTemporalVisualization(P, DOA, visual);
