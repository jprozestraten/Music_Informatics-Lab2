%% Load song
file = 'drumloop120_mono.wav';
[song,Fs] = audioread(['labdata/' file]);

%% Create STFT
tWindow = 0.030;
nWindow = floor(tWindow*Fs);
window = hann(nWindow,'periodic');
% window = ones(nWindow,1);

tHop = 0.010;
tOverlap = tWindow-tHop;
nOverlap = floor(tOverlap*Fs);

gamma = 100;

% Plots STFT using the spectogram function
figure(1)
spectrogram(song,window,nOverlap,[],Fs,'yaxis');
ylim([0 5])
title('Plot using spectrogram')
colormap winter

% Plots PSD using imagesc
[S,f,t,P] = spectrogram(song,window,nOverlap,[],Fs,'yaxis');
figure(2)
imagesc(t,f*1e-3,10*log10(abs(P)))
set(gca,'YDir','normal')
colorbar
ylim([0 5])
colormap winter

% Plots STFT using logarithmic compression
G = log(1+gamma*abs(S));
figure(3)
imagesc(t,f*1e-3,G)
set(gca,'YDir','normal')
colorbar
ylim([0 5])
colormap winter

%% Compute discrete temporal derivative
M = 26-4;
M = 2*M+1;
onsetThr = 0.13;

flux = diff(G,1,2);
flux = (flux + abs(flux))/2;
% Plot novelty function without summing
figure(4)
imagesc(t,f*1e-3,flux)
set(gca,'YDir','normal')
colorbar
ylim([0 5])
colormap winter


flux = sum(flux);
mu = movmean(flux,M);
% Plot novelty function and moving average
figure(5)
plot(t(1:end-1),flux)
hold on
plot(t(1:end-1),mu)
hold off

fluxEnhanced = flux - mu;
fluxEnhanced = (fluxEnhanced+abs(fluxEnhanced))/2;
fluxEnhanced = fluxEnhanced/max(fluxEnhanced);

onsets = fluxEnhanced > onsetThr;
% Plot Enhanced and normalized spectral flux and plot onsets
figure(6)
plot(t(1:end-1),fluxEnhanced)
hold on
stem(t(1:end-1),onsets)
yline(onsetThr)
hold off