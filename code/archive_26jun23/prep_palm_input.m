clear
close all;
fclose all;
clc

% Script to combine extracted CB values for PALM -i input dataframes
% Jimmy Wyngaarden, 19 Dec 22

%% Set up dirs
%codedir = '/data/projects/istart-eyeballs/code/'; % Run code from this path.
codedir = '~/Documents/Github/istart-eyeballs/code/';
addpath(codedir)
%datadir = '/data/projects/istart-eyeballs/derivatives/extractions/';
datadir = '~/Documents/Github/istart-eyeballs/derivatives/imaging_plots/';
addpath(datadir)

sub = {'1001', '1003', '1004', '1006', '1009', '1010', '1011', '1012', '1013', '1015', '1016', '1019', ...
    '1021', '1242', '1243', '1244', '1245', '1247', '1248', '1249', '1251', '1253', '1255', '1276', '1282', ...
    '1286', '1294', '1300', '1301', '1302', '1303', '3116', '3122', '3125', '3140', '3143', '3152', ...
    '3166', '3167', '3170', '3173', '3176', '3189', '3190', '3199', '3200', '3206', '3210', '3212', '3218', ...
    '3220', '3223'};
% 3101

% Preallocate dataframes
two_stim_df_left=zeros(length(sub),6);
two_stim_df_right=zeros(length(sub),6);
two_stim_df_left_final=zeros(length(sub),15);
two_stim_df_right_final=zeros(length(sub),15);

one_stim_df_left=zeros(length(sub),6);
one_stim_df_right=zeros(length(sub),6);
one_stim_df_left_final=zeros(length(sub),15);
one_stim_df_right_final=zeros(length(sub),15);

graph_data_df_left=zeros(length(sub),6);
graph_df_left=zeros(2,70);

graph_data_df_right=zeros(length(sub),6);
graph_df_right=zeros(2,70);

h1_data_left=zeros(length(sub),14);
h1_data_right=zeros(length(sub),14);

% Specify CB regions
cb = {'IV', 'V', 'VI', 'Crus_I', 'Crus_II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis_VI', 'Vermis_VIIIa', 'Vermis_VIIIb', 'Vermis_IX'};

%cb = {'Vermis_IX'};

format = '%c';

%% Read in data for two stim df left
for c = 1:length(cb)

    for s = 1:length(sub)

        % Assign sub ID
        two_stim_df_left(s,1) = str2double(sub{s});
        two_stim_df_left(s,6) = c;
        graph_data_df_left(s,1) = str2double(sub{s});
        
        % Check for doors
        f_doors_left = fullfile([datadir 'doors/sub-' sub{s} '_task-doors_eye-left_hemi-left_cb-' cb{c} '.txt']);
        if isfile(f_doors_left)
            file_doors_left = fopen(f_doors_left);
            value_doors_left = fscanf(file_doors_left,format);
            two_stim_df_left(s,2) = str2double(value_doors_left);
            graph_data_df_left(s,2) = str2double(value_doors_left);
        else
            two_stim_df_left(s,2) = NaN;
            disp("File "+f_doors_left+" does not exist");
        end

        % Check for socialdoors
        f_socialdoors_left = fullfile([datadir 'socialdoors/sub-' sub{s} '_task-socialdoors_eye-left_hemi-left_cb-' cb{c} '.txt']);
        if isfile(f_socialdoors_left)
            file_socialdoors_left = fopen(f_socialdoors_left);
            value_socialdoors_left = fscanf(file_socialdoors_left,format);
            two_stim_df_left(s,3) = str2double(value_socialdoors_left);
            graph_data_df_left(s,3) = str2double(value_socialdoors_left);
        else
            two_stim_df_left(s,3) = NaN;
            disp("File "+f_socialdoors_left+" does not exist");
        end

        % Check for ugdg
        f_ugdg_left = fullfile([datadir 'ugdg/sub-' sub{s} '_task-ugdg_eye-left_hemi-left_cb-' cb{c} '.txt']);
        if isfile(f_ugdg_left)
            file_ugdg_left = fopen(f_ugdg_left);
            value_ugdg_left = fscanf(file_ugdg_left,format);
            two_stim_df_left(s,4) = str2double(value_ugdg_left);
            graph_data_df_left(s,4) = str2double(value_ugdg_left);
        else
            two_stim_df_left(s,4) = NaN;
            disp("File "+f_ugdg_left+" does not exist");
        end
        two_stim_df_left(s,5) = nanmean(two_stim_df_left(s,2:4));
    end
    two_stim_df_left_final(:,1) = two_stim_df_left(:,1);
    two_stim_df_left_final(:,c+1) = two_stim_df_left(:,5);
    
end

% Read in data for one stim df left
for c = 1:length(cb)
    for s = 1:length(sub)

        % Assign sub ID
        one_stim_df_left(s,1) = str2double(sub{s});
        
        % Check for mid
        f_mid_left = fullfile([datadir 'mid/sub-' sub{s} '_task-mid_eye-left_hemi-left_cb-' cb{c} '.txt']);
        if isfile(f_mid_left)
            file_mid_left = fopen(f_mid_left);
            value_mid_left = fscanf(file_mid_left,format);
            one_stim_df_left(s,2) = str2double(value_mid_left);
            graph_data_df_left(s,5) = str2double(value_mid_left);
        else
            one_stim_df_left(s,2) = NaN;
            disp("File "+f_mid_left+" does not exist");
        end

        % Check for sharedreward
        f_sharedreward_left = fullfile([datadir 'sharedreward/sub-' sub{s} '_task-sharedreward_eye-left_hemi-left_cb-' cb{c} '.txt']);
        if isfile(f_sharedreward_left)
            file_sharedreward = fopen(f_sharedreward_left);
            value_sharedreward_left = fscanf(file_sharedreward,format);
            one_stim_df_left(s,3) = str2double(value_sharedreward_left);
            graph_data_df_left(s,6) = str2double(value_sharedreward_left);
        else
            one_stim_df_left(s,3) = NaN;
            disp("File "+f_sharedreward_left+" does not exist");
        end

        one_stim_df_left(s,4) = nanmean(one_stim_df_left(s,2:3));
    end
    one_stim_df_left_final(:,1)=one_stim_df_left(:,1);
    one_stim_df_left_final(:,c+1)=one_stim_df_left(:,4);
end

final_df_left=two_stim_df_left_final-one_stim_df_left_final;
final_df_left(:,1)=two_stim_df_left_final(:,1);

% Write labels
final_df_left_table = array2table(final_df_left);
final_df_left_table.Properties.VariableNames(1:15) = {'Sub', 'IV', 'V', ...
    'VI', 'Crus_I', 'Crus_II', 'VIIb', 'VIIIa', 'VIIIb', 'IX', 'X', ...
    'Vermis_VI', 'Vermis_VIIIa', 'Vermis_VIIIb', 'Vermis_IX'};

final_df_left = final_df_left(:,2:15);
    
filename = 'extraction_data_two-one_left.xlsx';
writematrix(final_df_left,filename,'Sheet',1,'Range','A1');

%% Left: Write graph data

for c = 1:length(cb)

    for s = 1:length(sub)

        % Assign sub ID
        graph_data_df_left(s,1) = str2double(sub{s});
        
        % Check for doors
        f_doors_left = fullfile([datadir 'doors/sub-' sub{s} '_task-doors_eye-left_hemi-left_cb-' cb{c} '.txt']);
        if isfile(f_doors_left)
            file_doors_left = fopen(f_doors_left);
            value_doors_left = fscanf(file_doors_left,format);
            graph_data_df_left(s,2) = str2double(value_doors_left);
        else
            graph_data_df_left(s,2) = NaN;
            disp("File "+f_doors_left+" does not exist");
        end
        % Check for socialdoors
        f_socialdoors_left = fullfile([datadir 'socialdoors/sub-' sub{s} '_task-socialdoors_eye-left_hemi-left_cb-' cb{c} '.txt']);
        if isfile(f_socialdoors_left)
            file_socialdoors_left = fopen(f_socialdoors_left);
            value_socialdoors_left = fscanf(file_socialdoors_left,format);
            graph_data_df_left(s,3) = str2double(value_socialdoors_left);
        else
            graph_data_df_left(s,3) = NaN;
            disp("File "+f_socialdoors_left+" does not exist");
        end
        % Check for ugdg
        f_ugdg_left = fullfile([datadir 'ugdg/sub-' sub{s} '_task-ugdg_eye-left_hemi-left_cb-' cb{c} '.txt']);
        if isfile(f_ugdg_left)
            file_ugdg_left = fopen(f_ugdg_left);
            value_ugdg_left = fscanf(file_ugdg_left,format);
            graph_data_df_left(s,4) = str2double(value_ugdg_left);
        else
            graph_data_df_left(s,4) = NaN;
            disp("File "+f_ugdg_left+" does not exist");
        end
        % Check for mid
        f_mid_left = fullfile([datadir 'mid/sub-' sub{s} '_task-mid_eye-left_hemi-left_cb-' cb{c} '.txt']);
        if isfile(f_mid_left)
            file_mid_left = fopen(f_mid_left);
            value_mid_left = fscanf(file_mid_left,format);
            graph_data_df_left(s,5) = str2double(value_mid_left);
        else
            graph_data_df_left(s,5) = NaN;
            disp("File "+f_mid_left+" does not exist");
        end
        % Check for sharedreward
        f_sharedreward_left = fullfile([datadir 'sharedreward/sub-' sub{s} '_task-sharedreward_eye-left_hemi-left_cb-' cb{c} '.txt']);
        if isfile(f_sharedreward_left)
            file_sharedreward = fopen(f_sharedreward_left);
            value_sharedreward_left = fscanf(file_sharedreward,format);
            graph_data_df_left(s,6) = str2double(value_sharedreward_left);
        else
            graph_data_df_left(s,6) = NaN;
            disp("File "+f_sharedreward_left+" does not exist");
        end
    end
    if c < 2
        graph_df_left(1,c) = nanmean(graph_data_df_left(:,2));
        graph_df_left(1,c+1) = nanmean(graph_data_df_left(:,3));
        graph_df_left(1,c+2) = nanmean(graph_data_df_left(:,4));
        graph_df_left(1,c+3) = nanmean(graph_data_df_left(:,5));
        graph_df_left(1,c+4) = nanmean(graph_data_df_left(:,6));
        graph_df_left(2,c) = 1;
        graph_df_left(2,c+1) = 2;
        graph_df_left(2,c+2) = 3;
        graph_df_left(2,c+3) = 4;
        graph_df_left(2,c+4) = 5;
        h1_data_left(:,c) = graph_data_df_left(:,2);
        h1_data_left(:,c+1) = graph_data_df_left(:,3);
        h1_data_left(:,c+2) = graph_data_df_left(:,4);
        h1_data_left(:,c+3) = graph_data_df_left(:,5);
        h1_data_left(:,c+4) = graph_data_df_left(:,6);
    else
        graph_df_left(1,((c-1)*5+1)) = nanmean(graph_data_df_left(:,2));
        graph_df_left(1,((c-1)*5)+2) = nanmean(graph_data_df_left(:,3));
        graph_df_left(1,((c-1)*5)+3) = nanmean(graph_data_df_left(:,4));
        graph_df_left(1,((c-1)*5)+4) = nanmean(graph_data_df_left(:,5));
        graph_df_left(1,((c-1)*5)+5) = nanmean(graph_data_df_left(:,6));
        graph_df_left(2,((c-1)*5+1)) = 1;
        graph_df_left(2,((c-1)*5)+2) = 2;
        graph_df_left(2,((c-1)*5)+3) = 3;
        graph_df_left(2,((c-1)*5)+4) = 4;
        graph_df_left(2,((c-1)*5)+5) = 5;
        h1_data_left(:,(c-1)*5+1) = graph_data_df_left(:,2);
        h1_data_left(:,(c-1)*5+2) = graph_data_df_left(:,3);
        h1_data_left(:,(c-1)*5+3) = graph_data_df_left(:,4);
        h1_data_left(:,(c-1)*5+4) = graph_data_df_left(:,5);
        h1_data_left(:,(c-1)*5+5) = graph_data_df_left(:,6);
    end
    %h1_data_left(isnan(h1_data_left))=1;
    fclose all
end

h1_filename_left = 'h1-1_data_left_6jan23.xlsx';
writematrix(h1_data_left,h1_filename_left,'Sheet',1,'Range','A1');

figure
x = 1:14;
y = [graph_df_left(1,1:5); graph_df_left(1,6:10); graph_df_left(1,11:15); graph_df_left(1,16:20); graph_df_left(1,21:25); graph_df_left(1,26:30); ...
    graph_df_left(1,31:35); graph_df_left(1,36:40); graph_df_left(1,41:45); graph_df_left(1,46:50); graph_df_left(1,51:55); graph_df_left(1,56:60); ...
    graph_df_left(1,61:65); graph_df_left(1,66:70)];
b = bar(x,y,'FaceColor','flat');
title('Left Hemisphere: Eye/CB Connectivity by Task');
xticks(1:14);
xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
ylabel('zstat');
xlabel('CB Subregion');
xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
ylim([-.5 .2]);
leg = {'Doors','Socialdoors','UGDG','MID','SharedReward'};
legend(leg,'Location','southwest');

% UPDATE NEEDED HERE: Add error bars
% hold on
% 
% e1=[(std(data_mat.Doors_Win_RT_t1)/sqrt(length(data_mat.Doors_Win_RT_t1))) (std(data_mat.Doors_Loss_RT_t1)/sqrt(length(data_mat.Doors_Loss_RT_t1))) ; (std(data_mat.Social_Win_RT_t1)/sqrt(length(data_mat.Social_Win_RT_t1))) (std(data_mat.Social_Loss_RT_t1)/sqrt(length(data_mat.Social_Loss_RT_t1))) ];
% ngroups = size(bar_data, 1);
% nbars = size(bar_data, 2);
% 
% % Calculating the width for each bar group
% groupwidth = min(0.8, nbars/(nbars + 1.5));
% for i = 1:nbars
%     x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
%     errorbar(x, bar_data(:,i), e1(:,i), 'ko');
% end

hold off


%% Read in data for two stim df right
for c = 1:length(cb)
    for s = 1:length(sub)

        % Assign sub ID
        two_stim_df_right(s,1) = str2double(sub{s});
        two_stim_df_right(s,6) = c;
        
        % Check for doors
        f_doors = fullfile([datadir 'doors/sub-' sub{s} '_task-doors_eye-right_hemi-right_cb-' cb{c} '.txt']);
        if isfile(f_doors)
            file_doors = fopen(f_doors);
            value_doors = fscanf(file_doors,format);
            fclose(file_doors);
            two_stim_df_right(s,2) = str2double(value_doors);
        else
            two_stim_df_right(s,2) = NaN;
            disp("File "+f_doors+" does not exist");
        end

        % Check for socialdoors
        f_socialdoors = fullfile([datadir 'socialdoors/sub-' sub{s} '_task-socialdoors_eye-right_hemi-right_cb-' cb{c} '.txt']);
        if isfile(f_socialdoors)
            file_socialdoors = fopen(f_socialdoors);
            value_socialdoors = fscanf(file_socialdoors,format);
            fclose(file_socialdoors);
            two_stim_df_right(s,3) = str2double(value_socialdoors);
        else
            two_stim_df_right(s,3) = NaN;
            disp("File "+f_socialdoors+" does not exist");
        end

        % Check for ugdg
        f_ugdg = fullfile([datadir 'ugdg/sub-' sub{s} '_task-ugdg_eye-right_hemi-right_cb-' cb{c} '.txt']);
        if isfile(f_ugdg)
            file_ugdg = fopen(f_ugdg);
            value_ugdg = fscanf(file_ugdg,format);
            fclose(file_ugdg);
            two_stim_df_right(s,4) = str2double(value_ugdg);
        else
            two_stim_df_right(s,4) = NaN;
            disp("File "+f_ugdg+" does not exist");
        end
        two_stim_df_right(s,5) = nanmean(two_stim_df_right(s,2:4));
    end
    two_stim_df_right_final(:,1)=two_stim_df_right(:,1);
    two_stim_df_right_final(:,c+1)=two_stim_df_right(:,5);
end

% Read in data for one stim df left
for c = 1:length(cb)
    for s = 1:length(sub)

        % Assign sub ID
        one_stim_df_right(s,1) = str2double(sub{s});
        
        % Check for mid
        f_mid = fullfile([datadir 'mid/sub-' sub{s} '_task-mid_eye-right_hemi-right_cb-' cb{c} '.txt']);
        if isfile(f_mid)
            file_mid = fopen(f_mid);
            value_mid = fscanf(file_mid,format);
            fclose(file_mid);
            one_stim_df_right(s,2) = str2double(value_mid);
        else
            one_stim_df_right(s,2) = NaN;
            disp("File "+f_mid+" does not exist");
        end

        % Check for sharedreward
        f_sharedreward = fullfile([datadir 'sharedreward/sub-' sub{s} '_task-sharedreward_eye-right_hemi-right_cb-' cb{c} '.txt']);
        if isfile(f_sharedreward)
            file_sharedreward = fopen(f_sharedreward);
            value_sharedreward = fscanf(file_sharedreward,format);
            fclose(file_sharedreward);
            one_stim_df_right(s,3) = str2double(value_sharedreward);
        else
            one_stim_df_right(s,3) = NaN;
            disp("File "+f_sharedreward+" does not exist");
        end

        one_stim_df_right(s,4) = nanmean(one_stim_df_right(s,2:3));
    end
    one_stim_df_left_final(:,1) = one_stim_df_right(:,1);
    one_stim_df_left_final(:,c+1) = one_stim_df_right(:,4);
end

final_df_right = two_stim_df_right_final-one_stim_df_right_final;
final_df_right(:,1) = two_stim_df_right_final(:,1);

% Write labels
final_df_right_table = array2table(final_df_right);
final_df_right_table.Properties.VariableNames(1:15) = {'Sub', 'IV', 'V', ...
    'VI', 'Crus_I', 'Crus_II', 'VIIb', 'VIIIa', 'VIIIb', 'IX', 'X', ...
    'Vermis_VI', 'Vermis_VIIIa', 'Vermis_VIIIb', 'Vermis_IX'};

final_df_right = final_df_right(:,2:15);

filename = 'extraction_data_two-one_right.xlsx';
writematrix(final_df_right,filename,'Sheet',1,'Range','A1');

%% Right: Write graph data (all 5 tasks in each ROI)

for c = 1:length(cb)

    for s = 1:length(sub)

        % Assign sub ID
        graph_data_df_right(s,1) = str2double(sub{s});
        
        % Check for doors
        f_doors_right = fullfile([datadir 'doors/sub-' sub{s} '_task-doors_eye-right_hemi-right_cb-' cb{c} '.txt']);
        if isfile(f_doors_right)
            file_doors_right = fopen(f_doors_right);
            value_doors_right = fscanf(file_doors_right,format);
            graph_data_df_right(s,2) = str2double(value_doors_right);
        else
            graph_data_df_right(s,2) = NaN;
            disp("File "+f_doors_right+" does not exist");
        end
        % Check for socialdoors
        f_socialdoors_right = fullfile([datadir 'socialdoors/sub-' sub{s} '_task-socialdoors_eye-right_hemi-right_cb-' cb{c} '.txt']);
        if isfile(f_socialdoors_right)
            file_socialdoors_right = fopen(f_socialdoors_right);
            value_socialdoors_right = fscanf(file_socialdoors_right,format);
            graph_data_df_right(s,3) = str2double(value_socialdoors_right);
        else
            graph_data_df_right(s,3) = NaN;
            disp("File "+f_socialdoors_right+" does not exist");
        end
        % Check for ugdg
        f_ugdg_right = fullfile([datadir 'ugdg/sub-' sub{s} '_task-ugdg_eye-right_hemi-right_cb-' cb{c} '.txt']);
        if isfile(f_ugdg_right)
            file_ugdg_right = fopen(f_ugdg_right);
            value_ugdg_right = fscanf(file_ugdg_right,format);
            graph_data_df_right(s,4) = str2double(value_ugdg_right);
        else
            graph_data_df_right(s,4) = NaN;
            disp("File "+f_ugdg_right+" does not exist");
        end
        % Check for mid
        f_mid_right = fullfile([datadir 'mid/sub-' sub{s} '_task-mid_eye-right_hemi-right_cb-' cb{c} '.txt']);
        if isfile(f_mid_right)
            file_mid_right = fopen(f_mid_right);
            value_mid_right = fscanf(file_mid_right,format);
            graph_data_df_right(s,5) = str2double(value_mid_right);
        else
            graph_data_df_right(s,5) = NaN;
            disp("File "+f_mid_right+" does not exist");
        end
        % Check for sharedreward
        f_sharedreward_right = fullfile([datadir 'sharedreward/sub-' sub{s} '_task-sharedreward_eye-right_hemi-right_cb-' cb{c} '.txt']);
        if isfile(f_sharedreward_right)
            file_sharedreward_right = fopen(f_sharedreward_right);
            value_sharedreward_right = fscanf(file_sharedreward_right,format);
            graph_data_df_right(s,6) = str2double(value_sharedreward_right);
        else
            graph_data_df_right(s,6) = NaN;
            disp("File "+f_sharedreward_right+" does not exist");
        end
    end
    if c < 2
        graph_df_right(1,c) = nanmean(graph_data_df_right(:,2));
        graph_df_right(1,c+1) = nanmean(graph_data_df_right(:,3));
        graph_df_right(1,c+2) = nanmean(graph_data_df_right(:,4));
        graph_df_right(1,c+3) = nanmean(graph_data_df_right(:,5));
        graph_df_right(1,c+4) = nanmean(graph_data_df_right(:,6));
        graph_df_right(2,c) = 1;
        graph_df_right(2,c+1) = 2;
        graph_df_right(2,c+2) = 3;
        graph_df_right(2,c+3) = 4;
        graph_df_right(2,c+4) = 5;
        h1_data_right(:,c) = graph_data_df_right(:,2);
        h1_data_right(:,c+1) = graph_data_df_right(:,3);
        h1_data_right(:,c+2) = graph_data_df_right(:,4);
        h1_data_right(:,c+3) = graph_data_df_right(:,5);
        h1_data_right(:,c+4) = graph_data_df_right(:,6);
    else
        graph_df_right(1,((c-1)*5+1)) = nanmean(graph_data_df_right(:,2));
        graph_df_right(1,((c-1)*5)+2) = nanmean(graph_data_df_right(:,3));
        graph_df_right(1,((c-1)*5)+3) = nanmean(graph_data_df_right(:,4));
        graph_df_right(1,((c-1)*5)+4) = nanmean(graph_data_df_right(:,5));
        graph_df_right(1,((c-1)*5)+5) = nanmean(graph_data_df_right(:,6));
        graph_df_right(2,((c-1)*5+1)) = 1;
        graph_df_right(2,((c-1)*5)+2) = 2;
        graph_df_right(2,((c-1)*5)+3) = 3;
        graph_df_right(2,((c-1)*5)+4) = 4;
        graph_df_right(2,((c-1)*5)+5) = 5;
        h1_data_right(:,(c-1)*5+1) = graph_data_df_right(:,2);
        h1_data_right(:,(c-1)*5+2) = graph_data_df_right(:,3);
        h1_data_right(:,(c-1)*5+3) = graph_data_df_right(:,4);
        h1_data_right(:,(c-1)*5+4) = graph_data_df_right(:,5);
        h1_data_right(:,(c-1)*5+5) = graph_data_df_right(:,6);
    end
    %h1_data_right(isnan(h1_data_right))=0;
    fclose all
end

h1_filename_right = 'h1-1_data_right_6jan23.xlsx';
writematrix(h1_data_right,h1_filename_right,'Sheet',1,'Range','A1');

figure
x = 1:14;
y = [graph_df_right(1,1:5); graph_df_right(1,6:10); graph_df_right(1,11:15); graph_df_right(1,16:20); graph_df_right(1,21:25); graph_df_right(1,26:30); ...
    graph_df_right(1,31:35); graph_df_right(1,36:40); graph_df_right(1,41:45); graph_df_right(1,46:50); graph_df_right(1,51:55); graph_df_right(1,56:60); ...
    graph_df_right(1,61:65); graph_df_right(1,66:70)];
b = bar(x,y,'FaceColor','flat');
title('Right Hemisphere: Eye/CB Connectivity by Task');
xticks(1:14);
xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
ylabel('zstat');
xlabel('CB Subregion');
xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
ylim([-.5 .2]);
leg = {'Doors','Socialdoors','UGDG','MID','SharedReward'};
legend(leg,'Location','southwest');

%% Right: Write graph data (two-stim vs one-stim for each ROI)

filename = 'OHBM_Fig2_data.xlsx';
OHBM_Fig2_data = readmatrix(filename);

figure
x = 1:14;
y = [OHBM_Fig2_data(1,1:2); OHBM_Fig2_data(1,3:4); OHBM_Fig2_data(1,5:6); OHBM_Fig2_data(1,7:8); OHBM_Fig2_data(1,9:10); OHBM_Fig2_data(1,11:12); ...
    OHBM_Fig2_data(1,13:14); OHBM_Fig2_data(1,15:16); OHBM_Fig2_data(1,17:18); OHBM_Fig2_data(1,19:20); OHBM_Fig2_data(1,21:22); OHBM_Fig2_data(1,23:24); ...
    OHBM_Fig2_data(1,25:26); OHBM_Fig2_data(1,27:28)];
b = bar(y,'grouped');
title('Right Hemisphere: Eye/CB Connectivity by Task');
xticks(1:14);
xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
ylabel('zstat');
xlabel('CB Subregion');
xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
ylim([-.3 .1]);
leg = {'Two-stim','One-stim'};
legend(leg,'Location','southwest');

e1 = [OHBM_Fig2_data(2,1:2); OHBM_Fig2_data(2,3:4); OHBM_Fig2_data(2,5:6); OHBM_Fig2_data(2,7:8); OHBM_Fig2_data(2,9:10); OHBM_Fig2_data(2,11:12); ...
    OHBM_Fig2_data(2,13:14); OHBM_Fig2_data(2,15:16); OHBM_Fig2_data(2,17:18); OHBM_Fig2_data(2,19:20); OHBM_Fig2_data(2,21:22); OHBM_Fig2_data(2,23:24); ...
    OHBM_Fig2_data(2,25:26); OHBM_Fig2_data(2,27:28)];
e2 = e1*-1;

hold on
[ngroups,nbars] = size(y);

x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

errorbar(x',y,e1,'k','linestyle','none');
hold off

% UPDATE NEEDED HERE: Add error bars
hold on
ngroups = size(y, 1);
nbars = size(y, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
%for i = 1:nbars
%    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
%    errorbar(x, y(:,i), err(:,i), '.');
%end
hold off

%% Right: Write graph data (two-stim > one-stim for each ROI)

filename = 'OHBM_Fig2_data_two-one_palm.xlsx';
OHBM_Fig2_data = readmatrix(filename);

figure
x = 1:14;
y = [OHBM_Fig2_data(1,1:14)];
b = bar(y);
title('Right Hemisphere: Eye/CB Connectivity by Task');
xticks(1:14);
xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
ylabel('zstat, two stim > one stim');
xlabel('CB Subregion');
%xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
ylim([-.225 .075]);

e1 = [OHBM_Fig2_data(2,1:14)];
e2 = e1*-1;

hold on

er = errorbar(x,y,e1,e2);
er.Color = [0 0 0];
er.LineStyle = 'none';

hold off


%% Write covariate info

% two_stim_cov_df_left=zeros(length(sub),5);
% two_stim_cov_df_right=zeros(length(sub),5);
% two_stim_cov_df_left_final=zeros(length(sub),15);
% two_stim_cov_df_right_final=zeros(length(sub),15);
% 
% one_stim_cov_df_left=zeros(length(sub),4);
% one_stim_cov_df_right=zeros(length(sub),4);
% one_stim_cov_df_left_final=zeros(length(sub),15);
% one_stim_cov_df_right_final=zeros(length(sub),15);
% 
% % Assign sub ID
% two_stim_cov_df_left(s,1) = str2double(sub{s});
% 
% % Read data
% sourcedata_doors = fullfile([codedir 'gsr_data_doors.csv']);
% cov_doors = readtable(sourcedata_doors,'FileType','delimitedtext');
% cov_doors = cov_doors(cov_doors.ID~=3101);
%     
% sourcedata_socialdoors = fullfile([codedir 'gsr_data_socialdoors.csv']);
% cov_socialdoors = readtable(sourcedata_socialdoors,'FileType','delimitedtext');
%     
% sourcedata_ugdg = fullfile([codedir 'gsr_data_ugdg.csv']);
% cov_ugdg = readtable(sourcedata_ugdg,'FileType','delimitedtext');
%     
% two_stim_cov_df_left(:,1) = cov_doors.ID;
% 
% % gsr doors, socialdoors, ugdg (avg)
% two_stim_cov_df_left(:,2) = cov_doors.gsr_y;
% two_stim_cov_df_left(:,3) = cov_socialdoors.gsr_y;
% two_stim_cov_df_left(:,4) = cov_ugdg.gsr_y;
% two_stim_cov_df_left(:,5) = mean(two_stim_cov_df_left(:,2:5));
% 
% % tsnr doors, socialdoors, ugdg (avg, then take contrast)
% two_stim_cov_df_left(:,6) = cov_doors(:,3);
% two_stim_cov_df_left(:,7) = cov_socialdoors(:,3);
% two_stim_cov_df_left(:,8) = cov_ugdg(:,3);
% two_stim_cov_df_left(:,9) = mean(cov_doors(:,6:8));
% 
% % fd_mean doors, socialdoors, ugdg (avg, then take contrast)
% two_stim_cov_df_left(:,10) = cov_doors(:,4);
% two_stim_cov_df_left(:,11) = cov_socialdoors(:,4);
% two_stim_cov_df_left(:,12) = cov_ugdg(:,4);
% two_stim_cov_df_left(:,13) = mean(cov_doors(:,10:12));

%for s = 1:length(sub)       
%end

% one_stim_df_left_final(:,1)=one_stim_df_left(:,1);
% one_stim_df_left_final(:,c+1)=one_stim_df_left(:,4);
% 
% 
% final_df_left=two_stim_df_left_final-one_stim_df_left_final;
% final_df_left(:,1)=two_stim_df_left_final(:,1);
% 
% % Write labels
% final_df_left_table = array2table(final_df_left);
% final_df_left_table.Properties.VariableNames(1:15) = {'Sub', 'IV', 'V', ...
%     'VI', 'Crus_I', 'Crus_II', 'VIIb', 'VIIIa', 'VIIIb', 'IX', 'X', ...
%     'Vermis_VI', 'Vermis_VIIIa', 'Vermis_VIIIb', 'Vermis_IX'};
% 
% final_df_left = final_df_left(:,2:15);
%     
% filename = 'extraction_data_two-one_left.xlsx';
% writematrix(final_df_left,filename,'Sheet',1,'Range','A1');
