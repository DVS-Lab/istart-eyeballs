clear
close all;
fclose all;
clc

% Script for plotting variability in eyeball signal
% Jimmy Wyngaarden, 20 July 23

% Script needs to be run from the istart-eyeballs/code directory
codedir = pwd;
cd ..
basedir=pwd;
datadir = fullfile(basedir, 'derivatives','fsl');
cd(codedir)

% Specify input vars
hemi = {'left', 'right'};
sub = {'1001', '1003', '1004', '1006', '1009', '1010', '1011', '1012', '1013', '1015', '1016', '1019', ...
    '1021', '1242', '1243', '1244', '1245', '1247', '1248', '1249', '1251', '1253', '1255', '1276', '1282', ...
    '1286', '1294', '1300', '1301', '1302', '1303', '3101', '3116', '3122', '3125', '3140', '3143', '3152', ...
    '3166', '3167', '3170', '3173', '3176', '3189', '3190', '3199', '3200', '3206', '3210', '3212', '3218', ...
    '3220', '3223'};
nsub = length(sub);
task = {'doors', 'socialdoors', 'ugdg', 'mid', 'sharedreward'};
run = {'1', '2'};

% Preallocate dataframes
%df=zeros(length(sub),17);

% Read files
% Turn this on to re-generate eyeMovements.xlsx from scratch
% for h=1:length(hemi)
%     for s=1:length(sub)
%     df(s,1)=str2double(sub(1,s));
%         for t=1:length(task)
%             for r=1:length(run)
%                 
                  % Question: are these txt files pulling the eig
                  % extractions or the avg extr? 
%                 f = fullfile(datadir, ['sub-' sub{s}], ['ts_task-' task{t} '_mask-eyeball_' hemi{h} '_run-' run{r} '.txt']);
%                 if isfile(f)
%                     data = readmatrix(f);
%                     coV = std(data)/mean(data);
                      if coV > 90000 || coV < -90000
                          disp("debug strange coV value");
                          keyboard
                      end  
%                     if strcmp(hemi{h},'left')
%                         if strcmp(task{t},'doors')
%                             df(s,2)=coV;
%                         elseif strcmp(task{t},'socialdoors')
%                             df(s,3)=coV;
%                         elseif strcmp(task{t},'ugdg') && strcmp(run{r},'1')
%                             df(s,4)=coV;
%                         elseif strcmp(task{t},'ugdg') && strcmp(run{r},'2')
%                             df(s,5)=coV;
%                         elseif strcmp(task{t},'mid') && strcmp(run{r},'1')
%                             df(s,6)=coV;
%                         elseif strcmp(task{t},'mid') && strcmp(run{r},'2')
%                             df(s,7)=coV;
%                         elseif strcmp(task{t},'sharedreward') && strcmp(run{r},'1')
%                             df(s,8)=coV;
%                         elseif strcmp(task{t},'sharedreward') && strcmp(run{r},'2')
%                             df(s,9)=coV;
%                         end
%                     else
%                         if strcmp(task{t},'doors')
%                             df(s,10)=coV;
%                         elseif strcmp(task{t},'socialdoors')
%                             df(s,11)=coV;
%                         elseif strcmp(task{t},'ugdg') && strcmp(run{r},'1')
%                             df(s,12)=coV;
%                         elseif strcmp(task{t},'ugdg') && strcmp(run{r},'2')
%                             df(s,13)=coV;
%                         elseif strcmp(task{t},'mid') && strcmp(run{r},'1')
%                             df(s,14)=coV;
%                         elseif strcmp(task{t},'mid') && strcmp(run{r},'2')
%                             df(s,15)=coV;
%                         elseif strcmp(task{t},'sharedreward') && strcmp(run{r},'1')
%                             df(s,16)=coV;
%                         elseif strcmp(task{t},'sharedreward') && strcmp(run{r},'2')
%                             df(s,17)=coV;
%                         end
%                     end
%                 else
%                     disp("No data for "+f);
%                     if strcmp(hemi{h},'left')
%                         if strcmp(task{t},'doors') && strcmp(run{r},'1')
%                             df(s,2)=NaN;
%                         elseif strcmp(task{t},'socialdoors') && strcmp(run{r},'1')
%                             df(s,3)=NaN;
%                         elseif strcmp(task{t},'ugdg') && strcmp(run{r},'1')
%                             df(s,4)=NaN;
%                         elseif strcmp(task{t},'ugdg') && strcmp(run{r},'2')
%                             df(s,5)=NaN;
%                         elseif strcmp(task{t},'mid') && strcmp(run{r},'1')
%                             df(s,6)=NaN;
%                         elseif strcmp(task{t},'mid') && strcmp(run{r},'2')
%                             df(s,7)=NaN;
%                         elseif strcmp(task{t},'sharedreward') && strcmp(run{r},'1')
%                             df(s,8)=NaN;
%                         elseif strcmp(task{t},'sharedreward') && strcmp(run{r},'2')
%                             df(s,9)=NaN;
%                         end
%                     else
%                         if strcmp(task{t},'doors') && strcmp(run{r},'1')
%                             df(s,10)=NaN;
%                         elseif strcmp(task{t},'socialdoors') && strcmp(run{r},'1')
%                             df(s,11)=NaN;
%                         elseif strcmp(task{t},'ugdg') && strcmp(run{r},'1')
%                             df(s,12)=NaN;
%                         elseif strcmp(task{t},'ugdg') && strcmp(run{r},'2')
%                             df(s,13)=NaN;
%                         elseif strcmp(task{t},'mid') && strcmp(run{r},'1')
%                             df(s,14)=NaN;
%                         elseif strcmp(task{t},'mid') && strcmp(run{r},'2')
%                             df(s,15)=NaN;
%                         elseif strcmp(task{t},'sharedreward') && strcmp(run{r},'1')
%                             df(s,16)=NaN;
%                         elseif strcmp(task{t},'sharedreward') && strcmp(run{r},'2')
%                             df(s,17)=NaN;
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end
% Test; check raw values on some of these subs and see whether they match
% the values in the output file;
% 

%df_bar=readmatrix("/ZPOOL/data/projects/istart-eyeballs/code/eyeMovements.xlsx");
df_bar=readmatrix("/Users/jameswyngaarden/Documents/GitHub/istart-eyeballs/code/eyeMovements.xlsx");

for c=1:23
    %df_bar(c,:)
    df_bar(55,c)=median(df_bar(:,c),'omitnan');
    %df_bar(55,c)=mean(df_bar(:,c)/sqrt(nsub)); %CoV
end

%df_bar=(mean(df_bar,'omitnan')/std(df_bar,'omitnan'));


df_left=df_bar(:,[2:3 6 9 12]);
df_right=df_bar(:,[13:14 17 20 23]);
%composite_susd = zscore(mania_raw)+zscore(depress_raw);
%figure, histogram(composite_susd,50); title('Composite SUSD')

figure
x = 1:5;
y = [df_left(54,:)];
bar(x,y);
xticks(1:5);
xticklabels({'Monetary', 'Social', 'UGDG', 'MID', 'Shared Reward' });
ylabel('Avg Coefficient of Variation');

figure
x = 1:5;
y = [df_right(54,:)];
bar(x,y);
xticks(1:5);
xticklabels({'Monetary', 'Social', 'UGDG', 'MID', 'Shared Reward' });
ylabel('Avg Coefficient of Variation');

% low=readmatrix("/ZPOOL/data/projects/istart-eyeballs/derivatives/fsl/sub-1253/ts_task-ugdg_mask-eyeball_left_run-1.txt");
% high=readmatrix("/ZPOOL/data/projects/istart-eyeballs/derivatives/fsl/sub-1302/ts_task-mid_mask-eyeball_right_run-1.txt");
% zlow=(low-mean(low))/std(low);
% zhigh=(high-mean(high))/std(high);
% 
% figure
% plot(1:length(zlow),zlow);
% title("Low variability in eye movements")
% xlabel("Time (s)")
% ylabel("BOLD Signal (zscore)")
% ylim([-5 8])
% 
% figure
% plot(1:length(zhigh),zhigh);
% title("High variability in eye movements")
% xlabel("Time (s)")
% ylabel("BOLD Signal (zscore)")
% ylim([-5 8])