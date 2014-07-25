

clc;
clear all;

new_mfcc_dir='blackman_sub_band_1K_15_dict_unwgt';
new_mfcc_dir1='blackman_sub_band_1K_15_dict_wgt';
number_of_sub_bands=15; 


 
 send_mail(strcat('Starting to build sets ',new_mfcc_dir),''); 
build_other_sets;
 
 send_mail(strcat('Starting GMM build ',new_mfcc_dir),''); 
build_gmm;
 
 send_mail(strcat('Testing GMM',new_mfcc_dir),'Accuracy should come soon'); 
test_gmm;

acc=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
subject=strcat('Accuracy of ',new_mfcc_dir);
content=strcat(num2str(acc));
send_mail(subject,content);

new_mfcc_dir=new_mfcc_dir1;
 
 send_mail(strcat('Starting GMM build ',new_mfcc_dir),''); 
build_gmm;
 
 send_mail(strcat('Testing GMM',new_mfcc_dir),'Accuracy should come soon'); 
test_gmm;
acc=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
subject=strcat('Accuracy of ',new_mfcc_dir);
content=strcat(num2str(acc));
send_mail(subject,content);





%clc;
%clear all;
%
%new_mfcc_dir='hann_sub_band_1K_10_dict_unwgt';
%new_mfcc_dir1='hann_sub_band_1K_10_dict_wgt';
%number_of_sub_bands=10; 
%
% 
% send_mail(strcat('Starting to build sets ',new_mfcc_dir),''); 
%build_other_sets;
% 
% send_mail(strcat('Starting GMM build ',new_mfcc_dir),''); 
%build_gmm;
% 
% send_mail(strcat('Testing GMM',new_mfcc_dir),'Accuracy should come soon'); 
%test_gmm;
%
%acc=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
%subject=strcat('Accuracy of ',new_mfcc_dir);
%content=strcat(num2str(acc));
%send_mail(subject,content);
%
%new_mfcc_dir=new_mfcc_dir1;
% 
%%  send_mail(strcat('Starting GMM build ',new_mfcc_dir),''); 
%build_gmm;
% 
% send_mail(strcat('Testing GMM',new_mfcc_dir),'Accuracy should come soon'); 
%test_gmm;
%
%acc=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
%subject=strcat('Accuracy of ',new_mfcc_dir);
%content=strcat(num2str(acc));
%send_mail(subject,content);
% 
% 
% 
% clc;
% clear all;
% 
% new_mfcc_dir='sub_band_1K_cut_var_adj_17_dict_wgt';
% new_mfcc_dir1='sub_band_1K_cut_var_adj_17_dict_unwgt';
% number_of_sub_bands=17; 
% 
% 
%  
%  send_mail(strcat('Starting to build sets ',new_mfcc_dir),''); 
% build_other_sets;
%  
%  send_mail(strcat('Starting GMM build ',new_mfcc_dir),''); 
% build_gmm;
%  
%  send_mail(strcat('Testing GMM',new_mfcc_dir),'Accuracy should come soon'); 
% test_gmm;
% 
% acc=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
% subject=strcat('Accuracy of ',new_mfcc_dir);
% content=strcat(num2str(acc));
% send_mail(subject,content);
% 
% new_mfcc_dir=new_mfcc_dir1;
%  
%  send_mail(strcat('Starting GMM build ',new_mfcc_dir),''); 
% build_gmm;
%  
%  send_mail(strcat('Testing GMM',new_mfcc_dir),'Accuracy should come soon'); 
% test_gmm;
% 
% acc=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
% subject=strcat('Accuracy of ',new_mfcc_dir);
% content=strcat(num2str(acc));
% send_mail(subject,content);
% 
% 
% clc;
% clear all;
% 
% new_mfcc_dir='sub_band_1K_cut_var_adj_18_dict_wgt';
% new_mfcc_dir1='sub_band_1K_cut_var_adj_18_dict_unwgt';
% number_of_sub_bands=18; 
% 
%  
%  send_mail(strcat('Starting to build sets ',new_mfcc_dir),''); 
% build_other_sets;
%  
%  send_mail(strcat('Starting GMM build ',new_mfcc_dir),''); 
% build_gmm;
%  
%  send_mail(strcat('Testing GMM',new_mfcc_dir),'Accuracy should come soon'); 
% test_gmm;
% 
% acc=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
% subject=strcat('Accuracy of ',new_mfcc_dir);
% content=strcat(num2str(acc));
% send_mail(subject,content);
% 
% new_mfcc_dir=new_mfcc_dir1;
% 
%  
%  send_mail(strcat('Starting GMM build ',new_mfcc_dir),''); 
% build_gmm;
%  
%  send_mail(strcat('Testing GMM',new_mfcc_dir),'Accuracy should come soon'); 
% test_gmm;
% 
% acc=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
% subject=strcat('Accuracy of ',new_mfcc_dir);
% content=strcat(num2str(acc));
% send_mail(subject,content);
% 
% 
% 
% clc;
% clear all;
% 
% new_mfcc_dir='sub_band_1K_cut_var_adj_19_dict_wgt';
% new_mfcc_dir1='sub_band_1K_cut_var_adj_19_dict_unwgt';
% number_of_sub_bands=19; 
% 
% 
%  
%  send_mail(strcat('Starting to build sets ',new_mfcc_dir),''); 
% build_other_sets;
%  
%  send_mail(strcat('Starting GMM build ',new_mfcc_dir),''); 
% build_gmm;
%  
%  send_mail(strcat('Testing GMM',new_mfcc_dir),'Accuracy should come soon'); 
% test_gmm;
% 
% acc=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
% subject=strcat('Accuracy of ',new_mfcc_dir);
% content=strcat(num2str(acc));
% send_mail(subject,content);
% 
% 
% new_mfcc_dir=new_mfcc_dir1;
%  
%  send_mail(strcat('Starting GMM build ',new_mfcc_dir),''); 
% build_gmm;
%  
%  send_mail(strcat('Testing GMM',new_mfcc_dir),'Accuracy should come soon'); 
% test_gmm;
% 
% acc=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
% subject=strcat('Accuracy of ',new_mfcc_dir);
% content=strcat(num2str(acc));
% send_mail(subject,content);
% 
% 
% 
% clc;
% clear all;
% 
% new_mfcc_dir='sub_band_1K_cut_var_adj_22_dict_wgt';
% new_mfcc_dir1='sub_band_1K_cut_var_adj_22_dict_unwgt';
% number_of_sub_bands=22; 
% 
%  
%  send_mail(strcat('Starting to build sets ',new_mfcc_dir),''); 
% build_other_sets;
%  
%  send_mail(strcat('Starting GMM build ',new_mfcc_dir),''); 
% build_gmm;
%  
%  send_mail(strcat('Testing GMM',new_mfcc_dir),'Accuracy should come soon'); 
% test_gmm;
% 
% acc=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
% subject=strcat('Accuracy of ',new_mfcc_dir);
% content=strcat(num2str(acc));
% send_mail(subject,content);
% 
% new_mfcc_dir=new_mfcc_dir1;
%  
%  send_mail(strcat('Starting GMM build ',new_mfcc_dir),''); 
% build_gmm;
%  
%  send_mail(strcat('Testing GMM',new_mfcc_dir),'Accuracy should come soon'); 
% test_gmm;
% 
% 
% acc=sum(diag(final_confusion_mat))/sum(sum(final_confusion_mat))*100;
% subject=strcat('Accuracy of ',new_mfcc_dir);
% content=strcat(num2str(acc));
% send_mail(subject,content);
% 
% 
