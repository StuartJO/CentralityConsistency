figure('units','pixels','outerposition',[0 0 1920 1080])

netcolor_all = netcolor;

xlabel_names = {'Density','Modularity','Majorization gap'};
n = 1;
for i = 1:3
subplot(2,2,n)
sz = 100;
s1 = scatter(M(1,i),Networks_mwCMC(1),sz,netcolor_all{1},'o','filled');
hold on
s2 = scatter(M(2,i),Networks_mwCMC(2),sz,netcolor_all{2},'+');
s3 = scatter(M(3,i),Networks_mwCMC(3),sz,netcolor_all{3},'x');
s4 = scatter(M(4,i),Networks_mwCMC(4),sz,netcolor_all{4},'o','filled');
s5 = scatter(M(5,i),Networks_mwCMC(5),sz,netcolor_all{5},'o','filled');
s6 = scatter(M(6,i),Networks_mwCMC(6),sz,netcolor_all{6},'*');
s7 = scatter(M(7,i),Networks_mwCMC(7),sz,netcolor_all{7},'o','filled');
s8 = scatter(M(8,i),Networks_mwCMC(8),sz,netcolor_all{8},'+');
s9 = scatter(M(9,i),Networks_mwCMC(9),sz,netcolor_all{9},'x');
s10 = scatter(M(10,i),Networks_mwCMC(10),sz,netcolor_all{10},'*');
s14 = scatter(M(14,i),Networks_mwCMC(14),sz,netcolor_all{14},'h','filled');

s11 = scatter(M(11,i),Networks_mwCMC(11),sz,netcolor_all{11},'s','filled');
s12 = scatter(M(12,i),Networks_mwCMC(12),sz,netcolor_all{12},'s','filled');
s13 = scatter(M(13,i),Networks_mwCMC(13),sz,netcolor_all{13},'d','filled');
s15 = scatter(M(15,i),Networks_mwCMC(15),sz,netcolor_all{15},'v','filled');

ylim([0 1])
xlim([0 1])
set(gca,'FontSize',16);
xlabel(xlabel_names{i},'Fontsize',20)

ylabel('Mean Within Network CMC','Fontsize',20)

box on
n = n + 1;

end
net_abbrevname_ords = [1:10 14 11:13 15];
net_abbrevname2 = net_abbrevname;

net_abbrevname2{11} = 'Netsci weighted';
net_abbrevname2{12} = 'LesMis weighted';
net_abbrevname2{13} = 'Journal weighted';
net_abbrevname2{15} = 'Brain weighted';



% Because MATLAB won't allow me to make the legend how I want, I will make
% a plot which looks how I want the legend to look
subplot(2,2,4);

sz = 100;
offset = .1;
xaxis_test_pos = [0 1.5 3];
Fontsz = 30;


s1 = scatter(xaxis_test_pos(1),1,sz,netcolor_all{1},'o','filled');
text(xaxis_test_pos(1)+offset,1,net_abbrevname2{1},'Fontsize',Fontsz)
hold on
s2 = scatter(xaxis_test_pos(1),2,sz,netcolor_all{2},'+');
text(xaxis_test_pos(1)+offset,2,net_abbrevname2{2},'Fontsize',Fontsz)
s3 = scatter(xaxis_test_pos(1),3,sz,netcolor_all{3},'x');
text(xaxis_test_pos(1)+offset,3,net_abbrevname2{3},'Fontsize',Fontsz)
s4 = scatter(xaxis_test_pos(1),4,sz,netcolor_all{4},'o','filled');
text(xaxis_test_pos(1)+offset,4,net_abbrevname2{4},'Fontsize',Fontsz)
s5 = scatter(xaxis_test_pos(1),5,sz,netcolor_all{5},'o','filled');
text(xaxis_test_pos(1)+offset,5,net_abbrevname2{5},'Fontsize',Fontsz)
s6 = scatter(xaxis_test_pos(2),1,sz,netcolor_all{6},'*');
text(xaxis_test_pos(2)+offset,1,net_abbrevname2{6},'Fontsize',Fontsz)
s7 = scatter(xaxis_test_pos(2),2,sz,netcolor_all{7},'o','filled');
text(xaxis_test_pos(2)+offset,2,net_abbrevname2{7},'Fontsize',Fontsz)
s8 = scatter(xaxis_test_pos(2),3,sz,netcolor_all{8},'+');
text(xaxis_test_pos(2)+offset,3,net_abbrevname2{8},'Fontsize',Fontsz)
s9 = scatter(xaxis_test_pos(2),4,sz,netcolor_all{9},'x');
text(xaxis_test_pos(2)+offset,4,net_abbrevname2{9},'Fontsize',Fontsz)
s10 = scatter(xaxis_test_pos(2),5,sz,netcolor_all{10},'*');
text(xaxis_test_pos(2)+offset,5,net_abbrevname2{10},'Fontsize',Fontsz)
s14 = scatter(xaxis_test_pos(3),1,sz,netcolor_all{14},'h','filled');
text(xaxis_test_pos(3)+offset,1,net_abbrevname2{14},'Fontsize',Fontsz)

s11 = scatter(xaxis_test_pos(3),2,sz,netcolor_all{11},'s','filled');
text(xaxis_test_pos(3)+offset,2,net_abbrevname2{11},'Fontsize',Fontsz)
s12 = scatter(xaxis_test_pos(3),3,sz,netcolor_all{12},'s','filled');
text(xaxis_test_pos(3)+offset,3,net_abbrevname2{12},'Fontsize',Fontsz)
s13 = scatter(xaxis_test_pos(3),4,sz,netcolor_all{13},'d','filled');
text(xaxis_test_pos(3)+offset,4,net_abbrevname2{13},'Fontsize',Fontsz)
s15 = scatter(xaxis_test_pos(3),5,sz,netcolor_all{15},'v','filled');
text(xaxis_test_pos(3)+offset,5,net_abbrevname2{15},'Fontsize',Fontsz)
box off
xlim([0 5])
ylim([0 6])
set(gca, 'YDir','reverse')
set(gca,'visible','off')