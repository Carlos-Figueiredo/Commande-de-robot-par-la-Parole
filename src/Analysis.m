clear all;
close all;
timeSampling = 1 / sampleRate;
timeAxisData = timeSampling * ([1:size(audioData)]-1)';
print("New Simulation!")

% Add path to usable functions
addpath(genpath('/home/wasp/Downloads/DiscreteTFD'));

% Read the audio file
[audioData, sampleRate] = audioread('test3/enavant.wav');

% Setting time para
timeSampling = 1 / sampleRate;
timeAxisData = timeSampling * ([1:size(audioData)]-1)';

figs(1) = figure;
plot(timeAxisData, audioData);
xlabel('time');