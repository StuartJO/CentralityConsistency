function [centrality,Q,centrality_names,centrality_names_abbrev] = runCentrality(Network,invweighted,runparallel)

if nargin < 2
    invweighted = 0;
end

if nargin < 3
    runparallel = 0;
end

if ~iscell(Network)
    [x,y,z] = size(Network);
    if z > 1
        NetCell = squeeze(mat2cell(Y, x, y,[1 1 1]));
    else
        NetCell{1} = Network; 
    end
end

NumNets = length(NetCell);
Q = zeros(NumNets);
if NumNets > 2
    centrality = cell(1,NumNets);
end
    
for i = 1:length(NumNets)
    adj = Network{1};
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
    Q(i) = modularity_q(adj,M);
    if NumNets > 2
        centrality{i} = c;
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
