function [ds_signal] = av_ds(signal,ds)
% AVERAGE DOWNSAMPLE
%   signal : [channels x time points x events]
%   ds : downsampling rate

%   ds_signal : [events x (time points/ds * channels)]
channels = size(signal,1);
points = size(signal,2);
nevents = size(signal,3);

ds_signal = permute(mean(reshape(permute(signal,[2 1 3]),ds,points/ds*channels,nevents),1),[3,2,1]);
end

