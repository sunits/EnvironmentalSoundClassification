%% Read data- Replace this with the data obtained from the htk

function []=createAllMFCCs(directory,wgt,outdir,dict,frequency,scale,outdir1)
%The directory path is expected to contain the mfcc's and signal in the
%folowing standard. Every 1.mfc will have a 1.txt file containing the
%corresponding signal in a text format

% If both weighted and unweighted are to be calculated - the order of
% directories must be as follows - 1-> unweighted 2-> weighted i.e
% outdir=unwgt outdir1 =wgtd

all_mfcc=dir('*.mfc');
newFeaturesToAdd=4;

%% Do a default entry if directory is not given

% TODO
%% 
for i =1:size(all_mfcc,1)
    
[mfcc,nframes,period,nbyte,tipo] = read_mfcc(strcat(directory,'/',all_mfcc(i).name));
outPath=strrep(strcat(directory,'/',outdir,'/',all_mfcc(i).name),'.mfc','_new.mfc');

signalPath=strrep(strcat(directory,'/',all_mfcc(i).name),'.mfc','.txt');
sig=load(signalPath);
totalNOfOldFeatures=size(mfcc,2);
%Four features are to be appended
features=zeros(size(mfcc,1),newFeaturesToAdd);

if(nargin>6)
    %trying to do both wgted and unweighted in one shot
    outPath1=strrep(strcat(directory,'/',outdir1,'/',all_mfcc(i).name),'.mfc','_new.mfc');
    features1=zeros(size(mfcc,1),newFeaturesToAdd);
end

%% create the actual MP features

% for index=1:length(mfcc)
     if(nargin>6)
         [freqMean,freqVar,scaleMean,scaleVar,freqMean1,freqVar1,scaleMean1,scaleVar1]=createMPFeature(dict,frequency,scale,sig',wgt,true);
         features=[freqMean',freqVar',scaleMean',scaleVar'];
         features1=[freqMean1',freqVar1',scaleMean1',scaleVar1'];         
     else         
        [freqMean,freqVar,scaleMean,scaleVar]=createMPFeature(dict,frequency,scale,sig',wgt);
        features=[freqMean',freqVar',scaleMean',scaleVar'];
     end
% end

%% Append the features to the MFCC

new_feature_indices=totalNOfOldFeatures+(1:newFeaturesToAdd);

mfcc(:,new_feature_indices)=features;
float_size=4;% This is the size of the float variable in a normal machine
nbyte=float_size*(totalNOfOldFeatures+newFeaturesToAdd);
%% Write MFCC vectors to a file

write_mfcc(outPath,mfcc,nframes,period,nbyte,tipo);

if(nargin>6)
    %writing the wgted components
    mfcc(:,new_feature_indices)=features1;
    write_mfcc(outPath1,mfcc,nframes,period,nbyte,tipo);
end


end

