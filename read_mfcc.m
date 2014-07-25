%% Code reads the mfccs of the given utterance
% and then it converts it into the ascii format

function [X,nframes,period,nbyte,tipo,status] = read_mfcc(mfcc_file)
  f       = fopen(mfcc_file,'r','ieee-le');
  status=0;
  if(f<0)
    status=-1;
    X=[];nframes=[];period=[];nbyte=[];tipo=[];
    return;
  end
  
  nframes   = fread(f,1,'int32');
  period = fread(f,1,'int32');
  nbyte   = fread(f,1,'int16');
  tipo    = fread(f,1,'int16');
  [x,nr]  = fread(f,Inf,'float');
  fclose(f);

  ncomp = nbyte/4; % Tamano de los float

  X = zeros(nframes,ncomp);
  for i=1:nframes
    inival = (i-1)*ncomp+1;
    X(i,:) = x(inival:inival+ncomp-1)';
  end
  
