function com_bet = communicability_betweenness(adj,parallel)
    
    n = length(adj);
    if max(max(adj)) ~= 1
        S = diag(sum(adj,2));
        A = (S^-.5)*adj*(S^-.5);
        G = expm(A);
    else
        G = expm(adj);
        A = adj;
    end
    C = (n-1)^2 - (n-1);
    
    if parallel
        tic
        com_bet = cell(n,1);
        parfor r = 1:n
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
        toc
    else  
%         tic
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
