%%-------use the omega network MFA to optimize and forcast omega 
%--------supply into the future against global and regional demand
clc;clear all
filename='D:\Dropbox (Personal)\Dropbox (Personal)\omega n-3\Data\SuppData_d.xlsx';
A1 = xlsread(filename,'matrix','B2:AP27');  %read the stoichiometry matrix
A1(isnan(A1))=0;  %replace Nan with zeros

%%
%-----------optimization

%-----set parameters
[A,ub,lb,ct,b,C,sense,vt]=set_parameters(A1,'C');
%-------------run optimizer
[R]=OptimizeOmega_single(C,A,ub,lb,sense,ct,b,vt);
aqua_supp=sum(R([33:39,25]));
aquaculture_ratio=aqua_supp/(R(18)+aqua_supp);
FMFO_aqua=sum(R(26:32));
omega_out2in=aqua_supp/FMFO_aqua;
R(41) %consumption in units of kt/y
R(41)/420
%%%--------save results to SI excel spreadsheet, tab 'results'

R_table=table(R);
writetable(R_table,strcat(filename),'FileType','spreadsheet','WriteRowNames',true,'Sheet','results','Range','B1:B42')

%%
%-------------sensitivity analysis
%-------------knock_outs
locations_i=[12,13,14,18,21,20,33,34,35,36,37,38,39];  %indices to knock out
[A,ub,lb,ct,b,C,sense,vt]=set_parameters(A1,'C');

%%%---------------------------
ub_correct=ub;
for i=1:length(locations_i)
ub_correct=ub;
ub_correct(locations_i(i))=0; %location of knockouts
[R]=OptimizeOmega_single(C,A,ub_correct,lb,sense,ct,b,vt);
aqua_supp=sum(R([33:39,25]));
aquaculture_ratio=aqua_supp/(R(18)+aqua_supp);
FMFO_aqua=sum(R(26:32));
omega_out2in=aqua_supp/FMFO_aqua;
%consumption in units of kt/y
Tab(i,1)={cat(2,'r',num2str(locations_i(i)))};
Tab(i,2)={R(41)/627.42};  %compared to optimal solution of scenario a
clear R;
end

%%%--------save results to SI excel spreadsheet
Tab_table=table(Tab(:,1),Tab(:,2),'VariableNames',{'flux','fractionOfOptimumr40'});
writetable(Tab_table,strcat(filename),'FileType','spreadsheet','WriteRowNames',true,'Sheet','knockouts','Range','A1:B14')



%%
%%%-------------sensitivity Analysis
%---------------flux variability
Ni=size(A1,2);
locations_i=[12,13,14,18,21,20,33,34,35,36,37,38,39];
Tab_3=cell(length(locations_i),5);
[A,ub,lb,ct,b,C,sense,vt]=set_parameters(A1,'C');

% sense = If sense is 1, the problem is a minimization.  If sense is
%-1, the problem is a maximization.  
%%%---------------------------
ub_correct=ub;
lb_correct=lb;
gamma=0.9;  %0.67 is the fraction to arrive at current production of 420 kt/y
lb_correct(41)=627.*gamma;  %assign gamma - fraction of maximal result to freeze on specific omega supply for consumption
ub_correct(41)=lb_correct(41);  
for j=1:2
if j==1;sense=1;elseif j==2; sense=-1;end
for i=1:length(locations_i)
C=zeros(Ni,1);
C(locations_i(i))=1;   %optimize a certain flux
Tab_3(i,1)={cat(2,'r',num2str(locations_i(i)))};  %write the flux number
[R]=OptimizeOmega_single(C,A,ub_correct,lb_correct,sense,ct,b,vt);
%consumption in units of kt/y
Tab_3(i,j+1)={R(locations_i(i))};
Tab_3(i,5+j)={R(41)};
clear R;
end
end
for h=1:length(locations_i)
Tab_3(h,4)={(cell2mat(Tab_3(h,3))-cell2mat(Tab_3(h,2)))};
rt=(cell2mat(Tab_3(h,3))-cell2mat(Tab_3(h,2)))./cell2mat(Tab_3(h,2))*100;
if rt==inf;Tab_3(h,5)={'NaN'};else Tab_3(h,5)={rt};end
end
%%%--------save results to SI excel spreadsheet

Tab_table=table(Tab_3(:,1),Tab_3(:,2),Tab_3(:,3),Tab_3(:,4),Tab_3(:,5),'VariableNames',{'flux','min','max','absoluteChange','percentageChange'});
writetable(Tab_table,strcat(filename),'FileType','spreadsheet','WriteRowNames',true,'Sheet','flux variability','Range','A1:E14')

%%
%%--------draw global demand
OmegaDemand