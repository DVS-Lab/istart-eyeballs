clear
close all;
fclose all;
clc

% Script to combine extracted CB values for PALM -i input dataframes & to
% generate plots
% Jimmy Wyngaarden, 19 Dec 22

%% Set up dirs
%codedir = '/data/projects/istart-eyeballs/code/'; % Run code from this path.
codedir = pwd;
cd ..
basedir=pwd;
datadir = fullfile(basedir, 'derivatives','extractions');
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
hemi = {'left', 'right'};

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

            % Extract connectivity values for each sub in each task
            task = {'doors', 'socialdoors', 'ugdg', 'mid', 'sharedreward'};
            for t=1:length(task)
                f = fullfile(datadir, task{t}, ['sub-' sub{s} '_task-' task{t} '_' hemi{h} '_cb-' cb{c} '.txt']);
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
        end

        % Convert df to table and add column labels
        df_table = array2table(df);
        df_table.Properties.VariableNames(1:6) = {'Sub', 'doors', 'socialdoors', ...
            'ugdg', 'mid', 'sharedreward'};
        
        % Write master df (df_full) with all tasks & regions
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

    % Write data to .xlsx file
    if strcmp(hemi{h},'left')
        filename = 'df_full_left.xlsx';
        writetable(df_full_table,filename,'Sheet',1,'Range','A1');
    elseif strcmp(hemi{h},'right')
        filename = 'df_full_right.xlsx';
        writetable(df_full_table,filename,'Sheet',1,'Range','A1')
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
        df_full(53,k)=mean(df_full(1:52,k),"omitnan");
        df_full(54,k)=(std(df_full(1:52,k),"omitnan"))/sqrt(52);
    end

    figure
    
    % Specify data
    y = [df_full(53,1:5); df_full(53,6:10); df_full(53,11:15); df_full(53,16:20); df_full(53,21:25); df_full(53,26:30); ...
        df_full(53,31:35); df_full(53,36:40); df_full(53,41:45); df_full(53,46:50); df_full(53,51:55); df_full(53,56:60); ...
        df_full(53,61:65); df_full(53,66:70)];
    bar(y,'grouped');
    if strcmp(hemi{h},'left')
        title('Left Ipsilateral Eye/CB Connectivity by Task');
    else
        title('Right Ipsilateral Eye/CB Connectivity by Task');
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
        filename = 'h1_data_left.xlsx';
        writetable(h1_data_table,filename,'Sheet',1,'Range','A1');
    elseif strcmp(hemi{h},'right')
        filename = 'h1_data_right.xlsx';
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
        h1_data(53,k)=mean(h1_data(1:52,k),"omitnan");
        h1_data(54,k)=(std(h1_data(1:52,k),"omitnan"))/sqrt(52);
    end
    
    % Add error bars (standard error)
    e1 = [h1_data(54,:)];
    e2 = e1*-1;

    figure
    
    % Specify data
    x = 1:14;
    y = [h1_data(53,:)];
    bar(x,y);
    if strcmp(hemi{h},'left')
        title('Avg Left Ipsilateral Eye/CB Connectivity by CB');
    else
        title('Avg Right Ipsilateral Eye/CB Connectivity by CB');
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
        filename = 'h2_data_left.xlsx';
        writetable(h2_data_table,filename,'Sheet',1,'Range','A1');
    elseif strcmp(hemi{h},'right')
        filename = 'h2_data_right.xlsx';
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
        h2_data(53,k)=mean(h2_data(1:52,k),"omitnan");
        h2_data(54,k)=(std(h2_data(1:52,k),"omitnan"))/sqrt(52);
    end
    
    % Add error bars (standard error)
    e1 = [h2_data(54,:)];
    e2 = e1*-1;

    figure
    
    % Specify data
    x = 1:14;
    y = [h2_data(53,:)];
    bar(x,y);
    if strcmp(hemi{h},'left')
        title('Two-Stim > One-Stim Left Ipsilateral Eye/CB Connectivity by CB');
    else
        title('Two-Stim > One-Stim Right Ipsilateral Eye/CB Connectivity by CB');
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
        h2_plot2(53,k)=mean(h2_plot2(1:52,k),"omitnan");
        h2_plot2(54,k)=(std(h2_plot2(1:52,k),"omitnan"))/sqrt(52);
    end

    figure
    
    % Specify data
    y = [h2_plot2(53,1:2); h2_plot2(53,3:4); h2_plot2(53,5:6); h2_plot2(53,7:8); h2_plot2(53,9:10); h2_plot2(53,11:12); ...
        h2_plot2(53,13:14); h2_plot2(53,15:16); h2_plot2(53,17:18); h2_plot2(53,19:20); h2_plot2(53,21:22); h2_plot2(53,23:24); ...
        h2_plot2(53,25:26); h2_plot2(53,27:28)];
    b=bar(y,'grouped');
    if strcmp(hemi{h},'left')
        title('Left Ipsilateral Eye/CB Connectivity by Task Category');
    else
        title('Right Ipsilateral Eye/CB Connectivity by Task Category');
    end
    xticks(1:14);
    xticklabels({'IV', 'V', 'VI', 'Crus I', 'Crus II', 'VIIb', 'VIIIa', 'VIIIb', ...
        'IX', 'X', 'Vermis VI', 'Vermis VIIIa', 'Vermis VIIIb', 'Vermis IX'});
    ylabel('zstat');
    xlabel('CB Subregion');
    xline([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5]);
    ylim([-.3 .2]);
    leg = {'Two-Stim', 'One-Stim'};
    legend(leg,'Location','southwest');
    
    % Add error bars (standard error)
    e1 = [h2_plot2(54,1:2); h2_plot2(54,3:4); h2_plot2(54,5:6); h2_plot2(54,7:8); h2_plot2(54,9:10); h2_plot2(54,11:12); ...
        h2_plot2(54,13:14); h2_plot2(54,15:16); h2_plot2(54,17:18); h2_plot2(54,19:20); h2_plot2(54,21:22); h2_plot2(54,23:24); ...
        h2_plot2(54,25:26); h2_plot2(54,27:28)];
    hold on
    [ngroups,nbars] = size(y);
    x = nan(nbars, ngroups);
    for i = 1:nbars
        x(i,:) = b(i).XEndPoints;
    end    
    errorbar(x',y,e1,'k','linestyle','none','HandleVisibility','off');
    hold off

% Reallocate dataframes
df=zeros(length(sub),6);
df_full=zeros(length(sub),70);

end %hemi
