plotPieceWiseCurves;
low_f=C*([1:35]).^(2.62); 
high_f=0.5*(1000).^(-1./[1:35]);
hold on
plot(low_f,'r-^');
plot(high_f);
grid on;
xlabel('index(i)');
ylabel('Frequency, \omega (\times \pi)');
set(gca, 'Position', get(gca, 'OuterPosition') - get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);

legend('Casino','Ocean','Low frequency','High Frequency');

