function Q = modularity_q(A,c)

n = length(A);
k = sum(A);
m = sum(k);
B = A - (k.'*k)/m;
s=c(:,ones(1,n));
Q=~(s-s.').*B/m;
Q=sum(Q(:));