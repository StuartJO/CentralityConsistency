function [centrality,Q,centrality_names,centrality_names_abbrev] = runCentrality(Network,invweighted,runparallel,quiet)

% This script runs a number of different centrality measures for a network
% or set of networks.
%
% Input:                   Network = an adjacency matrix or a cell where
%                                    each cell is an adjacency matrix or a
%                                    3D matrix where the third dimension is
%                                    an individual network
%                      invweighted = for weighted networks, invert the
%                                    weights (no effect on unweighted)
%                      runparallel = run in parallel if set to 1 (default
%                                    is 0). Usefully when you have very
%                                    large networks (> 1000 nodes)
%
% Output:               centrality = matrix of centrality scores or a cell
%                                    array where each cell contains a 
%                                    matrix of centrality scores
%                                Q = the Q value for the modularity of the
%                                    network
%                 centrality_names = name of each centrality measure   
%          centrality_names_abbrev = abbreviated name of each centrality 
%                                    measure 
%
% The script will detect if the network is unweighted or weighted so it 
% should be in that format before being passed to this function. 
%
% Stuart Oldham, Monash University, 2018

if nargin < 2
    invweighted = 0;
end

if nargin < 3
    runparallel = 0;
end

if nargin < 4
    quiet = 0;
end

if ~iscell(Network)
    [x,y,z] = size(Network);
    if z > 1
        NetCell = squeeze(mat2cell(Y, x, y,[1 1 1]));
    else
        NetCell{1} = Network; 
    end
else
    NetCell = Network;
end

NumNets = length(NetCell);
Q = zeros(1,NumNets);
if NumNets > 2
    centrality = cell(1,NumNets);
end
    
for i = 1:NumNets
    adj = Network{i};
    NumNodes = length(adj);
    c = zeros(15,NumNodes);
    if invweighted
       adj_inv = 1./adj;
       adj_inv(adj_inv == inf) = 0;
    else
        adj_inv = adj;
    end
    
    if max(max(adj)) ~= 1
        weighted = 1;
    else
        weighted = 0;
    end
    
    c(1,:) = strengths_und(adj);
    c(2,:) = betweenness_wei(adj_inv); 
    c(3,:) = eigenvector_centrality_und(adj); 
    c(4,:) = pagerank_centrality(adj,.85);
    c(5,:) = closeness_wei(adj_inv);
    c(6,:) = diag(communicability(adj,weighted,'network'));
    c(7,:) = random_walk_centrality(adj); 
    c(8,:) = h_index(adj); 
    c(9,:) = leverage_centrality(adj);
    c(10,:) = information_centrality(adj); 
    c(11,:) = katz_centrality(adj);
    c(12,:) = communicability(adj,weighted,'nodal'); 
    c(13,:) = random_walk_betweenness(adj,runparallel); 
    c(14,:) = communicability_betweenness(adj,runparallel); 
    [M, c(15,:)] = run_modularity(adj,50,.4);
    
    % The Q value is calculated on the consensus partition
    
    Q(i) = modularity_q(adj,M);
    
    if NumNets > 2
        centrality{i} = c;
        if ~quiet
           fprintf('Completed centrality analysis of network %d\n',i) 
        end
    else
        centrality = c;
    end
end

centrality_names{1} = 'strength'; centrality_names_abbrev{1} = 'DC';
centrality_names{2} = 'betweenness'; centrality_names_abbrev{2} = 'BC';
centrality_names{3} = 'eigenvector'; centrality_names_abbrev{3} = 'EC';
centrality_names{4} = 'pagerank'; centrality_names_abbrev{4} = 'PR'; 
centrality_names{5} = 'closeness'; centrality_names_abbrev{5} = 'CC'; 
centrality_names{6} = 'subgraph'; centrality_names_abbrev{6} = 'SC'; 
centrality_names{7} = 'random-walk closeness'; centrality_names_abbrev{7} = 'RWCC'; 
centrality_names{8} = 'h-index'; centrality_names_abbrev{8} = 'HC'; 
centrality_names{9} = 'leverage'; centrality_names_abbrev{9} = 'LC'; 
centrality_names{10} = 'information'; centrality_names_abbrev{10} = 'IC'; 
centrality_names{11} = 'katz'; centrality_names_abbrev{11} = 'KC';
centrality_names{12} = 'total communicability'; centrality_names_abbrev{12} = 'TCC';
centrality_names{13} = 'random-walk betweenness'; centrality_names_abbrev{13} = 'RWBC';
centrality_names{14} = 'communicability betweenness'; centrality_names_abbrev{14} = 'CBC';
centrality_names{15} = 'participation coefficient'; centrality_names_abbrev{15} = 'PC';
