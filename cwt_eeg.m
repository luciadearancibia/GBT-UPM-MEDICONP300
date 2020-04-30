function [coefs] = cwt_eeg(eegs,scales,fs)
% Returns Mexican Hat wavelet coefficients of the given EEGs using the
% specified scales
% eegs : [channels x time x events] matrix

% coefs : [scales x samples x channels x events]

nScales = length(scales);
nSamples = size(eegs,2);
coefs = zeros(nScales,nSamples,size(eegs,1));

% for event = 1:size(all_eegs,3)
for event = 1:size(eegs,3)
    %fprintf('Event: %g\n',event);
    coefs_eeg = zeros(nScales,nSamples);
    for channel = 1:8
        % cwt of each channel
        p300 = eegs(channel,:,event);
        p300_coefs = cwt(p300,scales,'mexh',fs);
        % cwtstruct = cwtft(eeg,'wavelet','mexh');
        % cwtstruct.cfs;
        coefs_eeg = cat(3,coefs_eeg,p300_coefs);
        
    end
    coefs_eeg(:,:,1) = [];
    coefs = cat(4,coefs,coefs_eeg);
end

coefs(:,:,:,1) = [];

end

