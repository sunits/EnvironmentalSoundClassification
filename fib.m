function [next]=fib(n,prev,prev_prev)


if(nargin==1)
    prev=1;
    prev_prev=0;
end

next=prev+prev_prev;

prev_prev=prev;
prev=next;

n=n-1;
if(n>1)
    next=fib(n,prev,prev_prev);
end

