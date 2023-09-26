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
datadir = fullfile(basedir, 'derivatives','extractEyes');
cd(codedir)

% Specify input vars
hemi = {'left', 'right'};
sub = {'1001', '1003', '1004', '1006', '1009', '1010', '1011', '1012', '1013', '1015', '1016', '1019', ...
    '1021', '1242', '1243', '1244', '1245', '1247', '1248', '1249', '1251', '1253', '1255', '1276', '1282', ...
    '1286', '1294', '1300', '1301', '1302', '1303', '3101', '3116', '3122', '3125', '3140', '3143', '3152', ...
    '3166', '3167', '3170', '3173', '3176', '3189', '3190', '3199', '3200', '3206', '3210', '3212', '3218', ...
    '3220', '3223'};

nsub = length(sub);
%task = {'doors', 'socialdoors', 'ugdg', 'mid', 'sharedreward'};
task = {'doors', 'socialdoors'};
run = {'1', '2'};
eig = {'1', '2'};
df = zeros(1,7);
count=1;

% First: find correlation coefficient between avg & eig
% Plot: x axis = correlation coefficient, y axis = count
% df: 7 columns: (1) subID; (2) hemi; (3) task; (4) run; (5) avg; (6) eig;
% (7) correlation coefficient for avg & eig;

% Read files
for s=1:length(sub)
    for h=1:length(hemi)
        for t=1:length(task)
            for r=1:length(run)
                df(count,1)=sub{s};
                df(count,2)=hemi{h};
                df(count,3)=task{t};
                df(count,4)=run{r};
                f_avg = fullfile(datadir, ['sub-' sub{s}], ['ts_task-' task{t} '_mask-eyeball_' hemi{h} '_run-' run{r} '.txt']);
                f_eig = fullfile(datadir, ['sub-' sub{s}], ['ts_task-' task{t} '_mask-eyeball_' hemi{h} '_run-' run{r} '_eig.txt']);
                avg = mean(readmatrix(f_avg));
                df(count,5) = avg;
                eig = mean(readmatrix(f_eig));
                df(count,6) = eig;
                R = corrcoef(f_avg, f_eig);
                df(count,7) = R;
                count = count+1;
            end
        end
    end
end




