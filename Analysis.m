% This code takes in input a Data.csv file with one line og header and 7
% data columns.

clear all
close all
clc

%DataTab = readtable('Data.csv') ;

%%
% Reading CSV file with standard format. From first to 7th column we read:
% integers, string, string, string, floating, floating, floating
IDf = fopen('Data.csv') ;

% reading the header line containing the namees of parameters
H_text  = textscan(IDf,'%s',7,'Delimiter',','); 

% reading the data
DataVal = textscan(IDf,'%d64 %s %s %s %f64 %f64 %f64','Delimiter',',') ;
fclose(IDf) ;

%%
% setting the size of the data sample                                     
para = length(H_text{1})  ; % number of parameters 
st_n = length(DataVal{1}) ; % number of entries

% setting the parameters
An_id    = DataVal{1}   ; % Student anonymus ID
An_id_nm = H_text{1}{1} ; % name of the variable

Ct_id    = DataVal{2}   ; % Student country ID
Ct_id_nm = H_text{1}{2} ; % name of the variable

in_cr    = DataVal{3}   ; % Student in a course (t) of alone/free (f) 
in_cr_nm = H_text{1}{3} ; % name of the variable

unit     = DataVal{4}   ; % Number/Name of the workbook's unit
unit_nm  = H_text{1}{4} ; % name of the variable

ap_sc    = DataVal{5}   ; % Average percentage score of all unit activities
ap_sc_nm = H_text{1}{5} ; % name of the variable

comp     = DataVal{6}   ; % Percentage of completion of unit activities
comp_nm  = H_text{1}{6} ; % name of the variable

in_rt    = DataVal{7}   ; % Index between 0 to 1 quantifying how much the 
                          % student departs from the activities order 
                          % suggested by the thereacher: 0 no departure; 
                          % 1 total departure (order inversion)
in_rt_nm = H_text{1}{7} ; % name of the variable

%% Finding the actual number of students
[St_id, ifrst, ~]    = unique(An_id) ;
N_St_id  = length(St_id) ;
display(['We have a total of ',num2str(N_St_id),' students'])


%% Finding countries and students studying alone and with teacher

% defining all students' countries in the sample 
all_Ct   = unique(Ct_id) ;
n_all_Ct = length(all_Ct) ;
display(['Spread in ',num2str(n_all_Ct),' countries'])

% finding all students studying with teacher and alone
i_st_teach = intersect(find(strcmp(in_cr,'t')),ifrst) ;
n_st_teach = length(i_st_teach)   ;

i_st_alone = intersect(find(strcmp(in_cr,'f')),ifrst) ;
n_st_alone = length(i_st_alone)   ;


% finding all activities carried out with teacher and alone
i_act_teach = find(strcmp(in_cr,'t')) ;
n_act_teach = length(i_act_teach)   ;

i_act_alone = find(strcmp(in_cr,'f')) ;
n_act_alone = length(i_act_alone)   ;
display(['And that carried out a total of ',num2str(n_act_alone+n_act_teach),' activities.'])

%% Finding the students from the same country studying with or without a teacher
Hist_Ct   = zeros(n_all_Ct,1) ; 
Hist_Ct_f = zeros(n_all_Ct,1) ; 
for aa = 1:n_all_Ct
    
    Ct_ix = find(strcmp(all_Ct(aa),Ct_id(ifrst))) ;
    Hist_Ct(aa) = length(Ct_ix) ; % total number of students from the same country
    
    Hist_Ct_f(aa) = length(intersect(Ct_ix,i_st_alone)) ;
end
Hist_Ct_t = Hist_Ct - Hist_Ct_f ;      % number of students from the same 
                                       % country studying with a teacher
Hist_Ct_tot = [Hist_Ct_t, Hist_Ct_f] ; % matrix containing the number of 
                                       % students from the same country 
                                       % with andwithout a teacher in the 
                                       % first amd second column, resp. 
Perc_st_alone = Hist_Ct_tot(:,2) ./ sum(Hist_Ct_tot,2) ;
i_p_n0 = find(Perc_st_alone) ;

display('The list of the coutries ') 
display('with alone studying students is:')
display(all_Ct(i_p_n0))
display('The percentage of studying alone') 
display('students in these countries is:')
display(Perc_st_alone(i_p_n0))
%% Creating4 country cathegories, 3 with 17 cuntries and with 7 for plots
[~, is] = sort(Hist_Ct) ;

iv1 = is(1:27)  ;
iv2 = is(28:54) ;
iv3 = is(55:82) ;
iv4 = is(83:87) ;
clear is

%% Histograms of the number of students per country
figure('Position',[0,0,1200,650])
bar((Hist_Ct_tot(iv1,:)),'stacked')
xlim([0.5 length(iv1)+0.5])
ylim([0 1.1*(max(Hist_Ct(iv1)))+0.5])
grid on
title(['First country group of ',num2str(length(iv1)),' counties'],'FontSize',14)
xlabel('Country ID','FontSize',14)
ylabel('Student number','FontSize',14)
legend('Fraction of student studying with techer','Fraction of student studying alone','location','northwest')
NumTicks = length(iv1);
L = get(gca,'XLim');
set(gca,'XTick',linspace(1,length(iv1),NumTicks))
set(gca,'XTickLabel',all_Ct(iv1))
set(gca,'FontSize',14)
fileou = strcat('country1.eps') ;
set(gcf,'PaperPositionMode','auto') ;
print('-depsc','-r300',fileou) 


figure('Position',[0,0,1200,650])
bar((Hist_Ct_tot(iv2,:)),'stacked')
xlim([0.5 length(iv2)+0.5])
ylim([0 1.1*(max(Hist_Ct(iv2)))+0.5])
grid on
title(['Second country group of ',num2str(length(iv2)),' counties'],'FontSize',14)
xlabel('Country ID','FontSize',14)
ylabel('Student number','FontSize',14)
legend('Fraction of student studying with teacher','Fraction of student studying alone','location','northwest')
NumTicks = length(iv2);
% L = get(gca,'XLim');
set(gca,'XTick',linspace(1,length(iv2),NumTicks))
set(gca,'XTickLabel',all_Ct(iv2))
set(gca,'FontSize',14)
fileou = strcat('country2.eps') ;
set(gcf,'PaperPositionMode','auto') ;
print('-depsc','-r300',fileou) 


figure('Position',[0,0,1200,650])
bar(Hist_Ct_tot(iv3,:),'stacked')
xlim([0.5 length(iv3)+0.5])
ylim([0 1.1*(max(Hist_Ct(iv3)))+0.5])
grid on
title(['Third country group of ',num2str(length(iv3)),' counties'],'FontSize',14)
xlabel('Country ID','FontSize',14)
ylabel('Student number','FontSize',14)
legend('Fraction of student studying with teacher','Fraction of student studying alone','location','northwest')
NumTicks = length(iv3);
% L = get(gca,'XLim');
set(gca,'XTick',linspace(1,length(iv3),NumTicks))
set(gca,'XTickLabel',all_Ct(iv3))
set(gca,'FontSize',14)
fileou = strcat('country3.eps') ;
set(gcf,'PaperPositionMode','auto') ;
print('-depsc','-r300',fileou) 

figure('Position',[0,0,1200,650])
bar(Hist_Ct_tot(iv4,:),'stacked')
xlim([0.5 length(iv4)+0.5])
ylim([0 1.1*(max(Hist_Ct(iv4)))])
grid on
title(['Fourth country group of ',num2str(length(iv4)),' counties'],'FontSize',14)
xlabel('Country ID','FontSize',14)
ylabel('Student number','FontSize',14)
legend('Fraction of student studying with teacher','Fraction of student studying alone','location','northwest')
NumTicks = length(iv4);
% L = get(gca,'XLim');
set(gca,'XTick',linspace(1,length(iv4),NumTicks))
set(gca,'XTickLabel',all_Ct(iv4))
set(gca,'FontSize',14)
fileou = strcat('country4.eps') ;
set(gcf,'PaperPositionMode','auto') ;
print('-depsc','-r300',fileou) 


%% Histograms of the average score
figure('Position',[0,0,1200,650])
vect = ap_sc(i_act_teach) ;
idx = vect >=0 & vect <=1 ;
v_t = vect(idx) ;
md_teach = mode(vect(vect >0 & vect <1)) ;
subplot(1,2,1)
[y,x] = hist(v_t,100) ;
bar(x,100*y/sum(y))
title(['Students studying with teacher, distribution mode = ',num2str(md_teach)])
ylabel('% of units in the data','FontSize',14)
xlabel('Average % score of all unit activities','FontSize',14)
set(gca,'FontSize',14)
clear vect idx v_t x y



vect = ap_sc(i_act_alone) ;
idx = vect >=0 & vect <=1 ;
v_t = vect(idx) ;
md_alone = mode(vect(vect >0 & vect <1)) ;
subplot(1,2,2)
[y,x] = hist(v_t,100) ;
bar(x,100*y/sum(y))
title(['Students studying alone, distribution mode = ',num2str(md_alone)])
% ylabel('Student number','FontSize',14)
xlabel('Average % score of all unit activities','FontSize',14)
set(gca,'FontSize',14)
clear vect idx v_t x y
fileou = strcat('avgscore.eps') ;
set(gcf,'PaperPositionMode','auto') ;
print('-depsc','-r300',fileou) 


%% Histograms of the completed activities
figure('Position',[0,0,1200,650])
vect = comp(i_act_teach) ;
idx = vect >=0 & vect <=1 ;
v_t = vect(idx) ;
md_teach = mode(vect(vect >0 & vect <1)) ;
subplot(1,2,1)
[y,x] = hist(v_t,30) ;
bar(x,100*y/sum(y))
title(['Students studying with teacher, distribution mode = ',num2str(md_teach)])
ylabel('% of units in the data','FontSize',14)
xlabel('% of activities completed in a unit','FontSize',14)
set(gca,'FontSize',14)
clear vect idx v_t x y

vect = comp(i_act_alone) ;
idx = vect >=0 & vect <=1 ;
v_t = vect(idx) ;
md_alone = mode(vect(vect >0 & vect <1)) ;
subplot(1,2,2)
[y,x] = hist(v_t,30) ;
bar(x,100*y/sum(y))
title(['Students studying alone, distribution mode = ',num2str(md_alone)])
% ylabel('Student number','FontSize',14)
xlabel('% of activities completed in a unit','FontSize',14)
set(gca,'FontSize',14)
clear vect idx v_t x y
fileou = strcat('compscore.eps') ;
set(gcf,'PaperPositionMode','auto') ;
print('-depsc','-r300',fileou) 



%% Histograms of the activity completion rate
figure('Position',[0,0,1200,650])
vect = in_rt(i_act_teach) ;
idx = vect >=0 & vect <=1 ;
v_t = vect(idx) ;
md_teach = mode(vect(vect >0 & vect <1)) ;
[y,x] = hist(v_t,30) ;
bar(x,100*y/sum(y))
title(['Students studying with teacher, distribution mode = ',num2str(md_teach)])
ylabel('% of units in the data','FontSize',14)
xlabel('Activity completion inversion rate','FontSize',14)
set(gca,'FontSize',14)
clear vect idx v_t x y

vect = in_rt(i_act_teach) ;
idx = vect >0 & vect <=1 ;
v_t = vect(idx) ;
[y,x] = hist(v_t,30) ;
axes('Position',[.5 .5 .4 .4])
box on
bar(x,100*y/sum(y))
fileou = strcat('inversion1.eps') ;
set(gcf,'PaperPositionMode','auto') ;
print('-depsc','-r300',fileou) 
clear vect idx v_t x y




figure('Position',[0,0,1200,650])
vect = in_rt(i_act_alone) ;
idx = vect >=0 & vect <=1 ;
v_t = vect(idx) ;
md_alone = mode(vect(vect >0 & vect <1)) ;
[y,x] = hist(v_t,30) ;
bar(x,100*y/sum(y))
title(['Students studying alone, distribution mode = ',num2str(md_alone)])
% ylabel('Student number','FontSize',14)
xlabel('Activity completion inversion rate','FontSize',14)
set(gca,'FontSize',14)
clear vect idx v_t x y

vect = in_rt(i_act_alone) ;
idx = vect >0 & vect <=1 ;
v_t = vect(idx) ;
[y,x] = hist(v_t,30) ;
axes('Position',[.5 .5 .4 .4])
box on
bar(x,100*y/sum(y))
fileou = strcat('inversion2.eps') ;
set(gcf,'PaperPositionMode','auto') ;
print('-depsc','-r300',fileou) 



%% Score vs. Activity completed
figure('Position',[0,0,1200,650])
vect = ap_sc(i_act_teach) ;
vect2= comp(i_act_teach) ;
subplot(1,2,1)
plot(vect2,vect,'.')
title('Students studying with teacher')
ylabel('Average % score of all unit activities','FontSize',14)
xlabel('% of activities completed in a unit','FontSize',14)
set(gca,'FontSize',14)
clear vect idx v_t x y



vect = ap_sc(i_act_alone) ;
vect2= comp(i_act_alone) ;
subplot(1,2,2)
plot(vect2,vect,'.')
title('Students studying with alone')
ylabel('Average % score of all unit activities','FontSize',14)
xlabel('% of activities completed in a unit','FontSize',14)
set(gca,'FontSize',14)
clear vect idx v_t x y
fileou = strcat('comp_avg.eps') ;
set(gcf,'PaperPositionMode','auto') ;
print('-depsc','-r300',fileou) 



%% Score vs. Completion rate
figure('Position',[0,0,1200,650])
vect = ap_sc(i_act_teach) ;
vect2= in_rt(i_act_teach) ;
subplot(1,2,1)
plot(vect2,vect,'.')
title('Students studying with teacher')
ylabel('Average % score of all unit activities','FontSize',14)
xlabel('Activity completion inversion rate','FontSize',14)
set(gca,'FontSize',14)
clear vect idx v_t x y



vect = ap_sc(i_act_alone) ;
vect2= in_rt(i_act_alone) ;
subplot(1,2,2)
plot(vect2,vect,'.')
title('Students studying with alone')
ylabel('Average % score of all unit activities','FontSize',14)
xlabel('Activity completion inversion rate','FontSize',14)
set(gca,'FontSize',14)
clear vect idx v_t x y
fileou = strcat('inv_avg.eps') ;
set(gcf,'PaperPositionMode','auto') ;
print('-depsc','-r300',fileou) 