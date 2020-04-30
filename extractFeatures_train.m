function [trainTargets,trainFeaturesPCA,coefforth,I,J] = extractFeatures_train(sbj,sessions)

addpath(genpath('data'))

av_trainData = zeros(8,350);
trainLabels = 0;
for ses=sessions
    s=num2str(ses);
    [av_trainData_s,trainLabels_s] = synchrAv_session(num2str(sbj),s,'train');
    av_trainData = cat(3, av_trainData, av_trainData_s);
    trainLabels = cat(1,trainLabels,trainLabels_s);
end 
av_trainData(:,:,1)=[];
trainLabels(1)=[];

%% Add labeled test data
testSessions = 1:3;
load('trueLabelsphaseI.mat')
for ses = testSessions
    s = num2str(ses);
    av_testData_s = synchrAv_session(num2str(sbj),s,'test');
    av_trainData = cat(3, av_trainData, av_testData_s);
    trainLabels = [trainLabels; truelabelsphaseI(3*(sbj-1)+ses,:)'];
end 
av_trainData = av_trainData(:,50:299,:);
clear av_testData_s av_testData 

% Extract targets:
Nevents_train = size(av_trainData,3);
fprintf('Nevents: %d\n',Nevents_train)
trainTargets = labels2targets(trainLabels,size(av_trainData,3));

%% Apply whitening filter to data
% filt_trainData = zeros(size(av_trainData));
% for i = 1:Nevents_train
%     filt_trainData(:,:,i) = wiener2(av_trainData(:,:,i),[8 10]);
% end

%% Average downsample and concatenate channels
ds = 10;
ds_trainData = av_ds(av_trainData,ds);

%% CWT features
scales = 8:2:64; % scales corresponding to delta (0.5-4Hz) and theta (4-8Hz) bands
fs = 250;        % sampling frequency
nMax = 1024;

% take only the 128 samples corresponding to the 200ms-608ms
p300_EEGs = av_trainData(:,50:177,:);  % [8 x 128 x nEvents]
fprintf('.........CALCULATING CWT COEFFICIENTS.........')
coeffs = cwt_eeg(p300_EEGs,scales,fs); %[scales x samples x channels x events]
% perform t-Student to calculate most relevant coefficients
[I,J] = tStudentofCWT(coeffs,trainTargets,nMax);
cwt_trainFeatures = relevantCWT(coeffs,Nevents_train,I,J);
fprintf('DONE\n')

%% Combine time and wavelet features
trainFeatures = cat(2,ds_trainData,cwt_trainFeatures);

%% PCA
r = 120; % number of principal components to keep
[wcoeff,score,latent,~,explained] = pca(trainFeatures,...
    'VariableWeights','variance');
% figure()
% pareto(explained)
% xlabel('Principal Component')
% ylabel('Variance Explained (%)')
% fprintf('Sum of first 30 PCs variances: %d',sum(explained(1:30)))
trainFeaturesPCA = score(:,1:r);
coefforth = inv(diag(std(trainFeatures)))*wcoeff;

%% Oversampling
% [ovs_trainData,ovs_trainTargets] = oversampling(trainFeaturesPCA,...
%     trainTargets, 980, 140);
% fprintf('Training data after oversampling: \n')
% summary(categorical(ovs_trainTargets))

end

