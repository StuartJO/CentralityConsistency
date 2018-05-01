function com_bet = communicability_betweenness(adj,parallel)
    
% This function calculates the communicability betweenness for an
% unweighted/weighted network.
%
% Inputs:                             adj = an unweighted/weighted
%                                               adjcency matrix
%                                parallel = set to 1 to use MATLABS
%                                           parallel processing toolbox (if
%                                           installed)
%
% Output:                             b = a vector containing each nodes
%                                           communicability betweenness 
%                                           centrality

if nargin < 2
    parallel = 0;
end

% Check if parallel toolbox is installed
if ~license( 'test', 'Distrib_Computing_Toolbox' )
    warning('Parallel processing toolbox not installed') 
    parallel = 0;
end

% Run communicability betweenness

    n = length(adj);
    
% If weighted calculated the reduced adjacency matrix    
    if max(max(adj)) ~= 1
        S = diag(sum(adj,2));
        A = (S^-.5)*adj*(S^-.5);
        G = expm(A);
    else
        G = expm(adj);
        A = adj;
    end
% Calculate the normalisation parameter    
    C = (n-1)^2 - (n-1);
    
    if parallel
        com_bet = cell(n,1);
        parfor r = 1:n
% Calculate communicability betweenness            
            Er = A;
            Er(r,:) = 0;
            Er(:,r) = 0;
            eAEr = expm(Er);
            com_bet{r} = 0;
            p = [1:r-1 r+1:n];
            q = [1:r-1 r+1:n];
            GprqGpq = (G(p,q) - eAEr(p,q))./G(p,q);  
            com_bet{r} = (sum(sum(GprqGpq))-sum(diag(GprqGpq)))/C;
        end
        com_bet = cell2mat(com_bet);
    else  
% Old code which didn't use matrix methods. Helpful if you want to figure 
% out what is going on        
%
%         com_bet = zeros(n,1);
%         for r = 1:n
%             Er = A;
%             Er(r,:) = 0;
%             Er(:,r) = 0;
% 
%             eAEr = expm(Er);
% 
%             for p = 1:n
%                 for q = 1:n
%                     if p ~= q && p ~= r && q ~= r
%                         Gpq = G(p,q);
%                         Gprq = G(p,q) - eAEr(p,q);
%                         com_bet(r) = com_bet(r) + Gprq/Gpq;
%                     end
%                 end
%             end        
%         end
%         com_bet = com_bet./C;
        com_bet = zeros(n,1);
        for r = 1:n
            Er = A;
            Er(r,:) = 0;
            Er(:,r) = 0;
            eAEr = expm(Er);
            p = [1:r-1 r+1:n];
            q = [1:r-1 r+1:n];
            GprqGpq = (G(p,q) - eAEr(p,q))./G(p,q);       
            com_bet(r) = (sum(sum(GprqGpq))-sum(diag(GprqGpq)))/C;
        end
    end
    
end
