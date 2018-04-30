function cinf = information_centrality(A,type)

if nargin < 2
    type = 0;
end

% Obtain the number of nodes
n = length(A);

% Create a diagonal matrix where the value D(i,i) is the degree of node i 
D = diag(sum(A,2));

L = D-A;
J = ones(n);

C = (L + J)^-1;

switch type
    case 1
        cinf = 1./diag(C);
    case 0
        Cdiag = diag(C);
        T = sum(Cdiag);
        RR = sum(C,2);
        cinf = (Cdiag(1:n) + (T - 2*RR(1:n))./n).^-1;
%         T = sum(diag(C));
%         cinf = zeros(n,1);
%         for u = 1:n
%             R = sum(C(u,:));
%             cinf(u) = inv(C(u,u) + (T - 2*R)/n);
%         end
end

end