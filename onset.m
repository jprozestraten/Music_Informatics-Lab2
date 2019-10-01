%% Load song
file = 'drumloop120_mono.wav';
[song,Fs] = audioread(['labdata/' file]);

%% Create STFT
tWindow = 0.030;
nWindow = floor(tWindow*Fs);
window = hann(nWindow,'periodic');

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
caxis([-150 -50])
imagesc(t,f*1e-3,10*log10(abs(P)))
set(gca,'YDir','normal')
colorbar
ylim([0 5])
colormap winter

% Plots STFT using logarithmic compression
