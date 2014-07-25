#!/usr/bin/csh/
# The path must be obtained from the environmental variable set by (MATLAB?)
#set GMMDIR="/media/885C28DA5C28C532/sound_data/ocean/1/unwgt_mfcc"
set BASEFOLDER="/media/885C28DA5C28C532/Dropbox/code/htk"
mkdir $GMMDIR/gmm13
#To build the first gaussian model 
# Builds a  GM from all MFCC listed in all_mfc.scp uses structure from proto.3 and  outputs data into gmmdef 
echo $GMMDIR
HCompV -T 2 -C $BASEFOLDER/HListConfig -o $GMMDIR/gmmdef -f 0.01 -m -S $GMMDIR/all_mfc.scp -M $GMMDIR $BASEFOLDER/proto.3_12
mv $GMMDIR/gmmdef $GMMDIR/gmm13/
mv $GMMDIR/vFloors $GMMDIR/gmm13/

# now start building mixtures

#----Step1: Build a model file ----#
gawk '(NR>4){printf("%s\n",$0);}' $GMMDIR/gmm13/gmmdef > $GMMDIR/gmm13/gmmcore
head -3 $GMMDIR/gmm13/gmmdef >  $GMMDIR/gmm13/models
cat $GMMDIR/gmm13/vFloors    >> $GMMDIR/gmm13/models
echo '~h "'gmm'"'           >> $GMMDIR/gmm13/models
cat $GMMDIR/gmm13/gmmcore >> $GMMDIR/gmm13/models


#--- Step2: Split up the GMM into required number of models --#

# ********Step2.1: Create a mlf file**********************************************#

echo '#!'MLF!'#' > $GMMDIR/gmm.mlf
echo '"*.'lab'"' >> $GMMDIR/gmm.mlf
echo gmm >> $GMMDIR/gmm.mlf
echo '.' >> $GMMDIR/gmm.mlf


# ********Step2.2: Create a list file**********************************************#

echo gmm > $GMMDIR/gmm.list

# ********Step2.3: Now do the dirty work**********************************************#


#-- delete  previously constructed GMMs --#
#$MODALS is the env variable set from the calling program like matlab
@ n=2
echo 'Enter'
while($n <= $MODALS)

  echo "Trainig $n gaussian models: from gmm{$n}0 to gmm{$n}3 ..."
  @ m = $n - 1
  set gmmorig = $GMMDIR/gmm{$m}3
  set gmmdest = $GMMDIR/gmm{$n}0
 # set log     = $gmmdest/log
  mkdir -p $gmmdest
  echo "MU $n {*.state[2].mix}" > $gmmdest/incgaus.hed
  HHEd -T 1 -H $gmmorig/models -M $gmmdest \
       $gmmdest/incgaus.hed $GMMDIR/gmm.list 

	#Deleting all previous gmm folders
#	rm -r  $gmmorig
 
  foreach j (1 2 3)
    echo "Iteration $j"
    @ i = $j - 1
    set gmmorig = $GMMDIR/gmm{$n}{$i}
    set gmmdest = $GMMDIR/gmm{$n}{$j}
#    set log     = $gmmdest/log
    mkdir -p $gmmdest
    HERest -T 1 -C $BASEFOLDER/HListConfig -H $gmmorig/models -M $gmmdest -I $GMMDIR/gmm.mlf \
             -s $gmmdest/stats \
            -S $GMMDIR/all_mfc.scp $GMMDIR/gmm.list

	#Deleting all previous gmm folders
#	rm -r  $gmmorig
  end


  echo "Modal number $n complete";
@ n +=1;
 end
#Keep a copy of the last model created in the main folder
cp $gmmdest/models $GMMDIR/
echo '------------------A copy of the final Model was saved in -----'$GMMDIR'--------------------------'
