%read and draw omega 3 forcasted demand per regions in the world
clf;
D = xlsread(filename,'Omega 3','F25:V150');  %read the global omega demand matrix
num_of_groups=20;
du=1;
% colorm=[106,127,210;...
%     28,91,90;...
%     215,118,85;...
%     111,156,108;
%     154,42,6;...
%     71,154,188]/255;

strr={'#033D54';...
    '#05668D';...
    '#028090';...
    '#008779';...
    '#02C39A';...
    '#F0F3BD'};
for w=1:6
    stre=strr{w};
    colorm(w,:) = sscanf(stre(2:end),'%2x%2x%2x',[1 3])/255;
end
% colorm=[200,221,212;...
%     7,92,98;...
%     45,160,161;...
%     60,219,201;...
%     29,109,31;...
%     151,200,76]/255;...

for r=1:6
    dm=du+num_of_groups;
    if r==1
        S.africa=D([du:dm],:);
    elseif r==2
        S.asia=D([du:dm],:);
    elseif r==3
        S.Europe=D([du:dm],:);
    elseif r==4
        S.Latin=D([du:dm],:);
    elseif r==5
        S.NAmerica=D([du:dm],:);
    elseif r==6
        S.Oceania=D([du:dm],:);
    end
    du=dm+1;
end
tot_africa=sum(S.africa,1);
tot_asia=sum(S.asia,1);
tot_europe=sum(S.Europe,1);
tot_latin=sum(S.Latin,1);
tot_Namerica=sum(S.NAmerica,1);
tot_oceania=sum(S.Oceania,1);
g=gca;
colormap(colorm);
f=area([tot_africa;tot_asia;tot_europe;tot_latin;tot_Namerica;tot_oceania]');
f(1).FaceColor=colorm(1,:);
f(2).FaceColor=colorm(2,:);
f(3).FaceColor=colorm(3,:);
f(4).FaceColor=colorm(4,:);
f(5).FaceColor=colorm(5,:);
f(6).FaceColor=colorm(6,:);
line([0 1.5],[627 627],'Color','w')
text(1.7,630, 'fully-optimized','Color','w')
%line([0 17],[540 540],'Color','w')
%text(8,560, 'scenario A','Color','w')
line([0 1.5],[420 420],'Color','w','LineStyle','-')
text(1.7,420, 'current','Color','w')
g.XAxis.Limits=[1,17];%limit to 17 points of time series
g.YLabel.String='\omega-3 requirement (kt/y)';
g.XAxis.TickValues=[1:17];
g.XAxis.TickLabels={'2020','2025','2030','2035','2040','2045','2050','2055','2060','2065','2070','2075','2080','2085','2090','2095','2100'};
g.XTickLabelRotation=45;
g.Position=[0.1 0.1 0.75 0.85];
t=legend([f(6) f(5) f(4) f(3) f(2) f(1)],'Oceania','N. America','S. America','Europe','Asia','Africa');
%t.Location='eastoutside';
t.ItemTokenSize = [5,15];
t.Position=[0.8 0.7 0.2 0.2];
t.Box='off';
t.NumColumns=1;
set(gcf,'PaperPositionMode','auto')
print('omegademand','-dpng','-r0')