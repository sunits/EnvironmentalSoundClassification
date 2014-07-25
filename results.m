x=[4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22];
wgt=[83.79 89.1725  85.218 92.81 91.29 91.47 92.03 92.06 93.5568 92.18 88.67 95.607 92.92 93.29  93.75 93.47 93.59 91.53 92.98]
unwgt=[84.35 85.09 83.37 92.84 90.45 89.01 92.039 90.5884 92.87 90.49 89.381 92.67 92.45 93.07 92.08 93.31 91.74  90.92 91.72];
compare=[ unwgt' wgt'];

bar(x,compare);
grid on;
% title('Ten Fold accuracy comparison')
xlabel('Number of Sub Bands');
ylabel('Accuracy');
legend('Unweighted','Weighted');

set(gcf, 'renderer', 'painters');
print(gcf, '-depsc2', 'results.eps');