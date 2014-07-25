clc;
% clear all;

addpath /media/885C28DA5C28C532/Dropbox/code/htk/

data_path=struct('path',{ ...
%                         '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/nature_daytime', ... 
%                         '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/inside_vehicle', ...
%                         '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/restaurant', ...    
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/casino', ...                                                      
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/ocean'} ...                                                                        
                );
% 
% data_path=struct('path',{ } );            
%  
%             plot_marker={'-s','r-x','-d'};

            
total_dir=size(data_path,2);

freq_blocks=35;

f_all=[];
number_of_sub_bands=12;


for dir_count=1:total_dir

    cd (data_path(dir_count).path);
    
    all_wav=dir('*.wav');
    for wav_index=1:1
        
           [data fs]=wavread(all_wav(wav_index).name);
           max_freq=fs;
            data=data(:,1);
            
            if(length(data)>7000000)
                % Just to make sure there is no memory issues. There should
                % be sufficient frequency information in these 9000000
                % samples
                data=data(1:7000000);
            end
%             bands=high_low_filter(data,3);

%             bands=sub_band_filters(12,data);
            
%             bands=sub_band_filters_freq_cut(12,data,fs,1000);
            
            bands=window_sub_band_filters(number_of_sub_bands,data,fs,1000);
            
            
%             clear data;
            
            bands(1)=0; % Removing the low frequency band
            
            
            band_energies=bands;
            number_of_bands=size(band_energies,2);
            
            band_energy_ratio=band_energies/sum(band_energies);
            bands=freq_blocks*band_energy_ratio;
            bands=round(bands);
            % sanity check - check to see that the sum adds up to 35
            %if the sum is more than 35 keep subtracting from the last band
            % if rounding increases the numnber of atoms
            pos=number_of_bands;
            while(sum(bands)>freq_blocks)
                if(bands(pos)>0)
                    bands(pos)=bands(pos)-1;
                else
                    pos=pos-1;
                end    
            end

            % if rounding decreases the atoms

            while(sum(bands)<freq_blocks)
                [j,pos]=max(bands);
                bands(pos)=bands(pos)+1;
            end

            boundaries=linspace(0,max_freq,number_of_bands+1); % +1 because of external boundaries
            f=[];
            f1=[];
            f2=[];

            for i=1:number_of_bands
%                 divide into bands and take the midpoints!! This way u will avoid taking endpoints twice
%                 temp=linspace(boundaries(i),boundaries(i+1),bands(i)+1);
%                 f2=[f2 temp(2:end)];
%                 temp=(temp+[temp(2:end) 0])/2;
%                 temp=temp(1:end-1);                
%                 f=[f temp];
%                 f1=[f1 linspace(boundaries(i),boundaries(i+1),bands(i))];
%                 

                temp=linspace(boundaries(i),boundaries(i+1),bands(i));
                if(numel(temp)<1)
                    continue;
                end
                if(numel(temp)>1)
                    temp(1)= (temp(1)+temp(2))/2 ;
                end

                f=[f temp];
                
            end
            plot(0.5*f/max_freq,plot_marker{dir_count});
            hold on;           
            
    end
    f=f';
    f_all=[f_all 0.5*f/max_freq];
    
    
end

    
