function novelty = spectral(S,gamma,M)
flux = log(1+gamma*abs(S));
flux = (flux + abs(flux))/2;
flux = sum(flux);

M = 2*M+1;
mu = movmean(flux,M);
novelty = flux - mu;
end
