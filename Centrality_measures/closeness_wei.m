function c = closeness_wei(A,invert,alt)

if nargin < 2
    invert = 0;
end

if nargin < 3
    alt = 0;
end

n = length(A);
if invert && ~alt
    c = n./sum(distance_wei(1./A));
elseif ~invert && ~alt
    c = n./sum(distance_wei(A));
elseif invert && alt
    c = nodal_efficiency(1./A);
end

end