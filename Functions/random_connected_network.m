function [A,Edges] = random_connected_network(N,E,W,quiet)

% This function generates a random graph that will be fully connected. It
% first generates a random spanning tree of N -1 edges (i.e. a minimum 
% spanning tree). Secondly, it then adds in edges at random until the 
% desired number is generated. 
%
% The random spanning tree is generated uniformly from the set of possible 
% spanning tress. This is done by starting a random walk at a given node. 
% This random walk can travel to any other node. Each time the random walk 
% encounters a new node, an edge is added into the network between the new 
% node and the prvious node. This contnues until all nodes have been
% encountered.
%
% The output network should have properties very close to a random graph.
% Use this code if the network is below the critical threshold 
% (i.e. log(N)/(N)). Otherwise simply generate the network on a
% probabilistic basis (will be faster, especially for larger networks)
%
% This is an impliamentation of the idea described here: https://stackoverflow.com/a/14618505

% Input:        N                   Number of nodes or a network
%               E                   Number of edges or desired density
%               W                   A vector of edge weights (the length of
%                                   the vector must match the number of
%                                   edges requested)
%
% Output:       A                   A fully connected random network

if nargin < 3
    W = [];
    runWeighted = 0;
else
    runWeighted = 1;
end

if nargin < 4
    quiet = 0;
end

if isempty(W)
    runWeighted = 0;
end

if length(N) > 1
    CIJ = N;
    E = nnz(triu(CIJ,1)); 
    N = length(CIJ);
    if max(max(CIJ)) ~= 1
        runWeighted = 1;
        triu_CIJ = triu(CIJ,1);
        W = CIJ(triu_CIJ > 0);
    else
        runWeighted = 0;
    end
else
    if nargin < 3
        W = [];
    end
end

if isempty(W)
    runWeighted = 0;
else
    runWeighted = 1;
end

if E <= 1 && E > 0
    Edges = round(E * ((N^2 - N) /2));
elseif E > 1
    Edges = E;
else
    error('E must be greather than 0')
end

if Edges < N - 1
    error('Unable to make a fully connected network')
end

if runWeighted
    if length(W) ~= Edges
       error('%d edges requested but only %d weights were supplied',Edges,length(W)) 
    end
end

Nodes_out_of_MST = 1:N;

current_node = randi(N,1);

Nodes_out_of_MST(current_node) = [];

MST = zeros(N);
reverseStr = '';
Nodes_left = N - 1;
while ~isempty(Nodes_out_of_MST)
    Nei = 1:N;

    Nei(current_node) = [];
    next_node = Nei(randi(N-1,1));
    
    if ismember(next_node,Nodes_out_of_MST)
        MST(current_node,next_node) = 1;
        MST(next_node,current_node) = 1;
        ind = Nodes_out_of_MST == next_node;
        Nodes_out_of_MST(ind) = [];
        Nodes_left = Nodes_left - 1;
    end
    if ~quiet
        msg = sprintf('%d/%d nodes still to be assigned to MST\n', Nodes_left, N);
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
    end
    current_node = next_node;      
end

r = rand(N) + MST;
R = triu(r,1) + triu(r,1)';

rvec = sort(triu2vec(r,1),'descend');

cutoff = rvec(Edges);

A = double(R >= cutoff);

if runWeighted

    triuA = triu(A,1);
    
    [~,rand_ord] = sort(rand(E,1));

    W_randord = W(rand_ord);

    triuA(triuA == 1) = W_randord;

    A = triuA + triuA';

end

end

function vec = triu2vec(mat,k)
    UT = triu(mat,k);
    nanmat = nan(size(mat));
    nanLT = tril(nanmat,k-1);
    UT_with_nans = UT + nanLT; 
    vec = UT_with_nans(:);
    vec(isnan(vec)) = [];
end