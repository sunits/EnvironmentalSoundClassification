%% Read data- Replace this with the data obtained from the htk
% data=wavread('check_this.wav');
% sig=load('sig.txt');
clc
new_mfcc_file='unwgt_modified_mfc_check.mfc';
mfcc_path='mfc_check.mfc';
[mfcc,nframes,period,nbyte,tipo]=read_mfcc(mfcc_path);

newFeaturesToAdd=4;
totalNOfOldFeatures=size(mfcc,2);
%Four features are to be appended
features=zeros(size(mfcc,1),newFeaturesToAdd);

for index=1:length(mfcc)
    
    %% get the signal data here -Either from HTK or write code to obtain the overlapped si
     [freqMean,freqVar,scaleMean,scaleVar]=createMPFeature('gabor',sig(index,:));
     features(index,:)=[freqMean,freqVar,scaleMean,scaleVar];
     
     
end
%% Append the features to the MFCC

new_feature_indices=totalNOfOldFeatures+(1:newFeaturesToAdd);

% for i=1:newFeaturesToAdd
%     new_feature_indices[i] = totalNOfOldFeatures+i;
% end


mfcc(:,new_feature_indices)=features;
float_size=4;% This is the size of the float variable in a normal machine
nbyte=float_size*(totalNOfOldFeatures+newFeaturesToAdd);
%% Write MFCC vectors to a file
write_mfcc(new_mfcc_file,mfcc,nframes,period,nbyte,tipo)