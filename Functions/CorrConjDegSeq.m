function [dk,d] = CorrConjDegSeq(degseq)
d = sort(degseq,'descend');
n = length(d);
dk = zeros(1,n);
for k = 1:n
   dk(k) = sum(d(1:k - 1) >= k-1) + sum(d(k+1:n) >= k);
end