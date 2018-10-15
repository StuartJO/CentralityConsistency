% This script will generate all the figures present in the paper that were
% generated based are the data obtained. Other figures were created
% manually in powerpoint using an excessive amount of autoshapes

% This script also uses colormaps from cbrewer

%% Figure 2

MakeFigure2

%% Figure 3

MakeFigure3

%% Figure 4 and S7

MakeFigure4_S7

%% Figure 5 and 6

MakeFigure5_6

%% Figure 7-8, S12-S17

% Note when making the figure of the airport network it will flash up a
% warning. Figure will produce just fine however.

MakeClusterFigures('Unweighted',72,8)
print('Figure7.png','-dpng','-r300')

MakeClusterFigures('Unweighted',127,3)
print('Figure8.png','-dpng','-r300')

MakeClusterFigures('Unweighted',12,6)
print('FigureS12.png','-dpng','-r300')

MakeClusterFigures('Unweighted',23,9)
print('FigureS13.png','-dpng','-r300')

MakeClusterFigures('Unweighted',206,7)
print('FigureS14.png','-dpng','-r300')

MakeClusterFigures('Unweighted',13,3)
print('FigureS15.png','-dpng','-r300')

MakeClusterFigures('Unweighted',20,3)
print('FigureS16.png','-dpng','-r300')

MakeClusterFigures('Unweighted',52,3)
print('FigureS17.png','-dpng','-r300')

%% Figure S2

MakeFigureS2

%% Figure S3

MakeFigureS3

%% Figure S4 and S5

MakeFigureS4_S5

%% Figure S6 and S8

MakeFigureS6_S8

%% Figure S9

MakeFigureS9

%% Figure S10 and S11

MakeFigureS10_S11