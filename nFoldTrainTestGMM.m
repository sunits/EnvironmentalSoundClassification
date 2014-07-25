repeatations=10;

tic

mfcc_paths=struct('path',{ ...
        'sub_band_1K_cut_var_adj_4_dict_wgt', ...
        'sub_band_1K_cut_var_adj_4_dict_unwgt', ...       
        'sub_band_1K_cut_var_adj_13_dict_wgt', ...
        'sub_band_1K_cut_var_adj_13_dict_unwgt', ...
        'sub_band_1K_cut_var_adj_14_dict_wgt', ...
        'sub_band_1K_cut_var_adj_14_dict_unwgt', ...
        'sub_band_1K_cut_var_adj_15_dict_wgt', ...
        'sub_band_1K_cut_var_adj_15_dict_unwgt', ...
        'sub_band_1K_cut_var_adj_16_dict_wgt', ...
        'sub_band_1K_cut_var_adj_16_dict_unwgt', ...
        'sub_band_1K_cut_var_adj_17_dict_wgt', ...
        'sub_band_1K_cut_var_adj_17_dict_unwgt', ...
        'sub_band_1K_cut_var_adj_18_dict_wgt', ...
        'sub_band_1K_cut_var_adj_18_dict_unwgt', ...
        'sub_band_1K_cut_var_adj_19_dict_wgt', ...
        'sub_band_1K_cut_var_adj_19_dict_unwgt', ...
        'sub_band_1K_cut_var_adj_20_dict_wgt', ...
        'sub_band_1K_cut_var_adj_20_dict_unwgt', ...
        'sub_band_1K_cut_var_adj_21_dict_wgt', ...
        'sub_band_1K_cut_var_adj_21_dict_unwgt', ...
        'sub_band_1K_cut_var_adj_22_dict_wgt', ...
        'sub_band_1K_cut_var_adj_22_dict_unwgt', ...
    });
for  mfcc_path_count=1:size(mfcc_paths,2)
    acc_list=[];
for repeat=1:repeatations

clearvars -except acc_list  repeatations mfcc_paths mfcc_path_count

clc;
%  clear all;
new_mfcc_dir= mfcc_paths(mfcc_path_count).path;

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

blackListedDir= struct ('dir_name',{'.git','gmm','17D'} );
percentage_of_segments_for_training=0.75;


addpath /media/885C28DA5C28C532/Dropbox/code/htk/
save_log_file_at='/media/885C28DA5C28C532/Dropbox/code/htk/logFileGMM.mat';

%Logger function
l=logger;

total_dir=size(data_path,2);
%  new_mfcc_dir='sub_band_1K_cut_var_adj_15_dict_wgt';

blackListedDirSize=size(blackListedDir,2);
blackListFlag=0;
dimensionOfMfcc=16;
maxNumberOfModals=5;
numberOfMFCCperParameterEst=15;
testMfcc=[];
for dir_count=1:total_dir
    
    disp(strcat('Started ',data_path(dir_count).path))
    l.logMesg(strcat('Starting directory ',data_path(dir_count).path));
    save(save_log_file_at,'l');
    
    mfccs='';
    testMfcc(dir_count).path='';
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
    
    fid= fopen(strcat('gmm/',new_mfcc_dir,'/all_mfc.scp'),'wt');
    
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
            
            
            
            all_mfcc_paths=dir(strcat(dir_path,'/*.mfc'));
            totalNumberOfSegments = length(all_mfcc_paths);
%             all_mfcc_paths=ls(strcat(dir_path,'/*.mfc'));
            
%             totalNumberOfSegments = (strfind(all_mfcc_paths,'.mfc'));
            segmentsForTraining=ceil(percentage_of_segments_for_training*(totalNumberOfSegments)-1);
            
            if(segmentsForTraining<1)
                % use the available sample for testing(if at all)
                continue;
            end
            
            %For testing give floor(percentage_of_segments_for_training*length(totalNumberOfSegments)+1);
            l.logMesg(strcat('Taking ',segmentsForTraining,' for training in ',dir_path));
            
            positions=randperm(totalNumberOfSegments);
            trainingPos=positions(1:segmentsForTraining);
            testingPos=positions(segmentsForTraining+1:end);
            
            for path_index=1:length(trainingPos)
                mfccs=sprintf(strcat(dir_path,'/',all_mfcc_paths(trainingPos(path_index)).name));
%                 fwrite(fid,mfccs);
                fprintf(fid,'%s\n',mfccs);
            end
            
            
            for path_index=1:length(testingPos)
                testMfcc(dir_count).path=sprintf(strcat(testMfcc(dir_count).path,'\n',dir_path,'/',all_mfcc_paths(testingPos(path_index)).name));
            end
            
%             mfccs=[mfccs all_mfcc_paths(1:totalNumberOfSegments(segmentsForTraining)+length('.mfc')) ];
%             testMfcc=[testMfcc ]
        end
    end
    
    
    setenv('GMMDIR',strcat(data_path(dir_count).path,'/gmm/',new_mfcc_dir));
    !echo $GMMDIR
    
    
    
    fclose(fid);
    
    %%  Decide the number of mixtures
    % Count the number of MFCC vectors we have and decide the number of
    % mixtures ftom there
    no_of_mfcc=totalMFCCcount(strcat('gmm/',new_mfcc_dir,'/all_mfc.scp'));
    
    % For each model we need to estimate 16 means 16 variances and, making a
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



mfcc_struct=[];
mfcc_struct.mfcc=[];
mfcc_struct.truth=[];
mfcc_struct.estimated=[];

segment_count=0;

confusion_matrix=zeros(total_dir,total_dir);
gmmFolder='gmm';
GMMObjectName='GMMOBJ.mat';


%% Get all GMMs
for dir_count=1:total_dir
    cd (data_path(dir_count).path);
    load(strcat(gmmFolder,'/',new_mfcc_dir,'/',GMMObjectName));
    var=genvarname(strcat('gmm',num2str(dir_count)));
    eval([var '=gmmObj;']);
end




for dir_count=1:total_dir
    get_all_mfcc_names=regexp(testMfcc(dir_count).path,char(10),'split');
    
    for mfcc_names=1:size(get_all_mfcc_names,2)
        
        
        [X,nframes,period,nbyte,tipo,status]=read_mfcc(cell2mat(get_all_mfcc_names(mfcc_names)));
        if(status<0)
            disp (strcat('file - ',cell2mat(get_all_mfcc_names(mfcc_names)),' - does not exist'));
            continue;
        end
        segment_count=segment_count+1;
        
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
acc_percent=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
sprintf('And majesty, Your accuracy is %f',acc_percent)

acc_list=[acc_list acc_percent];

end
timeTaken=toc;

subject= strcat('10 Fold accuracy  of - ',new_mfcc_dir,' - ',num2str(mean(acc_list)));
content =strcat(num2str(acc_list),'\n the time taken is :',num2str(timeTaken));

send_mail(subject,content);
end
