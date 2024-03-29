clear all;
close all;

% Add path to usable functions
addpath(genpath('/home/wasp/Downloads/DiscreteTFD'));

% Read the audio file
[audioData, sampleRate] = audioread('enavant.wav');

% Setting time para
timeSampling = 1 / sampleRate;
timeAxisData = timeSampling * ([1:size(audioData)]-1)';

% Plot in time domain
figs(1) = figure;
plot(timeAxisData, audioData);
xlabel('time');

% Apply first simple FFT
[ampFreq, freq] = FFTR(audioData, timeSampling);
figs(2) = figure;
plot(freq, ampFreq);
xlabel('Freq');
ylabel('Amplitude');


mfccColect = lagis_mfcc (audioData, 0.032 * sampleRate, 0.016 * sampleRate, 2000, sampleRate, [], 10);
mfccColect(:, 10)
size(mfccColect)

