function [components]=high_low_filter(signal,bands)

% Author : Sunit Sivasankaran

% Objective : To create (bands+1) sub-bands of signal and each band is
% outputed as a coloumn vector of the output variable "components" in time
% domain

% signal is the signal whose low pass and high pass component are to be
% computed
%This is a recursive function whose components are calculated in a
%recursive manner

components=[];

signal=signal(:);

    
signal_high=0.5*([signal ;0]-[0; signal]);
signal_high=signal_high(1:end-1);
signal_high(1)=signal(1);

signal_low=signal-signal_high;
components=[signal_low(:) signal_high(:)];


bands=bands-1;  
    
if(bands>0)
    
    components= high_low_filter(signal_low(:),bands);
    components=[components  high_low_filter(signal_high(:),bands)];
    
    
end
