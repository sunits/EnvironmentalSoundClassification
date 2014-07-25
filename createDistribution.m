function[gmmObj]= createDistribution(P,M,V)
%Creates a GMM of the desired object 


% Dimensions of variables to be given for the function createDistribution
% P - 1xn
% M - kxd
% V - kxd
% Here d is the feature dimension 


SIGMA=zeros(1,size(M,2),size(M,1));
SIGMA(1,:,:)=V';

gmmObj=gmdistribution(M,SIGMA,P);

end
