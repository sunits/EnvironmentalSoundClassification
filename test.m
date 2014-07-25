N=1000;
sb=4;
overlap=0.56;
l=floor(N/((1-overlap)*(sb-1)+1));

figure;
for i=1:sb
window=zeros(1,N);
start=ceil(1+(i-1)*l*(1-overlap));
window(start:start+l-1)=hann(l);
plot(window);
hold on;
end

hold off;

figure;
shifts=floor(0.44*N);
l=floor(N-(sb-1)*shifts);

for i=1:sb
window=zeros(1,N);
start=ceil(1+(i-1)*shifts);
window(start:start+l-1)=hann(l);
plot(window);
hold on;
end
