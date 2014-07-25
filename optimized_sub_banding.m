function [band_energy] = optimized_sub_banding(data,fs,fc,min_energy_in_band)

%% Input details
% data - the signal in time domain
% fs- Sampling frequency
% fc- Cutoff frequency, below which the energy need not be considered
% min_energy_in_band - minimum energy in a band wrt the total energy(in
% percentage), any further division will make the band useless.

if(nargin<4)
    min_energy_in_band=0.2;
end

% This function optimizes sub banding process by adaptively setting up the
% boundaries 

f_data=abs(fft(data));
f_data=f_data(1:floor(end/2)); % got fft from 0-pi
% Design Low pass filter for pi/(2*num_of_sub_bands)

% neglect the power in sub f Hz - Consider using high pass filtering
make_zero=ceil(length(f_data)*fc/(0.5*fs));
f_data(1:make_zero)=0;

total_energy=sum(f_data.^2);
% 
% 
% boundaries=floor(linspace(1,length(f_data),number_of_sub_bands+1));
% band_energy=[];
% 
% for i=1:number_of_sub_bands
%     band=f_data(boundaries(i):boundaries(i+1));    
%     band_energy=[band_energy sum(band.^2)];
% end

components=dyadic_grouping(f_data,min_energy_in_band,total_energy,[1 length(f_data)]);
band_energy=group_bands(components,min_energy_in_band,total_energy);
end

function [components boundaries]=dyadic_grouping(fSignal,threshold,total_energy,boundary)

% boundary should have 2 components the first one is the lower and the second one in the upper 

% Objective : To create (bands+1) sub-bands of signal and each band is
% output as a coloumn vector of the  variable "components" in time
% domain

% signal is the signal whose low pass and high pass component are to be
% computed
%This is a function whose components are calculated in a
%recursive manner

components=[];
boundaries=[];

fSignal=fSignal(:);

% 
% if(~isBandDivisible(signal,threshold,total_energy))
%     fprintf('Entering the hole--Signal Energy:%d\n',sum(signal.^2));
%     components=signal(:);
%     return;
% end

 fprintf('Signal Energy:%d threshold: %d \n',sum(fSignal.^2),threshold*total_energy);

mid=ceil(1+length(fSignal)/2);

signal_low=fSignal(1:mid);
signal_high=fSignal(mid:length(fSignal));


if(isBandEnergySufficient(signal_low,threshold,total_energy))
    [temp_components temp_boundaries]= dyadic_grouping(signal_low(:),threshold,total_energy,[boundary(1) mid]);
    components=[components sum(temp_components.^2)];
    boundaries=[boundaries temp_boundaries];
else
    components=[components sum(signal_low(:).^2)];
    boundaries=[boundaries [boundary(1) mid]' ];
end

    
if(isBandEnergySufficient(signal_high,threshold,total_energy))
    [temp_components temp_boundaries]=dyadic_grouping(signal_high(:),threshold,total_energy,[mid boundary(2)]);
%     components=[components  dyadic_grouping(signal_high(:),threshold,total_energy,[mid boundary(2)])]; 
    components=[components sum(temp_components.^2)];
    boundaries=[boundaries temp_boundaries];
else
    components=[components sum(signal_high(:).^2)];
    boundaries=[boundaries [mid boundary(2)]'];
end

end

function [possibility] =isBandDivisible(band,threshold,total_energy)
% Function to check if the band can be further divided

    band_energy=sum(band.^2)/total_energy;

    possibility=false;
    % The band energy must atleast be twice the threshold energy for it to divide
    if(band_energy>=2*threshold)
        possibility=true;
    end
end


function [suff] =isBandEnergySufficient(band,threshold,total_energy)
% Function to check if the band can be further divided

    band_energy=sum(band.^2)/total_energy;

    suff=false;
    % The band energy must atleast be twice the threshold energy for it to divide
    if(band_energy>=threshold)
        suff=true;
    end
end

function [bands]=group_bands(components,threshold,total_energy)

    bandE=sum(components.^2);
%     check if there are any bands which have higher energy than the threshold - should not be there

    thresholdE=total_energy*threshold;
    pos=bandE>thresholdE;
    bands=[];
    temp=0;
    for i=1:length(pos)
        if(pos(i)==0)
            temp=temp+bandE(i);
            if(temp>thresholdE)
                bands=[bands temp];
                temp=0;
            end
        else
             bands=[bands bandE(i)];
        end
        
    end
    
%     take care of the last band
    if(temp~=0)
        bands=[bands temp];
    end    
    
end
