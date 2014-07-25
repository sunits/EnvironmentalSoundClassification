function [freqMean,freqVar,scaleMean,scaleVar] = computeMeanVar(freq,scale,wgt)

%% Description
% This function computes the features i.e the weighted mean and deviation
% for both frequency and scale which are to be appended in the mfcc
% All data should be in 1xn format
%% Note
% if wgt is not given, it an unweighted mean and variance is computed.
% This is for 1-D only

%%
if(nargin<2)
    error('not enough inputs')
end

if(nargin<3)
    wgt=ones(size(freq));
%     if(size(freq,1)>1)
%         wgt=wgt';
%     end
end

freqMean=sum(freq.*abs(wgt))./sum(abs(wgt));
% freqVar=(((freq-freqMean).^2).*wgt)/sum(wgt)
% freqVar=sqrt(sum(((freq-repmat(freqMean,size(freq,1),1)).^2).*abs(wgt))./sum(abs(wgt)));

% unbaised freq std 
v1=sum(abs(wgt));
v2=sum(abs(wgt.^2));
temp=v1./(v1.^2-v2);
freqVar=sqrt(temp.*sum(((freq-repmat(freqMean,size(freq,1),1)).^2).*abs(wgt)));




scaleMean=sum(scale.*abs(wgt))./sum(abs(wgt));
% freqVar=(((freq-freqMean).^2).*wgt)/sum(wgt)
% scaleVar=sqrt(sum(((scale-repmat(scaleMean,size(scale,1),1)).^2).*abs(wgt))./sum(abs(wgt)));

%unbaised scale std
v1=sum(abs(wgt));
v2=sum(abs(wgt.^2));
temp=v1./(v1.^2-v2);
scaleVar=sqrt(temp.*sum(((scale-repmat(scaleMean,size(scale,1),1)).^2).*abs(wgt)));


freqMean(isnan(freqMean))=0;
freqVar(isnan(freqVar))=0;
scaleMean(isnan(scaleMean))=0;
scaleVar(isnan(scaleVar))=0;
