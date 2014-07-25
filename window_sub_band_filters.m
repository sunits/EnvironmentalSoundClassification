function [band_energy] = window_sub_band_filters(number_of_sub_bands,data,fs,f)


f_data=abs(fft(data));
f_data=f_data(1:floor(end/2)); % got fft from 0-pi
% Design Low pass filter for pi/(2*num_of_sub_bands)

% neglect the power in sub f Hz
make_zero=ceil(length(f_data)*f/(0.5*fs));
f_data(1:make_zero)=0;


%rectangular windowing
% boundaries=floor(linspace(1,length(f_data),number_of_sub_bands+1));
% 
% band_energy=[];
% 
% for i=1:number_of_sub_bands
%     band=f_data(boundaries(i):boundaries(i+1));    
%     band_energy=[band_energy sum(band.^2)];
% end
% 

% Window overlapping rule (in percentage)
% rectangle 20
% Triangle  52
% Hann      56
% Hamming   56
% Blackman  69
% Kaiser( for alpha )
%  2.46     44
%  3.15     70
%  3.76     75
  
% Windowing 
overlap=0.69; %in percentage
win_length=floor(length(f_data)/((1-overlap)*(number_of_sub_bands-1)+1));
window_type=blackman(win_length);
band_energy=[];


for i=1:number_of_sub_bands
    window=zeros(1,length(f_data));
    start=ceil(1+(i-1)*win_length*(1-overlap));
    window(start:start+win_length-1)=window_type;
    windowed_fft=window.*f_data';
    band_energy=[band_energy sum(windowed_fft.^2)];
end




