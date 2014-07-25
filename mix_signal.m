function [signal]=mix_signal(signal1,signal2,mixtureRatio)
% A function to mix two signals at a ratio mentioned in mixtureRatio
% mixtureRatio should be an array of dimension 1x2. 
% The lengths of signal1 and signal2 may be different

signal1=signal1(:)';
signal2=signal2(:)';

len1=length(signal1);
len2=length(signal2);
signalTemp=[];

if len1 > len2
    loops=len1/len2;    
    for loop_index=1:floor(loops)
        signalTemp=[signalTemp signal2];        
    end
    
    signalTemp=[signalTemp signal2(1:len1-length(signalTemp))];
    signal2=signalTemp;
    
    
else    
    loops=len2/len1;    
    for loop_index=1:floor(loops)
        signalTemp=[signalTemp signal1];
    end
    signalTemp=[signalTemp signal1(1:len2-length(signalTemp))];
    signal1=signalTemp;
    
end

    %% Make both signals to have unit energy
    signal1=signal1/norm(signal1); 
    signal2=signal2/norm(signal2);
    
    signal= mixtureRatio(1)*signal1+mixtureRatio(2)*signal2;
    