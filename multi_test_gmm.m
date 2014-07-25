
addpath /media/885C28DA5C28C532/Dropbox/code/htk/                                                                                         
matFiles= struct ('name',{ ...
                        'blackman_sub_band_1K_15_dict_unwgt', ...                        
                       'blackman_sub_band_1K_15_dict_wgt'} );
                   
                   

total_mat_files=size(matFiles,2);

for i=1:total_mat_files
    
    new_mfcc_dir=matFiles(i).name;
    test_gmm;
    cd ..;
    save(new_mfcc_dir,'confusion_matrix');   

end
    