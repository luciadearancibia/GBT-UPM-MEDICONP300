function [testFeaturesPCA] = extractFeatures_test(sbj,sessions,coefforth,I,J)

addpath(genpath('data'))

av_testData = zeros(8,350);
for ses=sessions
    s=num2str(ses);
    % extract test data and perform synchronous average
    av_testData_s = synchrAv_session(num2str(sbj),s,'test');
    av_testData = cat(3, av_testData, av_testData_s);
end 
av_testData(:,:,1)=[];
% select time window
av_testData = av_testData(:,50:299,:);

Nevents_test = size(av_testData,3);

% %% Apply whitening filter to data
% filt_testData = zeros(size(av_testData));
% for i = 1:Nevents_test
%     filt_testData(:,:,i) = wiener2(av_testData(:,:,i),[8 10]);
% end

%% Average downsample and concatenate channels
ds = 10;
ds_testData = av_ds(av_testData,ds);

%% CWT features
scales = 8:2:64; 
fs = 250;
nMax = 1024;

% take only the 128 samples corresponding to the 200ms-608ms
p300_EEGs = av_testData(:,50:177,:);  % [8 x 128 x nEvents]
fprintf('.........CALCULATING CWT COEFFICIENTS.........')
coeffs = cwt_eeg(p300_EEGs,scales,fs); %[scales x samples x channels x events]
cwt_testFeatures = relevantCWT(coeffs,Nevents_test,I,J);
fprintf('DONE\n')

%% Combine time and wavelet features
testFeatures = cat(2,ds_testData,cwt_testFeatures);

%% SAVE
% if sbj<10
%     filename = ['features/withinSBJ_phII/test_SBJ0',num2str(sbj)];
% elseif sbj>=10
%     filename = ['features/withinSBJ_phII/test_SBJ',num2str(sbj)];
% end
% save(filename,'testFeatures','trainTargets','testFeatures')

%% PCA
r = 120; % number of principal components to keep
testscores = zscore(testFeatures)*coefforth;
testFeaturesPCA = testscores(:,1:r);

end

