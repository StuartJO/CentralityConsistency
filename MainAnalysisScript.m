% Main analysis script

% This script will rerun all analysis performed in Oldham et al., 2018. 
% Consistency and differences between centrality metrics across distinct 
% classes of networks.

% Running this script as is will be incredible computationally expensive
% and would likely take months running on a single computer. It would
% also require a significant amount of memory. Therefore
% running in parallel on multiple computers is recommended if trying to
% replicate (or use it for your own purposes)

% This code requires dependencies from the Brain Connectivity Toolbox

% Note that subtle differences may result if trying to recalculate the
% centrality measures as the calculation of the participation coefficient
% involves stochastic procedures. This differences will affect the
% correlations and clustering results but the differences will be very
% slight

%% Initial setup
% Define these variables for your own environment and desired parameters
% Define path to the directory of this script
MAINPATH = '../Centrality_code';
% Define path to the directory of the BCT
BCTPATH = 'C:/Users/USER/Documents/MATLAB/BCT/';
% Define the number of nulls to generate
NumNulls = 100;
% Define the number of clusters to calculate
NumClust = 50;

%% Define paths and load networks
% Will load in 3 variables: Networks, a cell array of the networks;
% net_fullName, the name of the network; net_abbrevname, abbreviated
% network name

addpath(genpath(MAINPATH))
addpath(genpath(BCTPATH))

load('Networks.mat')

NumNetworks = length(Networks);
%% Perform centrality measures on each real-world network

% NetworksCent is the centrality scores for each network (stored in a cell)

% NetworksQ is each networks modularity Q index

% cent_names is a cell array containing the name of each centrality measure

% cent_names_abbrev is a cell array containing the abbreviated name of each 
% centrality measure

[NetworksCent,NetworksQ,cent_names,cent_names_abbrev] = runCentrality(Networks,1,1); 

%% Calculate network density, majorization gap and normalise centrality
% scores for clustering

% NormCentAll is the normalised centrality scores for all measures in 
% each network (stored in a cell)
NormCentAll = cell(1,NumNetworks);
% NormCentNoRWCC is the normalised centrality scores for all measures apart 
% from random-walk closeness in each network (stored in a cell)
NormCentNoRWCC = cell(1,NumNetworks);
% NetworksDensity is each networks density
NetworksDensity = zeros(1,NumNetworks);
% NetworksMgap is each networks majorization gap
NetworksMgap = zeros(1,NumNetworks);

for i = 1:NumNetworks
    NormCentAll{i} = BF_NormalizeMatrix(NetworksCent{i}','scaledSigmoid');
    NormCentNoRWCC{i} = NormCentAll{i}(:,[1:6 8:15]);
    NetworksDensity(i) = density_und(Networks{i});
    [~,NetworksMgap(i)] = majorization_gap(Networks{i});
end

%% Create unconstrained nulls for each network. This step also generates the
% majorization gap for the unconstrained networks

% NullNetworks is a cell array where column 1 contains the 
% unconstrained nulls for each respective network and column 2 contains the
% constrained nulls for each respective network (each null is stored as its
% own cell) 

% NullsMgap is a cell array where column 1 contains the majorization gap
% for each unconstrained null for each respective network and column
% 2 contains the majorization gap for each constrained null for each
% respective network (the modularity Q index is stored as a vector) 

% NullNetworksCent is a cell array where column 1 contains the centrality 
% scores for each unconstrained null for each respective network and column
% 2 contains the centrality scores for each constrained null for each
% respective network (and each individual null is also stored in a cell)  

% NullsQ is a cell array where column 1 contains the modularity Q index
% for each unconstrained null for each respective network and column
% 2 contains the modularity Q index for each constrained null for each
% respective network (the modularity Q index is stored as a vector) 

NullNetworks = cell(NumNetworks,2);
NullsMgap = cell(NumNetworks,2);
NullNetworksCent = cell(NumNetworks,2);
NullsQ = cell(NumNetworks,2);

for i = 1:NumNetworks
    Nulls = cell(1,NumNulls);
    Mgap = zeros(1,NumNulls);
    adj = Networks{i};
    for j = 1:NumNulls
        Nulls{j} = random_connected_network(adj,[],[],1);
        [~,Mgap(j)] = majorization_gap(Nulls{j});
    end
    NullsMgap{i,1} = Mgap;
    NullNetworks{i,1} = Nulls;
end
clear Mgap Nulls

%% Create constrained nulls for each network. 
% This step also generates the majorization gap for the constrained 
% networks

for i = 1:NumNetworks
    Nulls = cell(1,NumNulls);
    Mgap = zeros(1,NumNulls);
    adj = Networks{i};
    for j = 1:NumNulls
        Nulls{j} = make_ConstrainedNull(adj);
        [~,Mgap(j)] = majorization_gap(Nulls{j});
    end
    NullsMgap{i,2} = Mgap;
    NullNetworks{i,2} = Nulls;
end

%% Run centrality for the nulls. 
% This also generates modularity for each null

for i = 1:NumNetworks
   for j = 1:2
       [NullNetworksCent{i,j},NullsQ{i,j}] = runCentrality(NullNetworks{i,j},1,1);
       fprintf('Completed %d/2 nulls for network %d/%d\n',j,i,NumNetworks) 
   end
end

%% Perform clustering

% NetworksLinkages is the linkages for each network
NetworksLinkages = cell(1,NumNetworks);
% NetworksCentClustDist is the distance matrix of the clusters for each 
% network
NetworksCentClustDist = cell(1,NumNetworks);
% NetworksCentClusters is a cell array where each cell is a matrix of
% clustering solutions for each network
NetworksCentClusters = cell(1,NumNetworks);
% NetworksDB is a cell array where each cell is the Davies-Bouldin indices
% for each of the identified clusters
NetworksDB = cell(1,NumNetworks);

for i = 1:NumNetworks   
    [NetworksLinkages{i}, NetworksCentClustDist{i}, NetworksCentClusters{i}, NetworksDB{i}] = runCentralityClustering(NormCentNoRWCC{i},50);
end

%% Get correlations, averages and standard deviations

% NetworkProperty is just the different network properties combined into a
% single table
NetworkProperty(:,1) = NetworksDensity';
NetworkProperty(:,2) = NetworksQ';
NetworkProperty(:,3) = NetworksMgap';

% Networks_mwCMC is the mean within-networks CMC for each network
% NullNetworks_mwCMC is the mean within-networks CMC for each null network
Networks_mwCMC = zeros(1,NumNetworks);
NullNetworks_mwCMC = cell(NumNetworks,2);

% NetworksCentCorr is a 3D matrix of the correlation matrices of centrality
% measures for each network (arranged along the third dimension)
% NetworksCentCorrCell is a cell array containing each networks CMCs
NetworksCentCorr = zeros(length(cent_names),length(cent_names),NumNetworks);
NetworksCentCorrCell = cell(1,NumNetworks);

% Calculate the CMCs for each network
for i = 1:NumNetworks
   NetworksCentCorr(:,:,i) = corr(NetworksCent{i}','Type','Spearman'); 
   NetworksCentCorrCell{i} = NetworksCentCorr(:,:,i); 
   Networks_mwCMC(i) = mean(triu2vec(NetworksCentCorrCell{i},1));
    for j = 1:2
        temp = zeros(1,NumNulls);
        for k = 1:NumNulls
            % Note that if for some reason you generate only a single null
            % then the code will get upset with you here because it expects
            % a cell array. The commented line will fix this
            temp(k) = mean(triu2vec(corr(NullNetworksCent{i,j}{k}','Type','Spearman'),1));
            %temp(k) = mean(triu2vec(corr(NullNetworksCent{i,j}','Type','Spearman'),1));
        end   
        NullNetworks_mwCMC{i,j} = temp;
        clear temp
    end
end

% DensityCorrelation is the correlation between network density and mean
% within-network CMC and DensityPval is the associated p value
[DensityCorrelation,DensityPval] = corr(Networks_mwCMC',NetworkProperty(:,1),'Type','Spearman');

% DensityCorrelation2 is the correlation between network density and mean
% within-network CMC when the two outlier networks are removed and 
% DensityPval2 is the associated p value
[DensityCorrelation2,DensityPval2] = corr(Networks_mwCMC([1:7 9:12 14 15])',NetworkProperty([1:7 9:12 14 15],1),'Type','Spearman');

% ModularityCorrelation is the correlation between modularity and mean
% within-network CMC and ModularityPval is the associated p value
[ModularityCorrelation,ModularityPval] = corr(Networks_mwCMC',NetworkProperty(:,2),'Type','Spearman');

% ModularityPartialCorrelation is the partial correlation between 
% modularity and mean within-network CMC controlling for the majorization 
% gap and ModularityPartialPval is the associated p value
[ModularityPartialCorrelation,ModularityPartialPval] = partialcorr([NetworkProperty(:,2) Networks_mwCMC'],NetworkProperty(:,3),'Type','Spearman');
ModularityPartialCorrelation = ModularityPartialCorrelation(1,2);
ModularityPartialPval = ModularityPartialPval(1,2);

% MgapCorrelation is the correlation between the majorization gap and mean
% within-network CMC and MgapPval is the associated p value
[MgapCorrelation,MgapPval] = corr(Networks_mwCMC',NetworkProperty(:,3),'Type','Spearman');

% MgapPartialCorrelation is the partial correlation between the
% majorization gap and mean within-network CMC controlling for modularity
% and ModularityPartialPval is the associated p value
[MgapPartialCorrelation,MgapPartialPval] = partialcorr([NetworkProperty(:,3) Networks_mwCMC'],NetworkProperty(:,2),'Type','Spearman');
MgapPartialCorrelation = MgapPartialCorrelation(1,2);
MgapPartialPval = MgapPartialPval(1,2);

% Get the mean between-network CMC's and between-network CMC standard
% deviations across all networks
mean_corr_all = mean(NetworksCentCorr,3);
var_corr_all = var(NetworksCentCorr,0,3);

% Get the index of unweighted networks (unweighted_network_inds) and 
% weighted networks (weighted_network_inds)

unweighted_network_inds = [1:10 14];

weighted_network_inds = [11:13 15];

% Get the mean between-network CMC's and between-network CMC standard
% deviations across all unweighted networks
mean_corr_bin = mean(NetworksCentCorr(:,:,unweighted_network_inds),3);
var_corr_bin = std(NetworksCentCorr(:,:,unweighted_network_inds),0,3);

% Get the mean between-network CMC's and between-network CMC standard
% deviations across all weighted networks
mean_corr_wei = mean(NetworksCentCorr(:,:,weighted_network_inds),3);
var_corr_wei = std(NetworksCentCorr(:,:,weighted_network_inds),0,3);

% BinMeanVarCorrelation is the correlation between between-network CMC mean
% and standard deviation in unweighted networks and BinMeanVarPval is the
% associated p value
[BinMeanVarCorrelation, BinMeanVarPval] = corrcoef(triu2vec(mean_corr_bin,1),triu2vec(var_corr_bin,1));

% WeiMeanVarCorrelation is the correlation between between-network CMC mean
% and standard deviation in weighted networks and WeiMeanVarPval is the
% associated p value
[WeiMeanVarCorrelation, WeiMeanVarPval] = corrcoef(triu2vec(mean_corr_wei,1),triu2vec(var_corr_wei,1));

%% Get the ordering of centrality measures for figures 2 and 3

cent_ind = BF_ClusterReorder(mean_corr_all,'corr');

clear i j k

% Note if trying to save output you will likely need the -v7.3 flag if you
% have generated a large number of nulls