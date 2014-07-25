#get all mfcc into a file
ls *.m > all_mfc.scp

# create a list file - For GMM it must contain only the word gmm
echo gmm > gmm.list

# create an MLF file
echo "\"*.lab\"" >> gmm.mlf
echo gmm
echo .

