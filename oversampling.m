function [ovsData,ovsTargets,varargout] = oversampling(features,targets,N,repeat)

%   NP300 : number of elements of each class that we want
%  repeat : number of P300 signals to repeat

factor = N/repeat;

if size(features,3)>1
    allP300X = features(:,:,(targets==1));
    allNormalX = features(:,:,(targets==0));
    
    allP300Y = targets(targets==1);
    allNormalY = targets(targets==0);
    
    % Use N random normal signals + 'repeat' random P300 signals
    % repeated 'factor' times
    posNormal = randperm(length(allNormalY),N);
    posP300 = randperm(length(allP300Y),repeat);
    
    ovsData = cat(3,repmat(allP300X(:,:,posP300),1,1,factor),...
        allNormalX(:,:,posNormal));
    ovsTargets = [repmat(allP300Y(posP300),factor,1);...
        allNormalY(posNormal)];
    
    % permute elements to randoly mix classes in the matrix
%     pmix = randperm(length(ovsTargets));
%     ovsTargets = ovsTargets(pmix);
%     ovsData = ovsData(:,:,pmix);
%     
elseif size(features,3)==1
    allP300X = features((targets==1),:);
    allNormalX = features((targets==0),:);
    
    allP300Y = targets(targets==1);
    allNormalY = targets(targets==0);
    
    % Use N random normal signals + 'repeat' random P300 signals
    % repeated 'factor' times
    posNormal = randperm(length(allNormalY),N);
    posP300 = randperm(length(allP300Y),repeat);
    
    ovsData = [repmat(allP300X(posP300,:),factor,1);...
        allNormalX(posNormal,:)];
    ovsTargets = [repmat(allP300Y(posP300),factor,1);...
        allNormalY(posNormal)];
    
    % permute elements to randoly mix classes in the matrix
%     pmix = randperm(length(ovsTargets));
%     ovsTargets = ovsTargets(pmix);
%     ovsData = ovsData(pmix,:);
    
end
varargout{1} = posP300;
end

