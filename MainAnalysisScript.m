% Main analysis script

% This script will rerun all analysis performed in

% Running this script as is will be incredible computationally expensive
% and would likely take months running on a single computer. It would
% also require a significant amount of memory. Therefore
% running in parallel on multiple computers is recommended if trying to
% replicate (or use it for your own purposes)

% This code requires dependencies from the Brain Connectivity Toolbox


% Note that subtle differences may result if trying to recalculate the
% centrality measures as the calculation of the participation coefficient
% involves stochastic procedures
%% Initial setup
% Define these variables for your own environment and desired parameters
% Define path to the directory of this script
MAINPATH = 'C:/Users/Stuart/Dropbox/PhD/Centrality_code';
% Define path to the directory of the BCT
BCTPATH = 'C:/Users/Stuart/Documents/MATLAB/BCT/';
% Define the number of nulls to generate
NumNulls = 100;
% Define the number of clusters to calculate
numclust = 50;

%% Define paths and load networks
% Will load in 3 variables: Networks, a cell array of the networks;
% net_fullName, the name of the network; net_abbrevname, abbreviated
% network name

addpath(genpath(MAINPATH))
addpath(genpath(BCTPATH))

load('Networks.mat')

NumNetworks = length(Networks);
%% Perform centrality measures on each real-world network

[NetworksCent,NetworksQ,cent_names,cent_names_abbrev] = runCentrality(Networks,1,1); 

%% Calculate network density, majorization gap and normalise centrality
% scores for clustering

% NormCentAll is the normalised centrality scores for all measures in 
% each network
NormCentAll = cell(1,NumNetworks);
% NormCentNoRWCC is the normalised centrality scores for all measures apart 
% from random-walk closeness in each network
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

NetworksLinkages = cell(1,NumNetworks);
NetworksCentClustDist = cell(1,NumNetworks);
NetworksCentClusters = cell(1,NumNetworks);
NetworksDB = cell(1,NumNetworks);

for i = 1:NumNetworks   
    [NetworksLinkages{i}, NetworksCentClustDist{i}, NetworksCentClusters{i}, NetworksDB{i}] = runCentralityClustering(NormCentNoRWCC{i});  
end

%% Get correlations, averages and standard deviations

M(:,1) = NetworksDensity';
M(:,2) = NetworksQ';
M(:,3) = NetworksMgap';

Networks_mwCMC = zeros(1,NumNetworks);
NullNetworks_mwCMC = cell(NumNetworks,2);

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
            temp(k) = mean(triu2vec(corr(NullNetworksCent{i,j}{k}','Type','Spearman'),1));
        end   
        NullNetworks_mwCMC{i,j} = temp;
        clear temp
    end
end

% DensityCorrelation is the correlation between network density and mean
% within-network CMC and DensityPval is the associated p value
[DensityCorrelation,DensityPval] = corr(Networks_mwCMC',M(:,1),'Type','Spearman');

% DensityCorrelation2 is the correlation between network density and mean
% within-network CMC when the two outlier networks are removed and 
% DensityPval2 is the associated p value
[DensityCorrelation2,DensityPval2] = corr(Networks_mwCMC([1:7 9:12 14 15])',M([1:7 9:12 14 15],1),'Type','Spearman');

% ModularityCorrelation is the correlation between modularity and mean
% within-network CMC and ModularityPval is the associated p value
[ModularityCorrelation,ModularityPval] = corr(Networks_mwCMC',M(:,2),'Type','Spearman');

% ModularityPartialCorrelation is the partial correlation between 
% modularity and mean within-network CMC controlling for the majorization 
% gap and ModularityPartialPval is the associated p value
[ModularityPartialCorrelation,ModularityPartialPval] = partialcorr([M(:,2) Networks_mwCMC'],M(:,3),'Type','Spearman');
ModularityPartialCorrelation = ModularityPartialCorrelation(1,2);
ModularityPartialPval = ModularityPartialPval(1,2);

% MgapCorrelation is the correlation between the majorization gap and mean
% within-network CMC and MgapPval is the associated p value
[MgapCorrelation,MgapPval] = corr(Networks_mwCMC',M(:,3),'Type','Spearman');

% MgapPartialCorrelation is the partial correlation between the
% majorization gap and mean within-network CMC controlling for modularity
% and ModularityPartialPval is the associated p value
[MgapPartialCorrelation,MgapPartialPval] = partialcorr([M(:,3) Networks_mwCMC'],M(:,2),'Type','Spearman');
MgapPartialCorrelation = MgapPartialCorrelation(1,2);
MgapPartialPval = MgapPartialPval(1,2);

% Get the mean between-network CMC's and between-network CMC standard
% deviations across all networks
mean_corr_all = mean(NetworksCentCorr,3);
var_corr_all = var(NetworksCentCorr,0,3);

% Get the index of unweighted networks (bin_ind) and weighted networks
% (wei_ind)
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

clear i j Nulls tempW k

% Note if trying to save output you will likely need the -v7.3 flag if you
% have generated a large number of nulls