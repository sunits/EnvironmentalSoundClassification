%  clc;
%  clear all;
tic


data_path=struct('path',{ ...
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/nature_daytime' ... 
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/inside_vehicle', ...
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/restaurant', ...
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/casino', ...
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/nature_night', ... 
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/bell', ...
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/playgrounds', ...  
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/street-traffic', ...
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/thunder', ...
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/train', ... 
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/rain', ...
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/stream', ...
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/ocean', ...
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/ambulance'} ...
                );




blackListedDir= struct ('dir_name',{'.git','gmm','17D'} );
percentage_of_segments_for_training=0.75;


addpath /media/885C28DA5C28C532/Dropbox/code/htk/
save_log_file_at='/media/885C28DA5C28C532/Dropbox/code/htk/logFileGMM.mat';

%Logger function
l=logger;
            
total_dir=size(data_path,2);
%  new_mfcc_dir='sub_band_1K_cut_var_adj_18_dict_unwgt';

blackListedDirSize=size(blackListedDir,2);
blackListFlag=0;
dimensionOfMfcc=16;
maxNumberOfModals=5;
numberOfMFCCperParameterEst=15;

for dir_count=1:total_dir

    disp(strcat('Started ',data_path(dir_count).path))
l.logMesg(strcat('Starting directory ',data_path(dir_count).path));
save(save_log_file_at,'l');

mfccs=[];
% Change the path to where the wav files are stored
% cd /media/885C28DA5C28C532/sound_data/street-traffic/
cd (data_path(dir_count).path);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            BEWARE          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Removing all the folders containing the name gmm*
% disp 'Removing all the folders containing the name gmm*'
%      !rm -r gmm*

     mkdir(strcat('gmm/',new_mfcc_dir));
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
%             mfccs=[mfccs; dir(strcat(dir_path,'/*.mfc'))];
            
            all_mfcc_paths=ls(strcat(dir_path,'/*.mfc'));
            
            totalNumberOfSegments = (strfind(all_mfcc_paths,'.mfc'));
            segmentsForTraining=ceil(percentage_of_segments_for_training*length(totalNumberOfSegments)-1);
            
            if(segmentsForTraining<1)
                % use the available sample for testing(if at all)
                continue;
            end
            
            %For testing give floor(percentage_of_segments_for_training*length(totalNumberOfSegments)+1);
            l.logMesg(strcat('Taking ',segmentsForTraining,' for training in ',dir_path));
            
            mfccs=[mfccs all_mfcc_paths(1:totalNumberOfSegments(segmentsForTraining)+length('.mfc')) ];
        end       
    end
    

setenv('GMMDIR',strcat(data_path(dir_count).path,'/gmm/',new_mfcc_dir));
!echo $GMMDIR

fid= fopen(strcat('gmm/',new_mfcc_dir,'/all_mfc.scp'),'w');
fwrite(fid,mfccs);
fclose(fid);

%%  Decide the number of mixtures
% Count the number of MFCC vectors we have and decide the number of
% mixtures ftom there
no_of_mfcc=totalMFCCcount(strcat('gmm/',new_mfcc_dir,'/all_mfc.scp'));

% For each model we need to estimate 17 means 17 variances and, making a
% total of 34 parameters. Each parameter estimation needs 10 samples
numberOfModals=floor(no_of_mfcc/((dimensionOfMfcc+dimensionOfMfcc)*numberOfMFCCperParameterEst));

if(numberOfModals>maxNumberOfModals)
    numberOfModals=maxNumberOfModals;
end

setenv('MODALS',num2str(numberOfModals));
!echo $MODALS



%% Do the actual GMM
!csh /media/885C28DA5C28C532/Dropbox/code/htk/finalScript.csh >logger

[P,M,V]=leeHMM(strcat(data_path(dir_count).path,'/gmm/',new_mfcc_dir,'/models'));
[gmmObj]= createDistribution(P,M,V);

% save 'GMMOBJ' gmmObj;
save(strcat(data_path(dir_count).path,'/gmm/',new_mfcc_dir,'/GMMOBJ.mat'),'gmmObj')

l.logMesg(strcat('Completed GMM creation for ',data_path(dir_count).path));
save(save_log_file_at,'l');

disp(strcat('Exiting ',data_path(dir_count).path))

end
timeTaken=toc;
l.logMesg(strcat('Total time ',timeTaken));

save(save_log_file_at,'l');

