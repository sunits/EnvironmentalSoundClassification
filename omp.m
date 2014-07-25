% Input signal, matrix
clear all;
close all;

load for_omp.mat

m=60;
n=1000;
% A=randn(m,n);
A=dict;
[m n]=size(A);
% sig = -1+2*rand(m,1);
omega =[];


k=1;
residue(:,k)=sig; %initial residue is signal

% find the matrix colomn most stronlgy correlated to the signal
max_corr.value=0;
max_corr.pos=0;
min_error=0.001;


while(k<1000)
    
%     temp_mat=repmat(residue(:,k),1,size(A,2));
%     
%     for i=1:n
% 
%         temp=sum(abs(A(:,i).*residue(:,k))); % L1 norm
% 
%         if(temp > max_corr.value)
%             max_corr.value=temp
%             max_corr.pos=i
%         end
%     end      

%     kronecker_prod=A.*temp_mat;
%     [junk,max_corr.pos]=max(sum(abs(kronecker_prod)));
%     
    [junk, max_corr.pos]=max(abs(A'*residue(:,k)));

    omega=[omega max_corr.pos];

%     cvx_begin
% 
%         variable y(size(omega,2))
%         minimize(norm(sig-A(:,omega)*y,2));
% 
%     cvx_end
    k=k+1;

%     if(cvx_status =='Solved')
        y = A(:,omega) \ sig;
        x_k=y;
        residue(:,k)=sig-A(:,omega)*x_k;
%     else
    clear y;
    
    max_corr.value=0;
    max_corr.pos=0;
    
    if(max(A'*residue(:,k))<min_error)
        break;
    end
    
end

sparse_vector=zeros(1,n);
sparse_vector(omega)=x_k;
stem(A*sparse_vector','b*')
hold on;
stem(sig,'r');
hold off;

