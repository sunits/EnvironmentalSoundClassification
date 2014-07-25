data_path=struct('path',{ ...
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
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/ocean', ...         
                        '/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/ambulance'} ...                                                                        
                );
            
 

            
total_dir=size(data_path,2);

for dir_count=1:total_dir

    cd (data_path(dir_count).path);
    
    all_wav=dir('*.wav');
    for wav_index=1:length(all_wav)    
        
           [data fs]=wavread(all_wav(wav_index).name);
            data=data(:,1);
            
            if(length(data)>9000000)
                % Just to make sure there is no memory issues. There should
                % be sufficient frequency information in these 9000000
                % samples
                data=data(1:9000000);
            end
            bands=high_low_filter(data,number_of_sub_bands);
            bands=sum(bands.^2); % calculating the energy in each band
            bands(1)=0; % Removing the low frequency band
            
            band_energies=bands;
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

            for i=1:number_of_bands
                f=[f linspace(boundaries(i),boundaries(i+1),bands(i))];    
            end

    end
end
