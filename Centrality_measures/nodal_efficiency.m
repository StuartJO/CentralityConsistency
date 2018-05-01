function [Enod,d] = nodal_efficiency(adj)

% Calculates nodal efficiency using the Brain Connectivity Toolbox
% functions

d = distance_wei(adj);
N = length(adj);

Enod = sum(1./d) ./ (N-1);

end