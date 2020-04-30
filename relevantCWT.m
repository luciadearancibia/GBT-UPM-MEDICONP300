function [CWTfeatures] = relevantCWT(CWTcoeffs,Nevents,I,J)

Nchannel = size(I,2);

% select "relevant" coefficients
CWTfeatures = zeros(Nevents,1);
for k=1:8
    cwt_ft_k = zeros(Nevents,Nchannel);
    for ft = 1:Nchannel
        cwt_ft_k(:,ft)=permute(CWTcoeffs(I(k,ft),J(k,ft),k,:),[4,2,3,1]);
    end
    CWTfeatures=cat(2,CWTfeatures,cwt_ft_k);
end
CWTfeatures(:,1)=[];
end

