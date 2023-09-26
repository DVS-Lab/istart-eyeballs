clear
close all;
fclose all;
clc

% Script for plotting variability in eyeball signal
% Jimmy Wyngaarden, 25 Sept 23

% Script needs to be run from the istart-eyeballs/code directory
codedir = pwd;
cd ..
basedir=pwd;
datadir = fullfile(basedir, 'derivatives','extractEyes_test');
cd(codedir)

% Specify input vars
hemi = {'left', 'right'};
sub = {'1001', '1003', '1004', '1006', '1009', '1010', '1011', '1012', '1013', '1015', '1016', '1019', ...
    '1021', '1242', '1243', '1244', '1245', '1247', '1248', '1249', '1251', '1253', '1255', '1276', '1282', ...
    '1286', '1294', '1300', '1301', '1302', '1303', '3101', '3116', '3122', '3125', '3140', '3143', '3152', ...
    '3166', '3167', '3170', '3173', '3176', '3189', '3190', '3199', '3200', '3206', '3210', '3212', '3218', ...
    '3220', '3223'};

nsub = length(sub);
task = {'doors', 'socialdoors', 'mid', 'ugdg', 'sharedreward'};
%task = {'doors', 'socialdoors'};
run = {'1', '2'};
eig = {'1', '2'};
df = zeros(1,9);
count=1;

% First: find correlation coefficient between avg & eig
% Plot: x axis = correlation coefficient, y axis = count
% df: 9 columns: (1) subID; (2) hemi; (3) task; (4) run; (5) avg; (6) eig;
% (7) avg_cov (8) eig_cov (9)correlation coefficient for avg & eig;

% Read files
for s=1:length(sub)
    for h=1:length(hemi)
        for t=1:length(task)
            for r=1:length(run)
                df(count,1)=str2double(sub(1,s));
                df(count,2)=h;
                df(count,3)=t;
                df(count,4)=r;
                f_avg = fullfile(datadir, ['sub-' sub{s}], ['ts_task-' task{t} '_mask-eyeball_' hemi{h} '_run-' run{r} '.txt']);
                f_eig = fullfile(datadir, ['sub-' sub{s}], ['ts_task-' task{t} '_mask-eyeball_' hemi{h} '_run-' run{r} '_eig.txt']);
                if isfile(f_avg)
                    data_avg = readmatrix(f_avg);
                else
                    %disp("Missing "+f_avg);
                end
                if isfile(f_eig)
                    data_eig = readmatrix(f_eig);
                else
                    %disp("Missing "+f_eig);
                end
                avg = mean(data_avg);
                avg_cov = std(data_avg)/mean(data_avg);
                df(count,5) = avg;
                df(count,6) = avg_cov;
                eig = mean(data_eig);
                eig_cov = std(data_eig)/mean(data_eig);
                df(count,7) = eig;
                df(count,8) = eig_cov;
                R = corrcoef(data_avg, data_eig);
                df(count,9) = R(2,1);
                count = count+1;
            end
        end
    end
end

% Plot correlations in histogram
figure
histogram(df(:,9),50);
title("Correlation between avg signal & eig", "(each observation a unique sub/hemi/task/run)");
xlabel("Correlation Coefficient (r)");
ylabel("Count");

% Next: separate by task
id_doors = (df(:,3)==1); 
df_doors = df(id_doors,:);
id_socialdoors = (df(:,3)==2); 
df_socialdoors = df(id_socialdoors,:);
id_mid = (df(:,3)==3); 
df_mid = df(id_mid,:);
id_ugdg = (df(:,3)==4); 
df_ugdg = df(id_ugdg,:);
id_sharedreward = (df(:,3)==5); 
df_sharedreward = df(id_sharedreward,:);

% Take the average signal for each task
df_plot = zeros(4,5);
df_plot(1,1) = mean(df_doors(:,5));
df_plot(1,2) = mean(df_socialdoors(:,5));
df_plot(1,3) = mean(df_ugdg(:,5));
df_plot(1,4) = mean(df_mid(:,5));
df_plot(1,5) = mean(df_sharedreward(:,5));

% Take the average CoV for each task
df_plot(2,1) = mean(df_doors(:,7));
df_plot(2,2) = mean(df_socialdoors(:,7));
df_plot(2,3) = mean(df_ugdg(:,7));
df_plot(2,4) = mean(df_mid(:,7));
df_plot(2,5) = mean(df_sharedreward(:,7));

% Error bars for average signal
df_plot(3,1) = (std(df_doors(:,5))/sqrt(size(df_doors(:,5),1)));
df_plot(3,2) = (std(df_socialdoors(:,5))/sqrt(size(df_socialdoors(:,5),1)));
df_plot(3,3) = (std(df_ugdg(:,5))/sqrt(size(df_ugdg(:,5),1)));
df_plot(3,4) = (std(df_mid(:,5))/sqrt(size(df_mid(:,5),1)));
df_plot(3,5) = (std(df_sharedreward(:,5))/sqrt(size(df_sharedreward(:,5),1)));
errhigh_avg = df_plot(3,:);
errlow_avg = df_plot(3,:)*-1;

% Error bars for CoV
df_plot(4,1) = (std(df_doors(:,7))/sqrt(size(df_doors(:,7),1)));
df_plot(4,2) = (std(df_socialdoors(:,7))/sqrt(size(df_socialdoors(:,7),1)));
df_plot(4,3) = (std(df_ugdg(:,7))/sqrt(size(df_ugdg(:,7),1)));
df_plot(4,4) = (std(df_mid(:,7))/sqrt(size(df_mid(:,7),1)));
df_plot(4,5) = (std(df_sharedreward(:,7))/sqrt(size(df_sharedreward(:,7),1)));
errhigh_cov = df_plot(4,:);
errlow_cov = df_plot(4,:)*-1;

% Plot magnitudes on a bar graph
figure
x = 1:5;
y = [df_plot(1,:)];
bar(x,y);
title("Average signal")
xticks(1:5);
xticklabels({'Monetary', 'Social','UGDG', 'MID', 'Shared Reward' });
ylabel('Avg Signal');

hold on
er = errorbar(x,y,errlow_avg,errhigh_avg);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off

% Plot magnitudes on a bar graph
figure
x = 1:5;
y = [df_plot(1,:)];
bar(x,y);
title("Average signal")
xticks(1:5);
xticklabels({'Monetary', 'Social', 'UGDG', 'MID', 'Shared Reward' });
ylabel('Avg Signal');
ylim([6000 6450]);

hold on
er = errorbar(x,y,errlow_avg,errhigh_avg);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off

% Plot magnitudes on a bar graph
figure
x = 1:5;
y = [df_plot(2,:)];
bar(x,y);
title("Average coefficient of variation (std/mean)")
xticks(1:5);
xticklabels({'Monetary', 'Social', 'UGDG', 'MID', 'Shared Reward' });
ylabel('Avg Coefficient of Variation');

hold on
er = errorbar(x,y,errlow_cov,errhigh_cov);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
