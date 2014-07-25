a=1;
N=2;

b=1;
v=4;
%Center frequencies
f=linspace(20,20000,50);
phi=0;

ERB=24.7+0.108*f;
ERBS=21.4*log10(0.00437*f+1);
lambda=2*pi*b*ERB;
lambdas=2*pi*b*ERBS;
n=0:255;

for b=0.01:0.05
    lambda=2*pi*b*ERB;
lambdas=2*pi*b*ERBS;

gamma=a*(n.^(v-1)).*exp(-lambdas(end).*n).*cos(2*pi*f(end)*n);
% plot(gamma);
plot(lambdas);
figure;periodogram(gamma)
pause(0.3)
end
%
%t=0:255;
%for b_index=1:length(b)
%    for f_index=1:length(f)
%        for u_index=1:length(u)
%    
%
%
%gamma=a*(t-u(u_index)).^(N-1).*exp(-2*pi*b(b_index)*(t-u(u_index)));
%% f=0.5*35^(2.6)*f^(-2.6);
%tone=cos(2*pi*f(f_index)*(t-u(u_index))+phi);
%gamma_tone=gamma.*tone;
%gamma_tone=gamma_tone/norm(gamma_tone,2); % this is the actual value of a
%%In freq domain
%gamma_tone_f=fft(gamma_tone);
%% figure;
%subplot(411)
%plot(gamma);
%title('Gamma function');
%
%subplot(412)
%plot(tone);
%title('Tone');
%
%subplot(413)
%plot(gamma_tone);
%title('Gammatone');
%
%% freq=linspace(0,fs,length(t));
%subplot(414)
%plot(abs(gamma_tone_f));
%title(strcat('Gammatone in freq domain '));
%
%pause(.3)
%
%        end
%    end
%end
