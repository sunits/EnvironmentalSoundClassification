%  clc;
%  clear all;

% This file takes in the GMMOBJ object stored in the directory(After building the GMM)

tic

% This is where the htk codes like creating MFCC files, creeting MP
% features are. They also contain config files.

addpath /media/885C28DA5C28C532/Dropbox/code/htk/
save_log_file_at='/media/885C28DA5C28C532/Dropbox/code/htk/logTestFile.mat';



blackListedDir= struct ('dir_name',{'.git','gmm','17D'} );

blackListedDirSize=size(blackListedDir,2);

% 
% data_path=struct('path',{ ...
%                         '/media/885C28DA5C28C532/sound_data/train', ... 
%                         '/media/885C28DA5C28C532/sound_data/ocean', ...         
%                         '/media/885C28DA5C28C532/sound_data/playgrounds', ...         
%                         '/media/885C28DA5C28C532/sound_data/restaurant', ...         
%                         '/media/885C28DA5C28C532/sound_data/street-traffic', ...         
%                         '/media/885C28DA5C28C532/sound_data/ambulance', ...         
%                         '/media/885C28DA5C28C532/sound_data/casino', ...         
%                         '/media/885C28DA5C28C532/sound_data/stream', ...                                               
%                         '/media/885C28DA5C28C532/sound_data/inside_vehicle', ...
%                         '/media/885C28DA5C28C532/sound_data/nature_daytime', ... 
%                         '/media/885C28DA5C28C532/sound_data/nature_night', ... 
%                         '/media/885C28DA5C28C532/sound_data/rain', ...
%                         '/media/885C28DA5C28C532/sound_data/thunder'} ...                                                                        
%                 );
%             

dir_to_test='data_23_44_verified';


data_path=struct('path',{ ...
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/nature_daytime'), ... 
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/inside_vehicle'), ...
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/restaurant'), ...    
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/casino'), ...         
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/nature_night'), ... 
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/bell'), ...         
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/playgrounds'), ...  
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/street-traffic'), ...         
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/thunder'), ...
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/train'), ... 
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/rain'), ...
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/stream'), ...                                               
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/ocean'), ...         
                        strcat(('/media/885C28DA5C28C532/sound_data/sounds_again/'),dir_to_test,'/ambulance')} ...                                                                        
                );
l_test=logger;            
total_dir=size(data_path,2);
percentage_of_segments_for_training=0.75;

gmmFolder='gmm';
 new_mfcc_dir='sub_band_1K_cut_var_adj_15_dict_wgt';
GMMObjectName='GMMOBJ.mat';

fprintf('starting %s  and looking for features in the %s\n',dir_to_test,new_mfcc_dir);

blackListFlag=0;

mfcc_struct=[];
mfcc_struct.mfcc=[];
mfcc_struct.truth=[];
mfcc_struct.estimated=[];

segment_count=0;

confusion_matrix=zeros(total_dir,total_dir);

%% Get all GMMs
for dir_count=1:total_dir
    cd (data_path(dir_count).path);
    load(strcat(gmmFolder,'/',new_mfcc_dir,'/',GMMObjectName));
    var=genvarname(strcat('gmm',num2str(dir_count)));
    eval([var '=gmmObj;']);
end


for dir_count=1:total_dir
    
    mfccs=[];
% Change the path to where the wav files are stored
% cd /media/885C28DA5C28C532/sound_data/street-traffic/
cd (data_path(dir_count).path);
fprintf('cd-ing to %s .................. \n',data_path(dir_count).path);
directories=dir;

    for dir_index=3:size(directories,1)        
            
        if(isdir(directories(dir_index).name))           
            
            for black_index=1:blackListedDirSize
                    if(strcmp(directories(dir_index).name,blackListedDir(black_index).dir_name))
                        blackListFlag=1;
                        break;
                    end
            end
            
            if(blackListFlag)
                blackListFlag=0;
                continue;
            end
            
            dir_path=strcat(data_path(dir_count).path,'/',directories(dir_index).name,'/',new_mfcc_dir);
%           mfccs=[mfccs; dir(strcat(dir_path,'/*.mfc'))];
            
            all_mfcc_paths=ls(strcat(dir_path,'/*.mfc'));
            
            totalNumberOfSegments = (strfind(all_mfcc_paths,'.mfc'));
%             segmentsForTraining=floor(percentage_of_segments_for_training*length(totalNumberOfSegments)+1);
            segmentsForTraining=ceil(percentage_of_segments_for_training*length(totalNumberOfSegments));
            
            
            l_test.logMesg(strcat('Taking ',segmentsForTraining,' for training in ',dir_path));
            
            mfccs=[mfccs all_mfcc_paths(totalNumberOfSegments(segmentsForTraining)+length('.mfc')+1:end) ];
            
        end       
    end
    
    
%     Ascii equivalent of 10 is the spacing between each mfcc file name generated using ls
    get_all_mfcc_names=regexp(mfccs,char(10),'split');
   
%%    Do the classification for each segment
%the last split using the regex for mfccs will give a space
%Each for loop is a new segment
    for mfcc_names=1:size(get_all_mfcc_names,2)-1
        
        segment_count=segment_count+1;
        [X,nframes,period,nbyte,tipo]=read_mfcc(cell2mat(get_all_mfcc_names(mfcc_names)));
        mfcc_struct.mfcc(segment_count,:,:)=X;
        mfcc_struct.truth=[mfcc_struct.truth dir_count];
        %TODO
        % Get the segment number also for easy analysis
        
        %Test the MFCC against each GMM
        my_guess=0;
        previous_best_prob_val= -Inf;
        
        for gmmIndex=1:total_dir
%             disp(strcat('trying gmm',num2str(gmmIndex)));
            Y=pdf(eval(strcat('gmm',num2str(gmmIndex))),X);
            prob=sum(log10(Y));
            if(prob>previous_best_prob_val)
                my_guess=gmmIndex;
                previous_best_prob_val=prob;
            end
%             plot(Y);
        end
        confusion_matrix(dir_count,my_guess)=confusion_matrix(dir_count,my_guess)+1;
        
        mfcc_struct.estimated=[mfcc_struct.estimated my_guess];
    end   
    
    
    
end
disp 'This, your honour is the final confusion matrix in percentage';
final_confusion_mat=confusion_matrix;

for index=1:size(confusion_matrix,1)
    final_confusion_mat(:,index)=confusion_matrix(:,index)./sum(confusion_matrix,2);
end

round(final_confusion_mat*100)

disp 'And majesty, This is your accuracy.'

sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100

% disp 'I hope you are mightily pleased!'
