function [band_energy] = sub_band_filters_freq_cut(number_of_sub_bands,data,fs,f)


f_data=abs(fft(data));
f_data=f_data(1:floor(end/2)); % got fft from 0-pi
% Design Low pass filter for pi/(2*num_of_sub_bands)

% neglect the power in sub f Hz
make_zero=ceil(length(f_data)*f/(0.5*fs));
f_data(1:make_zero)=0;


boundaries=floor(linspace(1,length(f_data),number_of_sub_bands+1));
band_energy=[];

for i=1:number_of_sub_bands
    band=f_data(boundaries(i):boundaries(i+1));    
    band_energy=[band_energy sum(band.^2)];
end