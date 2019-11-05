clear all;
close all;

print("NOVA SIMULACAO")
% Add path to usable functions
addpath(genpath('/home/wasp/Downloads/DiscreteTFD'));

% Read the audio file
[audioData, sampleRate] = audioread('myson.wav');
sampleRate;

size([audioData; zeros(3 * size(audioData, 1), 1)])

audioData = [audioData; zeros(3 * size(audioData, 1), 1)];
% Setting time parameters
timeSampling = 1 / sampleRate;
timeAxisData = timeSampling * ([1:size(audioData)]-1)';

% Initial plot - time domain with no traitment
figs(1) = figure;
plot(timeAxisData, audioData);
xlabel('time')
timeAxisData;

% Apply first simple FFT
[y, x] = FFTR(audioData, timeSampling);
figs(2) = figure;
plot(x, y);
xlabel('Freq')
ylabel('Amplitude')
size(x); 


% Define low-cut, high-cut filter parameters (adapted to this signal, maybe not suitable for  other signals)
f_Low = 100;
f_High = 2400;
[B_cut, A_cut] = cheby2(2, 5, [f_Low f_High] * (2/sampleRate));
audioDataFilt = filtfilt(B_cut , A_cut, audioData);

% Apply FFT after filtering the signal
[y, x] = FFTR(audioDataFilt, timeSampling);
figs(3) = figure;
plot(x, y);
xlabel('Freq')
ylabel('Amplitude')

% Second Spectograme - After filtering the signal and applying zero
% paddling

%paddledData = [audioData; zeros(3 * size(audioData, 1), 1)];
%figs(4) = figure;
%plot([timeSampling:timeSampling:(13.6850 * 4)] , paddledData)

window = size(audioDataFilt, 1) / 360;
freqAnalysis = [0:0.2:3000];

[tfd, f, t] = spectrogram(audioDataFilt, window, [], freqAnalysis, sampleRate);

%tfd = tfd(end/2 + 1:1165,:);
for i = 1:size(t, 2)
    [fb(i), std(i)] = bari(f, abs(tfd(:, i)));
end
tfd(:, 3);
%abs(tfd(:, 17100))
figs(4) = figure;
spectrogram(audioDataFilt, window, [], freqAnalysis, sampleRate, 'yaxis')
%figs(5) = figure;
%plot3(tfd, f, t);
%figs(5) = figure;
t;

