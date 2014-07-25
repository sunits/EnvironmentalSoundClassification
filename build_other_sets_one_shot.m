total_dir=size(data_path,2);


for dir_count=1:total_dir
    disp(strcat('Started ',data_path(dir_count).path))
    l.logMesg(strcat('Starting directory ',data_path(dir_count).path));

% Change the path to where the wav files are stored
% cd /media/885C28DA5C28C532/sound_data/street-traffic/
cd (data_path(dir_count).path);


%OMP code in mex format 
% addpath /media/885C28DA5C28C532/Dropbox/code/compressedSensing/OMPBox

all_wav=dir('*.wav');



for wav_index=1:length(all_wav)    
            
            new_dir=strcat(path,num2str(wav_index));
            cd (new_dir);
            
            mkdir(new_mfcc_dir);
            
            if(exist('new_mfcc_dir1','var'))
                mkdir(new_mfcc_dir1);
                createAllMFCCs(pwd,wgt,new_mfcc_dir,dict,frequency,scale,new_mfcc_dir1);
            else
                createAllMFCCs(pwd,wgt,new_mfcc_dir,dict,frequency,scale);
            end
    cd ..;          

    l.logMesg(strcat('Completing and exiting directory ',new_mfcc_dir));
    save(save_log_file_at,'l');

end
 l.logMesg(strcat('Exiting directory ',data_path(dir_count).path));
 save(save_log_file_at,'l');
 disp(strcat('Exiting ',data_path(dir_count).path))
end

time_spent=toc;
l.logMesg(strcat('time spent ',num2str(time_spent)))
save(save_log_file_at,'l');