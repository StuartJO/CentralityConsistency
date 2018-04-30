function [M, P, Q] = run_modularity(adj,nMod,tau)

for i = 1:nMod

    [M_temp(:,i) Q(i)] = community_louvain(adj);
    %fprintf('Completed %d\n',i)
end

D = agreement_weighted(M_temp,Q);

M = consensus_und(D,tau,nMod);
P = participation_coef(adj,M);