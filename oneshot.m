clc;
clear all;


tic

% This is where the htk codes like creating MFCC files, creeting MP
% features are. They also contain config files.



%% Load Dictionary
load /media/885C28DA5C28C532/Dropbox/gabor_dict_high_freq_wrap.mat

%% Paths to look for
addpath /media/885C28DA5C28C532/Dropbox/code/htk/

save_log_file_at='/media/885C28DA5C28C532/Dropbox/code/htk/logFile.mat';


basePath='/media/885C28DA5C28C532/sound_data/sounds_again';

%% Configuration

is_raw_mfcc_built=true;

data_path=struct('path',{ ...
                        'nature_daytime', ... 
                        'inside_vehicle', ...
                        'restaurant', ...    
                        'casino', ...         
                        'nature_night', ... 
                        'police-sirens', ...         
                        'playgrounds', ...  
                        'street-traffic', ...         
                        'thunder', ...
                        'train', ... 
                        'rain', ...
                        'stream', ...                                               
                        'ocean', ...         
                        'ambulance'} ...                                                                        
                );
            
general_paths=struct('mfcc','mfcc_23_filter', ...
                     'new_mfcc','unwgt_mfcc' ...
                    )
            
            
l=logger;            
total_dir=size(data_path,2);

% Change the directory name if need be
wgt=false;
new_mfcc_dir='unwgt_mfcc';

segment_length=4; %in seconds
no_bits_per_sample=16;
path='./';
segments_var='segments.mat'; % This is where the segments of each set are stored



% If you are changing the sampling rate change the  cuttoff frequency of
% the low pass filter also and of course the downsampling rate
final_sampling_rate=22050;

blackListedDir= struct ('dir_name',{'.git','gmm','17D'} );
percentage_of_segments_for_training=0.75;


dimensionOfMfcc=16;
maxNumberOfModals=5;
numberOfMFCCperParameterEst=15;




%% GMM configs
gmmFolder='gmm';
GMMObjectName='GMMOBJ.mat';





%% build the modified MFCC + MP features
if(is_raw_mfcc_built)
    l.logMesg('Building MP feature extraction');
    build_other_sets_one_shot;
    l.logMesg('Completing MP feature extraction');
else
    l.logMesg('Building MFCC + MP from scratch');
    build_sets_one_shot;
    l.logMesg('Completion of MFCC + MP feature extraction');
end

%% build GMM
build_gmm;

%% Do classifcation of test data
test_gmm;
