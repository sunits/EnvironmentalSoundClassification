function [indices,wgts]=omp_ksvd(D,X,L); 
%=============================================
% Sparse coding of a group of signals based on a given 
% dictionary and specified number of atoms to use. 
% input arguments: 
%       D - the dictionary (its columns MUST be normalized).
%       X - the signals to represent
%       L - the max. number of coefficients for each signal.
% output arguments: 
%       A - sparse coefficient matrix.
%=============================================
[n,P]=size(X);
[n,K]=size(D);

indices=zeros(L,P);
wgts=zeros(L,P);

for k=1:1:P,
    a=[];
    x=X(:,k);
    
    %had some problems with x being all 0's
    if(x==0)
        indices(:,k)=zeros(L,1);
        wgts(:,k)=zeros(L,1);
        continue;
    end
        
    residual=x;
    indx=zeros(L,1);
    for j=1:1:L,
        proj=D'*residual;
        [~,pos]=max(abs(proj));
        pos=pos(1);
        indx(j)=pos;
        a=pinv(D(:,indx(1:j)))*x;
        residual=x-D(:,indx(1:j))*a;
        if sum(residual.^2) < 1e-6
            break;
        end
    end;
%     temp=zeros(K,1);
%     temp(indx(1:j))=a;
    indices(1:j,k)=indx(1:j);
    wgts(1:j,k)=a;
    
    %just in case
    
    indices(j:L,k)=indices(j,k);
    wgts(j:L,k)=wgts(j,k);
    
%     A(:,k)=sparse(temp);
end;
return;
