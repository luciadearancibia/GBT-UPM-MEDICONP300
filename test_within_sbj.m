function predictLabels_s = test_within_sbj(sbj, model)
% Predicts the labels of the TEST (online) phase of a single subject
% model : model to use for prediction ('LDA' for Linear Discriminant
% Analysis or 'SVM' for linear Support Vector Machine)


% clear all
% Session to predict
sessions = 1:7;

% load model

if sbj<10
    foldername = ['trainedModels/SBJ0',num2str(sbj)];
elseif sbj>=10
    foldername = ['trainedModels/SBJ',num2str(sbj)];
end
% change to modelSVM for models trained with SVM
if (model == 'LDA')
    modelname = [foldername,'/modelLDA.mat'];
elseif (model == 'SVM')
    modelname = [foldername,'/modelSVM.mat'];
end
load(modelname)
load([foldername '/ft_extraction_params.mat'])
clearvars modelname foldername

%% Extract TEST data from all sessions:
testFeaturesPCA = extractFeatures_test(sbj,sessions,coefforth,I,J);

%% Test
fprintf('...............PREDICTING...............')
tic
% predict targets
[predictTargets, pred_score] = predict(trained_model,testFeaturesPCA);
fprintf('\n DONE')
elapsedTime = toc;

%% Predict target object (labels)
predictLabels = zeros(1,50*4);
fixed = 0;
totalBl = 50*4;

for bl=[1:8:totalBl*8;1:totalBl]
    block=bl(1);
    [~,L] = max(pred_score(block:block+7,2));
    ix = block+L-1;
    if(predictTargets(ix)==1)
        predictLabels(bl(2)) = L;
    else
        fixed=fixed+1;
        predictLabels(bl(2)) = L;
        fprintf('Prediction fixed for block %g\n',bl(2))
    end
end
predictLabels_s = reshape(predictLabels,50,4)';
% save([foldername 'predictedLabels'],predictLabels_s)

end

