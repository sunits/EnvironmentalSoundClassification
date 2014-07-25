%% Author  - Sunit Sivasankaran 
%% mail : me@sunits.in
%% function description
% omp_func takes the dictioanry A,
% signal sig and the maximum required atoms 
% (you can also tweak the code for maximum residue energy as criteria instead of K)
% Returns the  indices and corresponding values in the sparse vector

function [omega,wgt]=omp_func(A,sig,K)

[m n]=size(A);
sig=reshape(sig,[],1);
% sig = -1+2*rand(m,1);
omega =[];
wgt=[];

k=1;
residue(:,k)=sig; %initial residue is signal

% find the matrix colomn most stronlgy correlated to the signal
max_corr.value=0;
max_corr.pos=0;
min_error=0.00; % Set this to zero if you are not bothered abt error


while(k<=K)
    
    [max_corr.value, max_corr.pos]=max(abs(A'*residue(:,k)));
    
    omega=[omega max_corr.pos];
    wgt=[wgt max_corr.value];
    

    k=k+1;


    y = A(:,omega) \ sig;
    x_k=y;
    residue(:,k)=sig-A(:,omega)*x_k;

    clear y;
    
    max_corr.value=0;
    max_corr.pos=0;
    
    if(max(A'*residue(:,k))<min_error)
        break;
    end
    
end

sparse_vector=zeros(1,n);
sparse_vector(omega)=x_k;
end
