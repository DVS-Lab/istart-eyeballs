clear
close all;
fclose all;
clc

% Script to combine extracted CB values for PALM -i input dataframes & to
% generate plots
% Jimmy Wyngaarden, 19 Dec 22
% Updated 25 Apr 23

%% Set up dirs
% Script needs to be run from the istart-eyeballs/code directory
codedir = pwd;
cd ..
basedir=pwd;
datadir = fullfile(basedir, 'derivatives','imaging_plots');
cd(codedir)
% Locations from past iterations:
%datadir = fullfile(basedir, 'derivatives','extractions');
%datadir = fullfile(basedir, 'derivatives','extractions_17Feb23');

% Specify subs
sub = {'1001', '1003', '1004', '1006', '1009', '1010', '1011', '1012', '1013', '1015', '1016', '1019', ...
    '1021', '1242', '1243', '1244', '1245', '1247', '1248', '1249', '1251', '1253', '1255', '1276', '1282', ...
    '1286', '1294', '1300', '1301', '1302', '1303', '3101', '3116', '3122', '3125', '3140', '3143', '3152', ...
    '3166', '3167', '3170', '3173', '3176', '3189', '3190', '3199', '3200', '3206', '3210', '3212', '3218', ...
    '3220', '3223'};
nsub = length(sub);

% Preallocate dataframes
df=zeros(length(sub),6);
df_full=zeros(length(sub),70);
df_contra=df;
df_contra_full=df_full;
df_leftEye_leftHemi=df_full;
df_rightEye_rightHemi=df_full;
df_leftEye_rightHemi=df_contra_full;
df_rightEye_leftHemi=df_contra_full;

% Specify hemisphere (need to have both L & R for all plots to work right
% now)
hemi = {'left', 'right'};

% Specify CB regions
cb = {'IV', 'V', 'VI', 'Crus_I', 'Crus_II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis_VI', 'Vermis_VIIIa', 'Vermis_VIIIb', 'Vermis_IX'};

% Specify eig (0=non-eig, 1=eig)
eig = '0'; 

format = '%c';

%% Read in raw data
% First, we're going to create ipsilateral and contralateral dataframes 
% that have one row for each sub and one column for eye-cb connectivity 
% for each task in each cb subregion

for h = 1:length(hemi)
    for c = 1:length(cb)
        for s = 1:length(sub)

            % Assign sub ID
            df(s,1) = str2double(sub{s});

            task = {'doors', 'socialdoors', 'ugdg', 'mid', 'sharedreward'};
            
            % Extract ipsilateral connectivity values for each sub in each task
            for t=1:length(task)
                if strcmp(eig,'0')
                    f = fullfile(datadir, task{t}, ['sub-' sub{s} '_task-' task{t} '_eye-' hemi{h} '_hemi-' hemi{h} '_cb-' cb{c} '.txt']);
                elseif strcmp(eig,'1')    
                    f = fullfile(datadir, task{t}, ['sub-' sub{s} '_task-' task{t} '_eye-' hemi{h} '_hemi-' hemi{h} '_cb-' cb{c} '_eig.txt']);
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
                    %disp("No data for "+f);
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
            
            % Add contralateral data
            for t=1:length(task)
                if hemi{h} == "left"
                    f = fullfile(datadir, task{t}, ['sub-' sub{s} '_task-' task{t} '_eye-left_hemi-right_cb-' cb{c} '.txt']);
                elseif hemi{h} == "right"
                    f = fullfile(datadir, task{t}, ['sub-' sub{s} '_task-' task{t} '_eye-right_hemi-left_cb-' cb{c} '.txt']);
                else
                    disp("Task var not recognized; enter a proper task");
                end

                if isfile(f)
                    file = fopen(f);
                    value = fscanf(file,format);
                    if strcmp(task{t},'doors') 
                        df_contra(s,2) = str2double(value);
                    elseif strcmp(task{t},'socialdoors')
                        df_contra(s,3) = str2double(value);
                    elseif strcmp(task{t},'ugdg')
                        df_contra(s,4) = str2double(value);
                    elseif strcmp(task{t},'mid')
                        df_contra(s,5) = str2double(value);
                    elseif strcmp(task{t},'sharedreward')
                        df_contra(s,6) = str2double(value);
                    else
                        disp("Task var not recognized; enter a proper task");
                    end
                else
                    %disp("No data for "+f);
                    if strcmp(task{t},'doors')
                        df_contra(s,2) = NaN;
                    elseif strcmp(task{t},'socialdoors')
                        df_contra(s,3) = NaN;
                    elseif strcmp(task{t},'ugdg')
                        df_contra(s,4) = NaN;
                    elseif strcmp(task{t},'mid')
                        df_contra(s,5) = NaN;
                    elseif strcmp(task{t},'sharedreward')
                        df_contra(s,6) = NaN;
                    else
                        disp("Task var not recognized; enter a proper task");
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

        % Write master df (df_contra_full) with all tasks & regions for
        % contra data
        if c < 2
            df_contra_full(:,c) = df_contra(:,2);
            df_contra_full(:,c+1) = df_contra(:,3);
            df_contra_full(:,c+2) = df_contra(:,4);
            df_contra_full(:,c+3) = df_contra(:,5);
            df_contra_full(:,c+4) = df_contra(:,6);
        else
            df_contra_full(:,(c-1)*5+1) = df_contra(:,2);
            df_contra_full(:,(c-1)*5+2) = df_contra(:,3);
            df_contra_full(:,(c-1)*5+3) = df_contra(:,4);
            df_contra_full(:,(c-1)*5+4) = df_contra(:,5);
            df_contra_full(:,(c-1)*5+5) = df_contra(:,6);
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

    % Convert contralateral df to table and write column labels
    df_contra_full(df_contra_full == 0) = NaN;
    df_contra_full_table = array2table(df_contra_full);
    df_contra_full_table.Properties.VariableNames(1:70) = df_full_table.Properties.VariableNames(2:71);

    % Add subs to df_contra_full_table
    df_contra_full_table.Subs = df(:,1);
    df_contra_full_table = [df_contra_full_table(:,71) df_contra_full_table(:,1:70)];

    % Write data to .xlsx file
    if strcmp(hemi{h},'left')
        if strcmp(eig,'0')
            filename = 'df_full_left.xlsx';
            contra_filename = 'df_contra_full_left.xlsx';
        elseif strcmp(eig,'1')
            filename = 'df_full_left_eig.xlsx';
        end
        writetable(df_full_table,filename,'Sheet',1,'Range','A1');
        writetable(df_contra_full_table,contra_filename,'Sheet',1,'Range','A1');
    elseif strcmp(hemi{h},'right')
        if strcmp(eig,'0')
            filename = 'df_full_right.xlsx';
            contra_filename = 'df_contra_full_right.xlsx';
        elseif strcmp(eig,'1')
            filename = 'df_full_right_eig.xlsx';
        end
        writetable(df_full_table,filename,'Sheet',1,'Range','A1')
        writetable(df_contra_full_table,contra_filename,'Sheet',1,'Range','A1');
    else
    
    % STOP: at this point you should have a var called 'df_full_table' that
    % contains the ipsilateral signal from eye to corresponding cb 
    % region. There should be 52 rows (one per sub), and 70 columns (5
    % tasks per 14 cb regions). You can manually confirm that these values
    % are correct by comparing these values to the corresponding .txt files
    % in derivatives/extractions/sub-*/sub-*

    end

    %% Plot df_full
    % Plot: y-axis = signal, x-axis = one bar for each task/subregion

    % Append average signal and error to last row of df_full
    for k=1:length(df_full(1,:))
        df_full(nsub+1,k)=mean(df_full(1:nsub,k),"omitnan");
        df_full(nsub+2,k)=(std(df_full(1:nsub,k),"omitnan"))/sqrt(nsub);
    end

    figure
    
    % Specify data
    y = [df_full(nsub+1,1:5); df_full(nsub+1,6:10); df_full(nsub+1,11:15); df_full(nsub+1,16:20); df_full(nsub+1,21:25); df_full(nsub+1,26:30); ...
        df_full(nsub+1,31:35); df_full(nsub+1,36:40); df_full(nsub+1,41:45); df_full(nsub+1,46:50); df_full(nsub+1,51:55); df_full(nsub+1,56:60); ...
        df_full(nsub+1,61:65); df_full(nsub+1,66:70)];
    bar(y,'grouped');
    if strcmp(hemi{h},'left')
        if strcmp(eig,'0')
            title('Left Ipsilateral Eye/CB Connectivity by Task');
        elseif strcmp(eig,'1')
            title('Left Ipsilateral Eye/CB Connectivity by Task (Eig)');
        end
    else
        if strcmp(eig,'0')
            title('Right Ipsilateral Eye/CB Connectivity by Task');
        elseif strcmp(eig,'1')
            title('Right Ipsilateral Eye/CB Connectivity by Task (Eig)');
        end
    end
    xticks(1:14);
    xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
        'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
    ylabel('zstat');
    xlabel('CB Subregion');
    xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
    ylim([-.5 .3]);
    leg = {'doors', 'socialdoors', 'ugdg', 'mid', 'sharedreward'};
    legend(leg,'Location','southwest');
    
    % Add error bars (standard error)
    %e1 = [df_full(54,1:5); df_full(54,6:10); df_full(54,11:15); df_full(54,16:20); df_full(54,21:25); df_full(54,26:30); ...
    %    df_full(54,31:35); df_full(54,36:40); df_full(54,41:45); df_full(54,46:50); df_full(54,51:55); df_full(54,56:60); ...
    %    df_full(54,61:65); df_full(54,66:70)];
    %hold on
    %[ngroups,nbars] = size(y);
    %x = nan(nbars, ngroups);
    %for i = 1:nbars
    %    x(i,:) = b(i).XEndPoints;
    %end    
    %errorbar(x',y,e1,'k','linestyle','none');
    %hold off

    %% Make df for H1.1 (avg across tasks)
    % Now we're going to average across tasks within cb subregions (i.e., one
    % row per sub, one column per cb

    % Preallocate df
    h1_data=zeros(length(sub),14);

    % Calculate mean across tasks within cb subregions and write to h1_data
    for s=1:length(sub)    
        for j=1:length(h1_data(1,:))
            if j<2
                h1_data(s,j)=mean(df_full(s,j:j+4),"omitnan");
            else
                h1_data(s,j)=mean(df_full(s,((j-1)*5)+1:((j-1)*5)+5),"omitnan");
            end
        end
    end

    % Convert to table and write column labels
    h1_data_table=array2table(h1_data);
    h1_data_table.Properties.VariableNames(1:14) = {'IV_avg', 'V_avg', 'VI_avg', ...
        'Crus_I_avg', 'Crus_II_avg', 'VIIb_avg', 'VIIIa_avg', 'VIIIb_avg', ...
        'IX_avg', 'X_avg', 'Vermis_VI_avg', 'Vermis_VIIIa_avg', 'Vermis_VIIIb_avg', ...
        'Vermis_IX_avg'};

    % Write data to .xlsx file
    if strcmp(hemi{h},'left')
        if strcmp(eig,'0')
            filename = 'h1_data_left.xlsx';
        elseif strcmp(eig,'1')
            filename = 'h1_data_left_eig.xlsx';
        end
        writetable(h1_data_table,filename,'Sheet',1,'Range','A1');
    elseif strcmp(hemi{h},'right')
        if strcmp(eig,'0')
            filename = 'h1_data_right.xlsx';
        elseif strcmp(eig,'1')
            filename = 'h1_data_right_eig.xlsx';
        end
        writetable(h1_data_table,filename,'Sheet',1,'Range','A1')
    else
    end

    % STOP: at this point you should have a var called 'h1_data_table' that
    % has one row per sub and one column per cb subregion, where each cell
    % value corresponds to the average signal for that sub/cb region across
    % all 5 tasks. You can manually confirm these values by opening
    % df_full_table.xlsx and averaging across columns

    %% Plot h1_data
    % Plot: y-axis = signal, x-axis = one bar for each task/subregion

    % Append average signal and error to last row of df_full
    for k=1:length(h1_data(1,:))
        h1_data(nsub+1,k)=mean(h1_data(1:nsub,k),"omitnan");
        h1_data(nsub+2,k)=(std(h1_data(1:nsub,k),"omitnan"))/sqrt(nsub);
    end
    
    % Add error bars (standard error)
    e1 = [h1_data(nsub+2,:)];
    e2 = e1*-1;

    figure
    
    % Specify data
    x = 1:14;
    y = [h1_data(nsub+1,:)];
    bar(x,y);
    if strcmp(hemi{h},'left')
        if strcmp(eig,'0')
            title('Avg Left Ipsilateral Eye/CB Connectivity by CB');
        elseif strcmp(eig,'1')
            title('Avg Left Ipsilateral Eye/CB Connectivity by CB (Eig)');
        end
    else
        if strcmp(eig,'0')
            title('Avg Right Ipsilateral Eye/CB Connectivity by CB');
        elseif strcmp(eig,'1')
            title('Avg Right Ipsilateral Eye/CB Connectivity by CB (Eig)');
        end
    end
    xticks(1:14);
    xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
        'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
    ylabel('5-Task Avg (zstat)');
    xlabel('CB Subregion');
    %xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
    ylim([-.25 .15]);

    hold on
    er = errorbar(x,y,e1,e2);
    er.Color = [0 0 0];
    er.LineStyle = 'none';

    hold off

    %% Make df for H2 (two-stim > one-stim)
    % Now we're going to contrast tasks within cb subregions (i.e., one
    % row per sub, one column per cb

    % Preallocate df
    h2_data=zeros(length(sub),14);

    % Calculate mean across tasks within cb subregions and write to h1_data
    for s=1:length(sub)    
        for j=1:length(h2_data(1,:))
            if j<2
                h2_data(s,j)=(mean(df_full(s,j:j+2),"omitnan"))-(mean(df_full(s,j+3:j+4),"omitnan"));
            else
                h2_data(s,j)=(mean(df_full(s,((j-1)*5)+1:((j-1)*5)+3),"omitnan"))-(mean(df_full(s,((j-1)*5)+4:((j-1)*5)+5),"omitnan"));
            end
        end
    end

    % Convert to table and write column labels
    h2_data_table=array2table(h2_data);
    h2_data_table.Properties.VariableNames(1:14) = {'IV_2>1', 'V_2>1', 'VI_2>1', ...
        'Crus_I_2>1', 'Crus_II_2>1', 'VIIb_2>1', 'VIIIa_2>1', 'VIIIb_2>1', ...
        'IX_2>1', 'X_2>1', 'Vermis_VI_2>1', 'Vermis_VIIIa_2>1', 'Vermis_VIIIb_2>1', ...
        'Vermis_IX_2>1'};

    % Write data to .xlsx file
    if strcmp(hemi{h},'left')
        if strcmp(eig,'0')
            h2_data_left = h2_data;
            h2_data_table_left = h2_data_table;
            filename = 'h2_data_left.xlsx';
        elseif strcmp(eig,'1')
            filename = 'h2_data_left_eig.xlsx';
        end
        writetable(h2_data_table,filename,'Sheet',1,'Range','A1');
    elseif strcmp(hemi{h},'right')
        if strcmp(eig,'0')
            h2_data_right = h2_data;
            h2_data_table_right = h2_data_table;
            filename = 'h2_data_right.xlsx';
        elseif strcmp(eig,'1')
            filename = 'h2_data_right_eig.xlsx';
        end
        writetable(h2_data_table,filename,'Sheet',1,'Range','A1')
    else
    end

    % STOP: at this point you should have a var called 'h2_data_table' that
    % has one row per sub and one column per cb subregion, where each cell
    % value corresponds to the average signal for that sub/cb region for
    % the contrast between 2-stim tasks and 1-stim tasks. You can manually 
    % confirm these values by opening df_full_table.xlsx and subtracting the
    % avg of mid and shared reward from the avg of doors, socialdoors, and 
    % sharedreward

    %% Plot h2_data
    % Two plots for this one; Plot 1, y-axis = 2-stim>1-stim, x-axis = one bar for each subregion
    % Plot 2, y-axis = signal, x-axis = 2 bars for each cb, one for 2-stim
    % one for 1-stim

    % Plot 1 (one bar per CB)
    % Append average signal and error to last row of df_full
    for k=1:length(h2_data(1,:))
        h2_data(nsub+1,k)=mean(h2_data(1:nsub,k),"omitnan");
        h2_data(nsub+2,k)=(std(h2_data(1:nsub,k),"omitnan"))/sqrt(nsub);
    end
    
    % Add error bars (standard error)
    e1 = [h2_data(nsub+2,:)];
    e2 = e1*-1;

    figure
    
    % Specify data
    x = 1:14;
    y = [h2_data(nsub+1,:)];
    bar(x,y);
    if strcmp(hemi{h},'left')
        if strcmp(eig,'0')
            title('Two-Stim > One-Stim Left Ipsilateral Eye/CB Connectivity by CB');
        elseif strcmp(eig,'1')
            title('Two-Stim > One-Stim Left Ipsilateral Eye/CB Connectivity by CB (Eig)');
        end
    else
        if strcmp(eig,'0')
            title('Two-Stim > One-Stim Right Ipsilateral Eye/CB Connectivity by CB');
        elseif strcmp(eig,'1')
            title('Two-Stim > One-Stim Right Ipsilateral Eye/CB Connectivity by CB (Eig)');
        end
    end
    xticks(1:14);
    xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
        'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
    ylabel('Two-Stim>One-Stim (zstat)');
    xlabel('CB Subregion');
    %xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
    ylim([-.3 .3]);

    hold on
    er = errorbar(x,y,e1,e2);
    er.Color = [0 0 0];
    er.LineStyle = 'none';

    hold off

    % Plot 2 (two bars per CB)
    % Append average signal and error to last row of df_full

    % Calculate mean across task categories within cb subregions and write to h2_plot2 
    h2_plot2=zeros(length(sub),28);
    for s=1:length(sub)
        for j=1:14
            h2_plot2(s,((j-1)*2)+1)=(mean(df_full(s,((j-1)*5)+1:((j-1)*5)+3),"omitnan"));
            h2_plot2(s,((j-1)*2)+2)=(mean(df_full(s,((j-1)*5)+4:((j-1)*5)+5),"omitnan"));
        end
    end
    
    % Take mean for each category within regions and append to h2_plot2
    for k=1:length(h2_plot2(1,:))
        h2_plot2(nsub+1,k)=mean(h2_plot2(1:nsub,k),"omitnan");
        h2_plot2(nsub+2,k)=(std(h2_plot2(1:nsub,k),"omitnan"))/sqrt(nsub);
    end

    figure
    
    % Specify data
    y = [h2_plot2(nsub+1,1:2); h2_plot2(nsub+1,3:4); h2_plot2(nsub+1,5:6); h2_plot2(nsub+1,7:8); h2_plot2(nsub+1,9:10); h2_plot2(nsub+1,11:12); ...
        h2_plot2(nsub+1,13:14); h2_plot2(nsub+1,15:16); h2_plot2(nsub+1,17:18); h2_plot2(nsub+1,19:20); h2_plot2(nsub+1,21:22); h2_plot2(nsub+1,23:24); ...
        h2_plot2(nsub+1,25:26); h2_plot2(nsub+1,27:28)];
    b=bar(y,'grouped');
    if strcmp(hemi{h},'left')
        if strcmp(eig,'0')
            title('Left Ipsilateral Eye/CB Connectivity by Task Category');
        elseif strcmp(eig,'1')
            title('Left Ipsilateral Eye/CB Connectivity by Task Category (Eig)');
        end
    else
        if strcmp(eig,'0')
            title('Right Ipsilateral Eye/CB Connectivity by Task Category');
        elseif strcmp(eig,'1')
            title('Right Ipsilateral Eye/CB Connectivity by Task Category (Eig)');
        end
    end
    xticks(1:14);
    xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
        'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
    ylabel('zstat');
    xlabel('CB Subregion');
    %xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
    ylim([-.4 .2]);
    leg = {'Two-Stim', 'One-Stim'};
    legend(leg,'Location','southwest');
    
    % Add error bars (standard error)
    e1 = [h2_plot2(nsub+2,1:2); h2_plot2(nsub+2,3:4); h2_plot2(nsub+2,5:6); h2_plot2(nsub+2,7:8); h2_plot2(nsub+2,9:10); h2_plot2(nsub+2,11:12); ...
        h2_plot2(nsub+2,13:14); h2_plot2(nsub+2,15:16); h2_plot2(nsub+2,17:18); h2_plot2(nsub+2,19:20); h2_plot2(nsub+2,21:22); h2_plot2(nsub+2,23:24); ...
        h2_plot2(nsub+2,25:26); h2_plot2(nsub+2,27:28)];
    hold on
    [ngroups,nbars] = size(y);
    x = nan(nbars, ngroups);
    for i = 1:nbars
        x(i,:) = b(i).XEndPoints;
    end    
    errorbar(x',y,e1,'k','linestyle','none','HandleVisibility','off');
    hold off

    % Save contralateral data
    if hemi{h} == "left"
        df_leftEye_leftHemi = df_full(1:nsub,:);
        df_leftEye_leftHemi_table = df_full_table;
        df_leftEye_rightHemi = df_contra_full;
        df_leftEye_rightHemi_table = df_contra_full_table;
    else
        df_rightEye_rightHemi = df_full(1:nsub,:);
        df_rightEye_rightHemi_table = df_full_table;
        df_rightEye_leftHemi = df_contra_full;
        df_rightEye_leftHemi_table = df_contra_full_table;
    end

    % Reallocate dataframes
    df=zeros(length(sub),6);
    df_full=zeros(length(sub),70);

end %hemi

%% Make df for H1.2, Ipsi>Contra
% Now we're going to average across tasks within cb subregions (i.e., one
% row per sub, one column per cb
df_ipsi_left_avg=zeros(length(sub),14);
df_contra_left_avg=zeros(length(sub),14);
df_ipsi_right_avg=zeros(length(sub),14);
df_contra_right_avg=zeros(length(sub),14);

% Calculate mean across tasks within cb subregions and write to h1_data
for s=1:length(sub)    
    for j=1:length(df_ipsi_left_avg(1,:))
        if j<2
            df_ipsi_left_avg(s,j)=mean(df_leftEye_leftHemi(s,j:j+4),"omitnan");
            df_contra_left_avg(s,j)=mean(df_rightEye_leftHemi(s,j:j+4),"omitnan");
            df_ipsi_right_avg(s,j)=mean(df_rightEye_rightHemi(s,j:j+4),"omitnan");
            df_contra_right_avg(s,j)=mean(df_leftEye_rightHemi(s,j:j+4),"omitnan");
        else
            df_ipsi_left_avg(s,j)=mean(df_leftEye_leftHemi(s,((j-1)*5)+1:((j-1)*5)+5),"omitnan");
            df_contra_left_avg(s,j)=mean(df_rightEye_leftHemi(s,((j-1)*5)+1:((j-1)*5)+5),"omitnan");
            df_ipsi_right_avg(s,j)=mean(df_rightEye_rightHemi(s,((j-1)*5)+1:((j-1)*5)+5),"omitnan");
            df_contra_right_avg(s,j)=mean(df_leftEye_rightHemi(s,((j-1)*5)+1:((j-1)*5)+5),"omitnan");
        end
    end
end

% Calculate L (ipsi > contra) > R (ipsi > contra)
h1_2data_long=(df_leftEye_leftHemi-df_rightEye_leftHemi)-(df_rightEye_rightHemi-df_leftEye_rightHemi);
h1_2data=zeros(length(sub),14);
for s=1:length(sub)    
    for j=1:length(h1_2data(1,:))
        if j<2
            h1_2data(s,j)=mean(h1_2data_long(s,j:j+4),"omitnan");
        else
            h1_2data(s,j)=mean(h1_2data_long(s,((j-1)*5)+1:((j-1)*5)+5),"omitnan");
        end
    end
end

%% Plot h1.2_data
% Plot: y-axis = signal, x-axis = one bar for each task/subregion

% Calculate avg & std error
for k=1:length(df_ipsi_left_avg(1,:))
    h1_2data(nsub+1,k)=mean(h1_2data(1:nsub,k),"omitnan");
    h1_2data(nsub+2,k)=(std(h1_2data(1:nsub,k),"omitnan"))/sqrt(nsub);
end
    
% Add error bars (standard error)
e1 = [h1_2data(nsub+1,:)];
e2 = e1*-1;

figure
    
% Specify data
x = 1:14;
y = [h1_2data(nsub+1,:)];
bar(x,y);

title('Avg Left (Ipsi > Contra) > Right (Ipsi > Contra)');

xticks(1:14);
xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
ylabel('L(Ipsi > Contra) > R(Ipsi > Contra) (zstat)');
xlabel('CB Subregion');
%xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
ylim([-.15 .25]);

hold on
er = errorbar(x,y,e1,e2);
er.Color = [0 0 0];
er.LineStyle = 'none';

hold off

%% Plot h1.2_data for 2>1
% Plot: y-axis = signal, x-axis = one bar for each task/subregion

% Calculate avg & std error
for k=1:length(df_ipsi_left_avg(1,:))
    h1_2data(nsub+1,k)=mean(h1_2data(1:nsub,k),"omitnan");
    h1_2data(nsub+2,k)=(std(h1_2data(1:nsub,k),"omitnan"))/sqrt(nsub);
end
    
% Add error bars (standard error)
e1 = [h1_2data(nsub+2,:)];
e2 = e1*-1;

figure
    
% Specify data
x = 1:14;
y = [h1_2data(nsub+1,:)];
bar(x,y);

title('Avg Left (2 > 1) > Right (2 > 1)');

xticks(1:14);
xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
ylabel('L(2 > 1) > R(2 > 1) (zstat)');
xlabel('CB Subregion');
%xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
ylim([-.15 .25]);

hold on
er = errorbar(x,y,e1,e2);
er.Color = [0 0 0];
er.LineStyle = 'none';

hold off


%% Plot components to H1.2 (separated)
% Plot: y-axis = signal, x-axis = one bar for each task/subregion

% Left Ipsilateral 5-task Avg
for k=1:length(df_ipsi_left_avg(1,:))
    df_ipsi_left_avg(nsub+1,k)=mean(df_ipsi_left_avg(1:nsub,k),"omitnan");
    df_ipsi_left_avg(nsub+2,k)=(std(df_ipsi_left_avg(1:nsub,k),"omitnan"))/sqrt(nsub);
end
    
% Add error bars (standard error)
e1 = [df_ipsi_left_avg(nsub+1,:)];
e2 = e1*-1;

figure
    
% Specify data
x = 1:14;
y = [df_ipsi_left_avg(nsub+1,:)];
bar(x,y);

if strcmp(eig,'0')
    title('Avg Left Ipsilateral Eye/CB Connectivity by CB');
elseif strcmp(eig,'1')
    title('Avg Left Ipsilateral Eye/CB Connectivity by CB (Eig)');
end

xticks(1:14);
xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
ylabel('5-Task Avg (zstat)');
xlabel('CB Subregion');
%xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
ylim([-.2 .1]);

hold on
er = errorbar(x,y,e1,e2);
er.Color = [0 0 0];
er.LineStyle = 'none';

hold off

% Left Contralateral 5-task Avg
for k=1:length(df_contra_left_avg(1,:))
    df_contra_left_avg(nsub+1,k)=mean(df_contra_left_avg(1:nsub,k),"omitnan");
    df_contra_left_avg(nsub+2,k)=(std(df_contra_left_avg(1:nsub,k),"omitnan"))/sqrt(nsub);
end
    
% Add error bars (standard error)
e1 = [df_contra_left_avg(nsub+2,:)];
e2 = e1*-1;

figure
    
% Specify data
x = 1:14;
y = [df_contra_left_avg(nsub+1,:)];
bar(x,y);

if strcmp(eig,'0')
    title('Avg Left Contralateral Eye/CB Connectivity by CB');
elseif strcmp(eig,'1')
    title('Avg Left Contralateral Eye/CB Connectivity by CB (Eig)');
end

xticks(1:14);
xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
ylabel('5-Task Avg (zstat)');
xlabel('CB Subregion');
%xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
ylim([-.2 .1]);

hold on
er = errorbar(x,y,e1,e2);
er.Color = [0 0 0];
er.LineStyle = 'none';

hold off

% Right Ipsilateral 5-task Avg
for k=1:length(df_ipsi_right_avg(1,:))
    df_ipsi_right_avg(nsub+1,k)=mean(df_ipsi_right_avg(1:nsub,k),"omitnan");
    df_ipsi_right_avg(nsub+2,k)=(std(df_ipsi_right_avg(1:nsub,k),"omitnan"))/sqrt(nsub);
end
    
% Add error bars (standard error)
e1 = [df_ipsi_right_avg(nsub+2,:)];
e2 = e1*-1;

figure
    
% Specify data
x = 1:14;
y = [df_ipsi_right_avg(nsub+1,:)];
bar(x,y);

if strcmp(eig,'0')
    title('Avg Right Ipsilateral Eye/CB Connectivity by CB');
elseif strcmp(eig,'1')
    title('Avg Right Ipsilateral Eye/CB Connectivity by CB (Eig)');
end

xticks(1:14);
xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
ylabel('5-Task Avg (zstat)');
xlabel('CB Subregion');
%xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
ylim([-.2 .1]);

hold on
er = errorbar(x,y,e1,e2);
er.Color = [0 0 0];
er.LineStyle = 'none';

hold off

% Right Contralateral 5-task Avg
for k=1:length(df_contra_right_avg(1,:))
    df_contra_right_avg(nsub+1,k)=mean(df_contra_right_avg(1:nsub,k),"omitnan");
    df_contra_right_avg(nsub+2,k)=(std(df_contra_right_avg(1:nsub,k),"omitnan"))/sqrt(nsub);
end
    
% Add error bars (standard error)
e1 = [df_contra_right_avg(nsub+1,:)];
e2 = e1*-1;

figure
    
% Specify data
x = 1:14;
y = [df_contra_right_avg(nsub+1,:)];
bar(x,y);

if strcmp(eig,'0')
    title('Avg Right Contralateral Eye/CB Connectivity by CB');
elseif strcmp(eig,'1')
    title('Avg Right Contralateral Eye/CB Connectivity by CB (Eig)');
end

xticks(1:14);
xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
    'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
ylabel('5-Task Avg (zstat)');
xlabel('CB Subregion');
%xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
ylim([-.2 .1]);

hold on
er = errorbar(x,y,e1,e2);
er.Color = [0 0 0];
er.LineStyle = 'none';

hold off

%% Check correlations between hemispheres within subjects

% Ipsilateral
df_full_left=readtable("df_full_left.xlsx");
df_full_left=df_full_left{:,:};
df_full_right=readtable("df_full_right.xlsx");
df_full_right=df_full_right{:,:};
df_corr=zeros(nsub,2);

for cc=1:length(sub)
    %cc=1;
    df_corr(cc,1)=df_full_left(cc,1);
    array_left=df_full_left(cc,2:end);
    array_right=df_full_right(cc,2:end);
    R=corrcoef(array_left,array_right,'rows','pairwise');
    df_corr(cc,2)=R(1,2);
end
df_corr2=sortrows(df_corr,2,"ascend");

figure
scatter(1:nsub,df_corr2(:,2));
title("Correlations across tasks & regions (ipsilateral) between left and right hemis");
xticks(1:nsub);
xticklabels(df_corr2(:,1));
xlabel("Sub");
ylabel("Correlation Coefficient (R)");

% Histogram
edges=[ 0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1 ];
histogram(df_corr(:,2),edges);
%title("Correlations across tasks & regions (ipsilateral) between left and right hemis");
xlabel("Correlation Coefficient (R)");
ylabel("Count");

mean(df_corr(:,2))

% Contralateral
df_contra_full_left=readtable("df_contra_full_left.xlsx");
df_contra_full_left=df_contra_full_left{:,:};
df_contra_full_right=readtable("df_contra_full_right.xlsx");
df_contra_full_right=df_contra_full_right{:,:};
df_contra_corr=zeros(nsub,2);

for cc=1:length(sub)
    %cc=1;
    df_contra_corr(cc,1)=df_contra_full_left(cc,1);
    array_contra_left=df_contra_full_left(cc,2:end);
    array_contra_right=df_contra_full_right(cc,2:end);
    R=corrcoef(array_contra_left,array_contra_right,'rows','pairwise');
    df_contra_corr(cc,2)=R(1,2);
end
df_contra_corr2=sortrows(df_contra_corr,2,"ascend");

figure
scatter(1:nsub,df_contra_corr2(:,2));
title("Correlations across tasks & regions (contralateral) between left and right hemis");
xticks(1:nsub);
xticklabels(df_contra_corr2(:,1));
xlabel("Sub");
ylabel("Correlation Coefficient (R)");

%%
% % Subtract signal from contralateral eye from signal from ipsilateral eye
% % in each hemisphere:
% h1_2_data_left = df_leftEye_leftHemi - df_rightEye_leftHemi;
% h1_2_data_right = df_rightEye_rightHemi - df_leftEye_rightHemi;
% 
% % Preallocate df
% h1_2_avg_left=zeros(length(sub),14);
% h1_2_avg_right=zeros(length(sub),14);
% 
% % Calculate mean across tasks within cb subregions and write to h1_data
% for s=1:length(sub)    
%     for j=1:length(h1_2_avg_left(1,:))
%         if j<2
%             h1_2_avg_left(s,j)=mean(h1_2_data_left(s,j:j+4),"omitnan");
%             h1_2_avg_right(s,j)=mean(h1_2_data_right(s,j:j+4),"omitnan");
%         else
%             h1_2_avg_left(s,j)=mean(h1_2_data_left(s,((j-1)*5)+1:((j-1)*5)+5),"omitnan");
%             h1_2_avg_right(s,j)=mean(h1_2_data_right(s,((j-1)*5)+1:((j-1)*5)+5),"omitnan");
%         end
%     end
% end


