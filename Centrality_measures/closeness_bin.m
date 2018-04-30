function c = closeness_bin(A,alt)

if nargin < 2
    alt = 0;
end

bin = double(A > 0);
n = length(bin);

if ~alt
    c = n./sum(distance_bin(bin));
else
    c = nodal_efficiency(A);
end

end