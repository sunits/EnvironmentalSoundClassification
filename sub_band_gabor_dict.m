function[frequency,scale,dict]= sub_band_gabor_dict(atom_length,band_energies,fs)


% fs corresponds to 2pi
phi=0;
t=0:atom_length-1;
u=[0 64 128 192];
p=1:8;
s=2.^p;
freq_blocks=35;
max_freq=fs/2;


number_of_bands=size(band_energies,2);

%f=0.5*35^(2.6)*i.^(-2.6);
%% trying a different wrapping
%normalize band energy
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

% if rounding decreases the atoms assign more atoms to the band which has
% max energy

while(sum(bands)<freq_blocks)
    [j,pos]=max(bands);
    bands(pos)=bands(pos)+1;
end

    
    



boundaries=linspace(0,max_freq,number_of_bands+1); % +1 because of external boundaries
f=[];

for i=1:number_of_bands              
                
%                 temp=linspace(boundaries(i),boundaries(i+1),bands(i)+1);
%                 f=[f temp(2:end)];
%                 
%                 Other methods
%                 temp=(temp+[temp(2:end) 0])/2;
%                 temp=temp(1:end-1);                
%                 f=[f temp];

%                 f=[f linspace(boundaries(i),boundaries(i+1),bands(i))];
                
                
                temp=linspace(boundaries(i),boundaries(i+1),bands(i));
                if(numel(temp)<1)
                    continue;
                end
                if(numel(temp)>1)
                    temp(1)= (temp(1)+temp(2))/2 ;
                end
                f=[f temp];
                
end


% 10K is the max frequency i should nbe worried about
% f=10000*(1000).^(-1./i);

%% --------------------------------

%% -------------------------------
count=0;
dict=zeros(length(t),length(s)*length(f)*length(u));

frequency=zeros(1,length(s)*length(f)*length(u));
scale=zeros(1,length(s)*length(f)*length(u));
for u_index=1:length(u)
    for s_index=1:length(s)
        for f_index=1:length(f)
        
        count=count+1;
        gaussian=exp(-pi*((t-u(u_index))/s(s_index)).^2);
        tone=cos(2*pi*f(f_index)*(t-u(u_index))+phi);
        gaussian_tone=gaussian.*tone/sqrt(s(s_index));
        gaussian_tone=gaussian_tone/norm(gaussian_tone,2);
        dict(:,count)=gaussian_tone;
        frequency(count)=f(f_index);
        scale(count)=s(s_index);
        
        end
    end
end