clear all
counts = 15*4;
c = 1;
predictedLabels_phII = zeros(counts,50);
% train with linear discriminant analysis
model = 'LDA';  % 'SVM' to use support vector machine


for sbj = 1:15
    fprintf(['SUBJECT ',num2str(sbj),'\n'])

    % TRAIN
    trainDA_within_sbj(sbj);
    % trainSVM_within_sbj(sbj);
    
    % TEST
    predictLabels_s = test_within_sbj(sbj, model);
    
    predictedLabels_phII(c:c+3,:) = predictLabels_s;
    c=c+4;
end
%writematrix(predictedLabels_phII,'Resultados_testPhII/LDA_predictedLabels_phII')