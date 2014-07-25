
clc
clear all
a=1;
n=3;
b=.8;
f=10;
phi=30*pi/180;
t=linspace(0,255,256);
u=[0 64 128 192];
p=1:8;
s=2.^p;
i=1:35;
f=0.5*35^(-2.6)*i.^(2.6);
count=0;
dict=zeros(length(t),length(s)*length(f)*length(u));

for u_index=1:length(u)
    for s_index=1:length(s)
        for f_index=1:length(f)

    count=count+1;
% gamma=a*t.^(n-1).*exp(-2*pi*b*t);
gaussian=exp(-pi*((t-u(u_index))/s(s_index)).^2);
tone=cos(2*pi*f(f_index)*(t-u(u_index))+phi);
gaussian_tone=gaussian.*tone/sqrt(s(s_index));
gaussian_tone=gaussian_tone/norm(gaussian_tone,2);
dict(:,count)=gaussian_tone;
%In freq domain
% gaussian_tone_f=fft(gaussian_tone);
% 
% % figure;
% subplot(411)
% plot(gaussian);
% title('gaussian function');
% 
% subplot(412)
% plot(tone);
% title('Tone');
% 
% subplot(413)
% plot(gaussian_tone);
% title('gaussiantone');
% 
% 
% subplot(414)
% plot(abs(gaussian_tone_f));
% title(strcat(num2str(s_index),num2str(f_index),num2str(u_index)))
% 
% pause(.3)

        end
    end
end
        
    
