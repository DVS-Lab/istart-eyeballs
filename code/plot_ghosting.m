clear
close all;
fclose all;
clc

% Script to combine extracted CB values for PALM -i input dataframes & to
% generate plots
% Jimmy Wyngaarden, 19 Dec 22

%% Set up dirs
% Script needs to be run from the istart-eyeballs/code directory
codedir = pwd;
cd ..
basedir=pwd;
%datadir = fullfile(basedir, 'derivatives','extractions');
%datadir = fullfile(basedir, 'derivatives','extractions_17Feb23');
datadir = fullfile(basedir, 'derivatives','imaging_plots');
cd(codedir)

% Specify subs
sub = {'1001', '1003', '1004', '1006', '1009', '1010', '1011', '1012', '1013', '1015', '1016', '1019', ...
    '1021', '1242', '1243', '1244', '1245', '1247', '1248', '1249', '1251', '1253', '1255', '1276', '1282', ...
    '1286', '1294', '1300', '1301', '1302', '1303', '3116', '3122', '3125', '3140', '3143', '3152', ...
    '3166', '3167', '3170', '3173', '3176', '3189', '3190', '3199', '3200', '3206', '3210', '3212', '3218', ...
    '3220', '3223'};

% Preallocate dataframes
df=zeros(length(sub),6);
df_full=zeros(length(sub),70);

% Specify hemisphere
%hemi = {'left', 'right'};
hemi = {'left'};

% Specify eig
eig = '0';

% Specify laterality
lat = 'ipsi';

% Specify CB regions
cb = {'IV', 'V', 'VI', 'Crus_I', 'Crus_II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis_VI', 'Vermis_VIIIa', 'Vermis_VIIIb', 'Vermis_IX'};

format = '%c';

%% Read in raw data
% First, we're going to create a dataframe that has one row for each sub
% and one column for ipsilateral eye-cb connectivity for each task in each
% subregion

for h = 1:length(hemi)
    for c = 1:length(cb)
        for s = 1:length(sub)

            % Assign sub ID
            df(s,1) = str2double(sub{s});

            task = {'doors', 'socialdoors', 'ugdg', 'mid', 'sharedreward'};
            
            % Specify filename
            for t=1:length(task)
                if strcmp(eig,'0')
                    if strcmp(lat,'ipsi')
                        f = fullfile(datadir, task{t}, ['sub-' sub{s} '_task-' task{t} '_eye-' hemi{h} '_hemi-' hemi{h} '_cb-' cb{c} '.txt']); % update this filename with new extractions
                    elseif strcmp(lat,'contra')
                        if strcmp(hemi{h},'left')
                            f = fullfile(datadir, task{t}, ['sub-' sub{s} '_task-' task{t} '_eye-right_hemi-left_cb-' cb{c} '.txt']);
                        elseif strcmp(hemi{h},'right')
                            f = fullfile(datadir, task{t}, ['sub-' sub{s} '_task-' task{t} '_eye-left_hemi-right_cb-' cb{c} '.txt']);
                        end
                    end
                elseif strcmp(eig,'1')
                    if strcmp(lat,'ipsi')
                        f = fullfile(datadir, task{t}, ['sub-' sub{s} '_task-' task{t} '_eye-' hemi{h} '_hemi-' hemi{h} '_cb-' cb{c} '_eig.txt']); % update this filename with new extractions
                    elseif strcmp(lat,'contra')
                        if strcmp(hemi{h},'left')
                            f = fullfile(datadir, task{t}, ['sub-' sub{s} '_task-' task{t} '_eye-right_hemi-left_cb-' cb{c} '_eig.txt']);
                        elseif strcmp(hemi{h},'right')
                            f = fullfile(datadir, task{t}, ['sub-' sub{s} '_task-' task{t} '_eye-left_hemi-right_cb-' cb{c} '_eig.txt']);
                        end
                    end
                end
                if isfile(f)
                    file = fopen(f);
                    value = fscanf(file,format);
                    if strcmp(task{t},'doors') 
                        df(s,2) = str2double(value);
                    elseif strcmp(task{t},'socialdoors')
                        df(s,3) = str2double(value);
                    elseif strcmp(task{t},'ugdg')
                        df(s,4) = str2double(value);
                    elseif strcmp(task{t},'mid')
                        df(s,5) = str2double(value);
                    elseif strcmp(task{t},'sharedreward')
                        df(s,6) = str2double(value);
                    else
                        disp("Task var not recognized; enter a proper task");
                    end
                else
                    disp("No data for "+f);
                    if strcmp(task{t},'doors')
                        df(s,2) = NaN;
                    elseif strcmp(task{t},'socialdoors')
                        df(s,3) = NaN;
                    elseif strcmp(task{t},'ugdg')
                        df(s,4) = NaN;
                    elseif strcmp(task{t},'mid')
                        df(s,5) = NaN;
                    elseif strcmp(task{t},'sharedreward')
                        df(s,6) = NaN;
                    else
                        disp("Task var not recognized; enter a proper task");
                    end
                end
            end
            fclose all;
        end
    end

    % Convert df to table and add column labels
    df_table = array2table(df);
    df_table.Properties.VariableNames(1:6) = {'Sub', 'doors', 'socialdoors', ...
        'ugdg', 'mid', 'sharedreward'};
        
    % Write master df (df_full) with all tasks & regions for ipsi data
    if c < 2
        df_full(:,c) = df(:,2);
        df_full(:,c+1) = df(:,3);
        df_full(:,c+2) = df(:,4);
        df_full(:,c+3) = df(:,5);
        df_full(:,c+4) = df(:,6);
    else
        df_full(:,(c-1)*5+1) = df(:,2);
        df_full(:,(c-1)*5+2) = df(:,3);
        df_full(:,(c-1)*5+3) = df(:,4);
        df_full(:,(c-1)*5+4) = df(:,5);
        df_full(:,(c-1)*5+5) = df(:,6);
    end
end
    
% Convert df to table and write column labels
df_full(df_full == 0) = NaN;
df_full_table = array2table(df_full);
df_full_table.Properties.VariableNames(1:70) = {'IV-doors', 'IV-socialdoors', ...
        'IV-ugdg', 'IV-mid', 'IV-sharedreward', ...
        'V-doors', 'V-socialdoors', 'V-ugdg', 'V-mid', 'V-sharedreward', ...
        'VI-doors', 'VI-socialdoors', 'VI-ugdg', 'VI-mid', 'VI-sharedreward', ...
        'Crus-I-doors', 'Crus-I-socialdoors', 'Crus-I-ugdg', 'Crus-I-mid', 'Crus-I-sharedreward', ...
        'Crus-II-doors', 'Crus-II-socialdoors', 'Crus-II-ugdg', 'Crus-II-mid', 'Crus-II-sharedreward', ...
        'VIIb-doors', 'VIIb-socialdoors', 'VIIb-ugdg', 'VIIb-mid', 'VIIb-sharedreward', ...
        'VIIIa-doors', 'VIIIa-socialdoors', 'VIIIa-ugdg', 'VIIIa-mid', 'VIIIa-sharedreward', ...
        'VIIIb-doors', 'VIIIb-socialdoors', 'VIIIb-ugdg', 'VIIIb-mid', 'VIIIb-sharedreward', ...
        'IX-doors', 'IX-socialdoors', 'IX-ugdg', 'IX-mid', 'IX-sharedreward', ...
        'X-doors', 'X-socialdoors', 'X-ugdg', 'X-mid', 'X-sharedreward', ...
        'Vermis-VI-doors', 'Vermis-VI-socialdoors', 'Vermis-VI-ugdg', 'Vermis-VI-mid', 'Vermis-VI-sharedreward', ...
        'Vermis-VIIIa-doors', 'Vermis-VIIIa-socialdoors', 'Vermis-VIIIa-ugdg', 'Vermis-VIIIa-mid', 'Vermis-VIIIa-sharedreward', ...
        'Vermis-VIIIb-doors', 'Vermis-VIIIb-socialdoors', 'Vermis-VIIIb-ugdg', 'Vermis-VIIIb-mid', 'Vermis-VIIIb-sharedreward', ...
        'Vermis-IX-doors', 'Vermis-IX-socialdoors', 'Vermis-IX-ugdg', 'Vermis-IX-mid', 'Vermis-IX-sharedreward'};

% Add subs to df_full_table
df_full_table.Subs = df(:,1);
df_full_table = [df_full_table(:,71) df_full_table(:,1:70)];

% Write data to .xlsx file
if strcmp(hemi{h},'left')
    filename = 'df_full_left.xlsx';
%    writetable(df_full_table,filename,'Sheet',1,'Range','A1');
elseif strcmp(hemi{h},'right')
    filename = 'df_full_right.xlsx';
%    writetable(df_full_table,filename,'Sheet',1,'Range','A1')
else
    
    % STOP: at this point you should have a var called 'df_full_table' that
    % contains the ipsilateral signal from eye to corresponding cb 
    % region. There should be 52 rows (one per sub), and 70 columns (5
    % tasks per 14 cb regions). You can manually confirm that these values
    % are correct by comparing these values to the corresponding .txt files
    % in derivatives/extractions/sub-*/sub-*

end