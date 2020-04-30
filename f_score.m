function [precision, recall, Fscore] = f_score(cm)
% Calculates the precision, recall and F-score of the prediction from the
% confusion matrix 

% cm: confusion matrix [true negative   ,  false positive
%                       false negative  ,  true positive]
TN = cm(1,1);
FN = cm(2,1);
FP = cm(1,2);
TP = cm(2,2);

precision = TP/(TP+FP);
recall = TP/(TP+FN);
Fscore = 2*(precision*recall)/(precision+recall);
end

