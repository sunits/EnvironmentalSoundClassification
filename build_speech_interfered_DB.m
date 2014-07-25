clear ;clc;
speech_training_link='/media/885C28DA5C28C532/data/TIMIT/timit/train/';
env_sound_link='/media/885C28DA5C28C532/backups/data/';
new_env_sound_link='/media/885C28DA5C28C532/Env_sound_interference/0dB/';
gender='m'; %'m' for male , 'f' for female, '' for all
TIMIT_sampling_rate=16000;





%% Speech Part
all_speech_dir=dir(speech_training_link);
all_speech_dir=all_speech_dir(3:end); % Remove the '.'  and '..' 
number_of_speech_dir=length(all_speech_dir);

%% Env sound part
all_env_sound=dir(env_sound_link);
all_env_sound=all_env_sound(3:end);% Remove the '.'  and '..' 
number_of_env_dir=length(all_env_sound);

for index=1:number_of_env_dir
    
    fprintf('---------------------\n');
    
    fprintf('%s\n',all_env_sound(index).name);
    %% Create the directory if it does not exists
%     mkdir([new_env_sound_link all_env_sound(index).name]);
    
    all_wav_files=dir([env_sound_link all_env_sound(index).name '/*.wav']);
    fprintf('---------------------\n');
    for wav_index=1:length(all_wav_files)
        
        
        %% Get a random speech signal
        sub_folder_index=randint(1,1,[1 number_of_speech_dir]);
      all_speech_sub_folders=dir([speech_training_link all_speech_dir(sub_folder_index).name '/' gender '*' ]); % Get gender specific speech files
      
      %% Temp hack to make sure '.' and  '..' are not part of all_speech_sub_folders. This happens when gender =''
      if(all_speech_sub_folders(1).name=='.')
          all_speech_sub_folders=all_speech_sub_folders(3:end);
      end
      
      speech_file_index=randint(1,1,[1 length(all_speech_sub_folders)]);
      speech_files=dir([speech_training_link all_speech_dir(sub_folder_index).name '/' all_speech_sub_folders(speech_file_index).name '/*.wav' ]);
      speechFile=[speech_training_link all_speech_dir(sub_folder_index).name '/' all_speech_sub_folders(speech_file_index).name '/' ...
                    speech_files(randint(1,1,[1 length(speech_files)])).name];
      fprintf('%s\n',speechFile);
      
      
     [env_data fs_env]=wavread([env_sound_link all_env_sound(index).name '/' all_wav_files(wav_index).name]);
     env_data=resample(env_data(:,1),TIMIT_sampling_rate,fs_env);
     
     [speech_data fs_speech]=wavread(speechFile);
     signal=mix_signal(speech_data,env_data,[1 1]);
     signal=0.5*signal/max(abs(signal));
     
     write_path=[new_env_sound_link all_env_sound(index).name '/' all_wav_files(wav_index).name];
     wavwrite(signal,TIMIT_sampling_rate,write_path);
     
     

      
      
    end
    
    
end
