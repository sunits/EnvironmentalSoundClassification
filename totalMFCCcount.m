function [count] =totalMFCCcount(scp_file)

try
    
fid=fopen(scp_file);
count=0;

while(1)    
    f=fgets(fid);
    if(f<0)
        break;
    end
        % end-1 because the last character is \n
      mfcc_file = fopen(f(1:end-1),'r','ieee-le');
      if(mfcc_file<0)
          disp(strcat('File not opening, file name is:',f(1:end-1)))
        continue;
      end
      
      count = count+fread(mfcc_file,1,'int32');
      
      fclose(mfcc_file);
end


fclose(fid);
catch e
    error(e)
end
    