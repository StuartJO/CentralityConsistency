% makes figure 3

varsbefore = who;

figure
nice_cmap = [make_cmap('steelblue',50,30,0);flipud(make_cmap('orangered',50,30,0))];

positive_cmap = flipud(make_cmap('orangered',50,30,0));

subplot(2,2,1)

data = mean_corr_bin;

cent_labels = cent_names_abbrev(cent_ind);

imagesc(data(cent_ind,cent_ind))

colormap(gca,nice_cmap)
caxis([min(min(data)) max(max(data))])
colorbar
fig_name = sprintf('Mean Spearman correlation across unweighted networks');
title(fig_name,'interpreter','none','Fontsize',10)
xticks(1:15)
yticks(1:15)
xticklabels(cent_labels)
xtickangle(90)
yticklabels(cent_labels)

subplot(2,2,2)

data = var_corr_bin;

imagesc(data(cent_ind,cent_ind))

colormap(gca,nice_cmap)
caxis([min(min(data)) max(max(data))])
colorbar
fig_name = sprintf('Spearman correlation standard deviation across unweighted networks');
title(fig_name,'interpreter','none','Fontsize',10)
xticks(1:15)
yticks(1:15)
xticklabels(cent_labels)
xtickangle(90)
yticklabels(cent_labels)

subplot(2,2,3)

data = mean_corr_wei;

cent_labels = cent_labels(cent_ind);

imagesc(data(cent_ind,cent_ind))

colormap(gca,nice_cmap)
caxis([min(min(data)) max(max(data))])
colorbar
fig_name = sprintf('Mean Spearman correlation across weighted networks');
title(fig_name,'interpreter','none','Fontsize',10)
xticks(1:15)
yticks(1:15)
xticklabels(cent_labels)
xtickangle(90)
yticklabels(cent_labels)

subplot(2,2,4)

data = var_corr_wei;

imagesc(data(cent_ind,cent_ind))

colormap(gca,nice_cmap)
caxis([min(min(data)) max(max(data))])
colorbar
fig_name = sprintf('Spearman correlation standard deviation across weighted networks');
title(fig_name,'interpreter','none','Fontsize',10)
xticks(1:15)
yticks(1:15)
xticklabels(cent_labels)
xtickangle(90)
yticklabels(cent_labels)

% Removes variables created by this script
varsafter = who; 
varsnew = setdiff(varsafter, varsbefore); 
clear(varsnew{:})