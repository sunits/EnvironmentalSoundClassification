function[frequency,scale,dict]=gabor_atoms(atom_length)

phi=30*pi/180;
t=0:atom_length-1;
u=[0 64 128 192];
p=1:8;
s=2.^p;
i=1:35;
%f=0.5*35^(2.6)*i.^(-2.6);
%% trying a different wrapping

% 10K is the max frequency i should nbe worried about
f=10000*(1000).^(-1./i);

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
       plot(gaussian_tone)
%        pause(0.3)
%        f(f_index)
%        s(s_index)
        end
    end
end