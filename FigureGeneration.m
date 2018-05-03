% This script will generate all the figures present in the paper that were
% generated based are the data obtained. Other figures were created
% manually in powerpoint using an excessive amount of autoshapes

% This script also uses colormaps from cbrewer

MAINPATH = 'C:\Users\Stuart\Dropbox\PhD\Centrality_code';

addpath(MAINPATH)

% Set the clusters to select for the clustering pictures

% Note the colormap only works for up to 10 clusters 

use_clusters = [4 3 5 10 8 6 6 3 6 5 7 8 3 3 4];

%% Initial setup of variable required
lines_colormap = lines(7);
netcolor{1} = lines_colormap(1,:);
netcolor{2} = lines_colormap(1,:);
netcolor{3} = lines_colormap(1,:);
netcolor{4} = lines_colormap(2,:);
netcolor{5} = lines_colormap(3,:);
netcolor{6} = lines_colormap(1,:);
netcolor{7} = lines_colormap(4,:);
netcolor{8} = lines_colormap(2,:);
netcolor{9} = lines_colormap(2,:);
netcolor{10} = lines_colormap(2,:);
netcolor{11} = lines_colormap(1,:);
netcolor{12} = lines_colormap(2,:);
netcolor{13} = lines_colormap(2,:);
netcolor{14} = lines_colormap(4,:);
netcolor{15} = lines_colormap(4,:);

%% Figure 2

MakeFigure2_top
print('Figure2top.png','-dpng')
MakeFigure2_bottom
print('Figure2bottom.png','-dpng')
%% Figure 3

MakeFigure3
print('Figure3.png','-dpng')
%% Figure 4

MakeFigure4
print('Figure4.png','-dpng')
%% Figure 5

MakeFigure5
print('Figure5.png','-dpng')
%% Figure 6

MakeFigure6
print('Figure6.png','-dpng')
%% Figure 7-8, S3-S15

% Note when making the figure of the airport network it will flash up a
% warning. Figure will produce just fine however.

MakeClusterFigures

%% Figure S1

MakeFigureS1
print('Figures1.png','-dpng')