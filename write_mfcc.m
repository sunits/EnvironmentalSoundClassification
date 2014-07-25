

function [] = write_mfcc(mfcc_file,X,nframes,period,nbyte,tipo)

%% Descriptioon
% Code writes the given mfccs into a file having filename mentioned in mfcc_file 
% X is the actual mfcc (one mfcc in one row)
% nframes is the number of frames
% period is the standard period
% nbyte - check the note
% tipo is the type code = the sum of a data type and (optionally) one or
% more of the listed modifiers - Taken from writehtk (voicebox from htk website)
%             0  WAVEFORM     Acoustic waveform
%             1  LPC          Linear prediction coefficients
%             2  LPREFC       LPC Reflection coefficients:  -lpcar2rf([1 LPC]);LPREFC(1)=[];
%             3  LPCEPSTRA    LPC Cepstral coefficients
%             4  LPDELCEP     LPC cepstral+delta coefficients (obsolete)
%             5  IREFC        LPC Reflection coefficients (16 bit fixed point)
%             6  MFCC         Mel frequency cepstral coefficients
%             7  FBANK        Log Fliter bank energies
%             8  MELSPEC      linear Mel-scaled spectrum
%             9  USER         User defined features
%            10  DISCRETE     Vector quantised codebook
%            11  PLP          Perceptual Linear prediction
%            12  ANON
%            64  _E  Includes energy terms                  hd(1)
%           128  _N  Suppress absolute energy               hd(2)
%           256  _D  Include delta coefs                    hd(3)
%           512  _A  Include acceleration coefs             hd(4)
%          1024  _C  Compressed                             hd(5)
%          2048  _Z  Zero mean static coefs                 hd(6)
%          4096  _K  CRC checksum (not implemented yet)     hd(7) (ignored)
%          8192  _0  Include 0'th cepstral coef             hd(8)
%         16384  _V  Attach VQ index                        hd(9)
%         32768  _T  Attach delta-delta-delta index         hd(10)

%% Note
% make sure the nbyte is proper. It should be number of features times 4.
% For example if we have a 13 dimensional feature vector we must have
% nbyte=13*4=52

%%
f = fopen(mfcc_file,'w','ieee-le');
%   nframes   
  fwrite(f,nframes,'int32');
  
%   period 
  fwrite(f,period, 'int32');
%   nbyte   
  fwrite(f,nbyte, 'int16');
  
%   tipo    
  fwrite(f,tipo, 'int16');
  data=X';
  fwrite(f,data(:), 'float');
  
  
  fclose(f);
