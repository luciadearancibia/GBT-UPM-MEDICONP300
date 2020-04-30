function [av_Data,varargout] = synchrAv_session(sbj,s,part)
% Averages events coresponding to the same object in the same block
%   sbj : subject (str)
%   s : session (str)
%   part : 'train' (calibration, labeled events) or 
% 'test' (online, unlabeled events)

%   av_trainData : matrix containing averaged EEG events of objects 
% ordered from 1-8 inside each block [channels x samples x Nblocks*8]:
% [block1 (objects 1-8),  block2(objects 1-8), ....., Nblock(objects 1-8)]

if (length(sbj)==1)
    sbj = ['SBJ' '0' sbj];
elseif (length(sbj)==2)
    sbj = ['SBJ' sbj];
else
    error('wrong subject number')
end
if length(sbj)~=5
    error('wrong subject number')
end

s = ['/S0' s];
if length(s)~=4
    error('wrong session number')
end

%path = ['data/' sbj s];
%cd (path)

if strcmpi(part, 'train')
    %cd Train
    rpb = 10;
    Nblocks = 20;
    events = load(['data/' sbj s '/Train/trainEvents.txt']);
    all_data = load(['data/' sbj s '/Train/trainData.mat']);
    all_data = all_data.trainData;
    varargout{1} = load(['data/' sbj s '/Train/trainLabels.txt']);
    % varargout = varargout.trainLabels;
elseif strcmpi(part, 'test')
    %cd Test
    rpb = str2double(fileread(['data/' sbj s '/Test/runs_per_block.txt']));
    Nblocks = 50;
    events = load(['data/' sbj s '/Test/testEvents.txt']);
    all_data = load(['data/' sbj s '/Test/testData.mat']);
    all_data = all_data.testData;
    varargout{1} = events;
else
    error('Wrong part: choose train or test')
end
Nsamples = size(all_data,2);
epb = rpb*8;
av_Data = zeros(8,350);
for bl= [1:Nblocks; 1:epb:epb*Nblocks]
    eventsBlock = events(bl(2):bl(2)+epb-1);   
    DataBlock = all_data(:,:,bl(2):bl(2)+epb-1);
    av_DataBlock = zeros(8,Nsamples,8);
    for obj=1:8
        av_DataBlock(:,:,obj) = mean(DataBlock(:,:,...
            eventsBlock==obj),3);
    end
    av_Data = cat(3,av_Data,av_DataBlock);
end
av_Data(:,:,1)=[];
%cd methods_P300
end

