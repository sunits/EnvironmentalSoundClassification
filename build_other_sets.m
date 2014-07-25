% clc;
% clear all;

tic

% This is where the htk codes like creating MFCC files, creeting MP
% features are. They also contain config files.

addpath /media/885C28DA5C28C532/Dropbox/code/htk/
save_log_file_at='/media/885C28DA5C28C532/Dropbox/code/htk/logFile.mat';

data_path=struct('path',{ ...
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/ambulance', ...         
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/nature_daytime', ... 
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
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/ocean'} ...                                                                        
                );
            
 
 
l=logger;            
total_dir=size(data_path,2);

% new_mfcc_dir='blackman_sub_band_1K_14_dict_unwgt';
% new_mfcc_dir1='blackman_sub_band_1K_14_dict_wgt';


 new_mfcc_dir='sub_band_filter_adj_15_dict_unwgt';
 new_mfcc_dir1='sub_band_filter_adj_15_dict_wgt';


 number_of_sub_bands=15; 

segment_length=4; %in seconds
no_bits_per_sample=8;
path='./';
segments_var='segments.mat'; % This is where the segments of each set are stored

% Change the directory name if need be
wgt=true;


% If you are changing the sampling rate change the  cuttoff frequency of
% the low pass filter also and of course the downsampling rate
% final_sampling_rate=22050;


% Should get this 3  components - dict,frequency,scale
% load /media/885C28DA5C28C532/Dropbox/gabor_dict_256x1120.mat

% trying other dictionaries- these have heavy high frequeny content
% load /media/885C28DA5C28C532/Dropbox/gabor_dict_high_freq_wrap.mat

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
        
            % data_dependent dictionary
            [data fs]=wavread(all_wav(wav_index).name);
            data=data(:,1);
            
            if(length(data)>7000000)
                % Just to make sure there is no memory issues. There should
                % be sufficient frequency information in these 9000000
                % samples
                data=data(1:7000000);
            end
            
%             bands=high_low_filter(data,number_of_sub_bands);
% %             bands=sub_band_filters(number_of_sub_bands,data);
%             bands=sum(bands.^2); % calculating the energy in each band
% %             bands(1)=0; % Removing the low frequency band
            
            %1000 Hz  is to make sure the no frequency elements sub 1000 Hz
            %will be present
%           bands=sub_band_filters_freq_cut(number_of_sub_bands,data,fs,1000);
            bands=window_sub_band_filters(number_of_sub_bands,data,fs,1000);
            [frequency,scale,dict]=sub_band_gabor_dict(256,bands,fs);
                        
            
            
            new_dir=strcat(path,num2str(wav_index));
            cd (new_dir);
            
            mkdir(new_mfcc_dir);
            
            if(exist('new_mfcc_dir1','var'))
                mkdir(new_mfcc_dir1);
                
                % check which directory is wgtd and which is not
                
             if(strfind(new_mfcc_dir1,'unwgt')>0)  
                 un_wgt_directory=new_mfcc_dir1;
                 wgt_directory=new_mfcc_dir;
             else
                 wgt_directory=new_mfcc_dir1;
                 un_wgt_directory=new_mfcc_dir;
             end
              
                createAllMFCCs(pwd,wgt,un_wgt_directory,dict,frequency,scale,wgt_directory);
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
