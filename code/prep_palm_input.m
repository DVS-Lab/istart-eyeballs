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
datadir = '~/Documents/Github/istart-eyeballs/derivatives/extractions/';
addpath(datadir)

two_stim_df_left=zeros(53,5);
two_stim_df_right=zeros(53,5);
two_stim_df_left_final=zeros(53,15);
two_stim_df_right_final=zeros(53,15);

one_stim_df_left=zeros(53,4);
one_stim_df_right=zeros(53,4);
one_stim_df_left_final=zeros(53,15);
one_stim_df_right_final=zeros(53,15);

sub = {'1001', '1003', '1004', '1006', '1009', '1010', '1011', '1012', '1013', '1015', '1016', '1019', ...
    '1021', '1242', '1243', '1244', '1245', '1247', '1248', '1249', '1251', '1253', '1255', '1276', '1282', ...
    '1286', '1294', '1300', '1301', '1302', '1303', '3101', '3116', '3122', '3125', '3140', '3143', '3152', ...
    '3166', '3167', '3170', '3173', '3176', '3189', '3190', '3199', '3200', '3206', '3210', '3212', '3218', ...
    '3220', '3223'};

cb = {'IV', 'V', 'VI', 'Crus_I', 'Crus_II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis_VI', 'Vermis_VIIIa', 'Vermis_VIIIb', 'Vermis_IX'};

%cb = {'Crus_I', 'Crus_II'};

format = '%c';

%s=2;
%c=2;

%% Read in data for two stim df left
for c = 1:length(cb)
    for s = 1:length(sub)

        % Assign sub ID
        two_stim_df_left(s,1) = str2double(sub{s});
        
        % Check for doors
        f_doors = fullfile([datadir 'doors/sub-' sub{s} '_task-doors_left_cb-' cb{c} '.txt']);
        if isfile(f_doors)
            file_doors = fopen(f_doors);
            value_doors = fscanf(file_doors,format);
            two_stim_df_left(s,2) = str2double(value_doors);
        else
            two_stim_df_left(s,2) = NaN;
            disp("File "+f_doors+" does not exist");
        end

        % Check for socialdoors
        f_socialdoors = fullfile([datadir 'socialdoors/sub-' sub{s} '_task-socialdoors_left_cb-' cb{c} '.txt']);
        if isfile(f_socialdoors)
            file_socialdoors = fopen(f_socialdoors);
            value_socialdoors = fscanf(file_socialdoors,format);
            two_stim_df_left(s,3) = str2double(value_socialdoors);
        else
            two_stim_df_left(s,3) = NaN;
            disp("File "+f_socialdoors+" does not exist");
        end

        % Check for ugdg
        f_ugdg = fullfile([datadir 'ugdg/sub-' sub{s} '_task-ugdg_left_cb-' cb{c} '.txt']);
        if isfile(f_ugdg)
            file_ugdg = fopen(f_ugdg);
            value_ugdg = fscanf(file_ugdg,format);
            two_stim_df_left(s,4) = str2double(value_ugdg);
        else
            two_stim_df_left(s,4) = NaN;
            disp("File "+f_ugdg+" does not exist");
        end
        two_stim_df_left(s,5) = nanmean(two_stim_df_left(s,2:4));
    end
    two_stim_df_left_final(:,1)=two_stim_df_left(:,1);
    two_stim_df_left_final(:,c+1)=two_stim_df_left(:,5);
end

% Read in data for one stim df left
for c = 1:length(cb)
    for s = 1:length(sub)

        % Assign sub ID
        one_stim_df_left(s,1) = str2double(sub{s});
        
        % Check for mid
        f_mid = fullfile([datadir 'mid/sub-' sub{s} '_task-mid_left_cb-' cb{c} '.txt']);
        if isfile(f_mid)
            file_mid = fopen(f_mid);
            value_mid = fscanf(file_mid,format);
            one_stim_df_left(s,2) = str2double(value_mid);
        else
            one_stim_df_left(s,2) = NaN;
            disp("File "+f_mid+" does not exist");
        end

        % Check for sharedreward
        f_sharedreward = fullfile([datadir 'sharedreward/sub-' sub{s} '_task-sharedreward_left_cb-' cb{c} '.txt']);
        if isfile(f_sharedreward)
            file_sharedreward = fopen(f_sharedreward);
            value_sharedreward = fscanf(file_sharedreward,format);
            one_stim_df_left(s,3) = str2double(value_sharedreward);
        else
            one_stim_df_left(s,3) = NaN;
            disp("File "+f_sharedreward+" does not exist");
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

%% Read in data for two stim df right
for c = 1:length(cb)
    for s = 1:length(sub)

        % Assign sub ID
        two_stim_df_right(s,1) = str2double(sub{s});
        
        % Check for doors
        f_doors = fullfile([datadir 'doors/sub-' sub{s} '_task-doors_right_cb-' cb{c} '.txt']);
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
        f_socialdoors = fullfile([datadir 'socialdoors/sub-' sub{s} '_task-socialdoors_right_cb-' cb{c} '.txt']);
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
        f_ugdg = fullfile([datadir 'ugdg/sub-' sub{s} '_task-ugdg_right_cb-' cb{c} '.txt']);
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
        f_mid = fullfile([datadir 'mid/sub-' sub{s} '_task-mid_right_cb-' cb{c} '.txt']);
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
        f_sharedreward = fullfile([datadir 'sharedreward/sub-' sub{s} '_task-sharedreward_right_cb-' cb{c} '.txt']);
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
    one_stim_df_left_final(:,1)=one_stim_df_right(:,1);
    one_stim_df_left_final(:,c+1)=one_stim_df_right(:,4);
end

final_df_right=two_stim_df_right_final-one_stim_df_right_final;
final_df_right(:,1)=two_stim_df_right_final(:,1);

% Write labels
final_df_right_table = array2table(final_df_right);
final_df_right_table.Properties.VariableNames(1:15) = {'Sub', 'IV', 'V', ...
    'VI', 'Crus_I', 'Crus_II', 'VIIb', 'VIIIa', 'VIIIb', 'IX', 'X', ...
    'Vermis_VI', 'Vermis_VIIIa', 'Vermis_VIIIb', 'Vermis_IX'};
