function [targets] = labels2targets(labels,Nevents)
% Transforms labels (block's target object) to targets (1 or 0 depending on
% wether the event contains a P300 signal
%   labels : values from 1-8 with each block's target object

targets = zeros(8,Nevents/8);
for bl = 1:length(labels)
    targets(labels(bl),bl) = 1;
end
targets = reshape(targets,[],1);
end

