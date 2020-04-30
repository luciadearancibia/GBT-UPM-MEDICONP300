function [I,J] = tStudentofCWT(coeffs,targets,nMax,varargin)
% Calculates points I, J were the discriminability of CWT is maximum among
% 2 classes
%   nMax : total number of CWT coefficients to extract as features per
%   observation

log_labels = logical(targets);
% STEP TWO: mean and variance

% Separate data from target 0 (no P300) and 1 (positive P300)
p_coef = coeffs(:,:,:,log_labels);
n_coef = coeffs(:,:,:,~log_labels);

% Mean and variance of wavelet coefficient of positive P300 events
mean_w_p = mean(p_coef, 4);
var_w_p = var(p_coef, 0, 4);

% Mean and variance of wavelet coefficient of negative P300 events
mean_w_n = mean(n_coef, 4);
var_w_n = var(n_coef, 0, 4);

if (~isempty(varargin))&&(strcmp(varargin{2},'yes'))
%     figure(1)
%     subplot(2,1,1)
%     surf(mean_w_p')
%     title('mean CWTs from P300 fragments')
%     xlabel('times')
%     ylabel('scales')
% 
%     subplot(2,1,2)
%     surf(mean_w_n')
%     title('mean CWTs from normal fragments')
%     xlabel('times')
end

% STEP THREE: Student's two sample t-statistic
% number of samples of each target
p = size(p_coef,4);
n = size(n_coef,4);

d = mean_w_p - mean_w_n;  % difference average
pvar = ((p-1).*var_w_p + (n-1).*var_w_n)./(n+p-2);

tStudent = sqrt(n*p/(n+p))*d./pvar;

if (~isempty(varargin))&&(strcmp(varargin{2},'yes'))
    figure(2)
    surf(tStudent(:,:,1)')
    xlabel('scales')
    ylabel('samples')
    hold on
end

% STEP FOUR: detection of local extrema (nMax (16) points with largest 
%absolute value of the Student's t-statistic
nChannel = nMax/8;
ind = zeros(8,nChannel);
i = zeros(8,nChannel);
I = zeros(8,nChannel);
J = zeros(8,nChannel);
for k=1:8
    t = abs(tStudent(:,:,k));
    [tdesc, ix] = sort(reshape(t, [size(t,1)*size(t,2),1]),'descend');
    extr = tdesc(1:nChannel); % take 16 largest values
    i(k,:) = ix(1:nChannel);
%     for j=1:nChannel
%         ind(k,j)=find(t==extr(j),1); % find indixes of extrema in the matrix with tStudent values
%     end
    if t(i(k,:))==extr
        fprintf('Extrema found correctly for channel %g\n',k)
    end
    [I(k,:),J(k,:)]=ind2sub(size(t),i(k,:));
end

if (~isempty(varargin))&&(strcmp(varargin{2},'yes'))
    plot3(I(1,:),J(1,:),tStudent(I(1,:),J(1,:),1),'o','color','red')
    save('relevant_cwt_ind','I','J')
end

end

