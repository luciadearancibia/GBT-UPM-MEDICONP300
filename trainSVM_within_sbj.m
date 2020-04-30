function [] = trainSVM_within_sbj(sbj)
% Trains a Linear Support Vector Machine model using the data of a single
% subject and the session specified below

% Sessions to use for training
sessions = 1:7;

%% Extract TRAIN data from all sessions:
% clearvars -except sbj predictedLabels_phII count c

% extract time + CWT features and perform PCA
[trainTargets,trainFeaturesPCA,coefforth,I,J] = ...
    extractFeatures_train(sbj,sessions);

%% LOAD DATA (from already saved features)
% if sbj<10
%     filename = ['features/withinSBJ_phII/train_SBJ0',num2str(sbj)];
% elseif sbj>=10
%     filename = ['features/withinSBJ_phII/train_SBJ',num2str(sbj)];
% end
% load(filename)

% trainFeatures = [trainFeatures; testFeatures];
% trainTargets = [trainTargets; testTargets];
% trainLabels = [trainLabels; testLabels];
% clear testFeatures testTargets testLabels


%% Oversampling
[ovs_trainData,ovs_trainTargets] = oversampling(trainFeaturesPCA,...
    trainTargets, 980, 140);
fprintf('Training data after oversampling: \n')
summary(categorical(ovs_trainTargets))

%% Train
fprintf('...............TRAINING..............\n')
tic
trained_model = fitcsvm(ovs_trainData,ovs_trainTargets);
%     'KernelFunction','rbf','OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
%     'expected-improvement-plus','ShowPlots',false,'Verbose',0));
elapsedTime = toc;
fprintf('Time to train linear kernel: %d\n', elapsedTime);

%% Save model
if sbj<10
    foldername = ['trainedModels/SBJ0',num2str(sbj)];
elseif sbj>=10
    foldername = ['trainedModels/SBJ',num2str(sbj)];
end

if ~exist(foldername, 'dir')
   mkdir(foldername)
end

save([foldername,'/modelSVM'],'trained_model')

if ~isfile([foldername,'/ft_extraction_params.mat'])
   save([foldername,'/ft_extraction_params'],'I','J','coefforth')
   fprintf('saved parameters for feature extraction')
end
end