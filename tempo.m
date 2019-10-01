%% Load song
file = 'cretansyrtos.wav';
[song,Fs] = audioread(['labdata/' file]);
song = mean(song,2);

%% Set constants
gamma = 100;

tWindowStft = 0.030;
tHopStft = 0.010;

M = 26-4;

tWindowTempo = 8;
tHopTempo = 0.5;

%% Create STFT
nWindowStft = floor(tWindowStft*Fs);
windowStft = hann(nWindowStft,'periodic');

tOverlapStft = tWindowStft-tHopStft;
nOverlapStft = floor(tOverlapStft*Fs);

[S,f,t] = spectrogram(song,windowStft,nOverlapStft,[],Fs,'yaxis');

%% Get novelty function
novelty = spectral(S,gamma,M);

%% Get tempogram
FsTempo = 1/mean(diff(t(1:end-1)));

nWindowTempo = floor(tWindowTempo*FsTempo);
windowTempo = ones(nWindowTempo,1);

tOverlapTempo = tWindowTempo-tHopTempo;
nOverlapTempo = floor(tOverlapTempo*FsTempo);

[tempogram,fTempo,tTempo,pTempo] = spectrogram(novelty,windowTempo,nOverlapTempo,[],FsTempo,'yaxis');
bTempo = 60*fTempo;
figure(1)
imagesc(tTempo,bTempo,10*log10(pTempo))
hold on
set(gca,'YDir','normal')
caxis([0 max(10*log10(pTempo),[],'all')])
ylim([0 600])
colorbar
colormap winter

[~,iMax] = max(10*log10(pTempo(bTempo>=100 & bTempo<200,:)));
ii = find(bTempo>=100 & bTempo<200,1);
plot(tTempo,bTempo(iMax+ii-1),'r','LineWidth',3)
hold off