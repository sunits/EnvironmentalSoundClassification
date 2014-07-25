function[freqMean,freqVar,scaleMean,scaleVar,freqMean1,freqVar1,scaleMean1,scaleVar1] = createMPFeature(dict,frequency,scale,sig,wgt,both)

%% Default dictionary
% if(nargin<1)
%     dict='gabor';
% end

% FreqMean1 et al are the wgted components
% FreqMean is the unwgted component

%% Get the dictionary
%Uncomment the line below to build the dictionary. Reconsider building the dictionary in the calling function instead of building the dict every time you call the function

% [frequency,scale,dict]=gabor_atoms(length(sig));


if(size(sig,1)>256)
    error('Dictionary was preloaded to run the code fast and has a dimension of 256x1120. Create a new dictionary and load the appropriate one to proceed');
end




%% Get the indices and wgts from OMP
% As the paper suggests we are using the best 5 atoms in OMP for feature
% extraction
% [indices wgts]=omp_func(dict,sig,5);
[indices wgts]=omp_ksvd(dict,sig,5);

% hack to make sure 0 indices do not enter the computation - All these
% values will be set to zero later on- They should be removed ideally
pos= indices==0;
indices(pos)=1;
wgts(pos)=0;

%% Get frequency and scale for each of the elements

selected_frequency=frequency(indices);
selected_scale=scale(indices);
% disp '-----------------------------------'
selected_frequency(pos)=0;
selected_scale(pos)=0;

%% compute features
% weighed Mean and variance

if(nargin>5)
    [freqMean1,freqVar1,scaleMean1,scaleVar1] = computeMeanVar(selected_frequency,selected_scale,wgts);
    [freqMean,freqVar,scaleMean,scaleVar] = computeMeanVar(selected_frequency,selected_scale);
    return;
end

if(wgt)
    [freqMean,freqVar,scaleMean,scaleVar] = computeMeanVar(selected_frequency,selected_scale,wgts);
else
    [freqMean,freqVar,scaleMean,scaleVar] = computeMeanVar(selected_frequency,selected_scale);
end


