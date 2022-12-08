clear
close all;
clc

% Script to combine gsr_y values across runs for ISTART tasks
% Jimmy Wyngaarden, 8 Dec 22

% Set up dirs
%codedir = '/data/projects/istart-eyeballs/code/'; % Run code from this path.
codedir = '~/Documents/Github/istart-eyeballs/code/';
addpath(codedir)
%datadir = '/data/projects/istart-eyeballs/derivatives/';
datadir = '~/Documents/Github/istart-eyeballs/derivatives/';
addpath(datadir)

task = {'doors', 'socialdoors', 'mid', 'ugdg', 'sharedreward'};

for i = 1:length(task)
    
    % Read in gsr file
    sourcedata = fullfile([datadir 'Task-' task{i} '_Level-Run_gsr_y-info_mriqc-0.16.1.tsv']);
    T = readtable(sourcedata,'FileType','delimitedtext');
    subs = unique(T.ID);

    % Create outline for final df
    final_df=zeros(length(subs),3);
    
    % Average across runs for subs that have both
    final_df(1,1) = T.ID(1);
    final_df(1,2) = T.gsr_y(1);
    final_df(1,3) = T.run(1);
    x = 2;

    for t = 2:length(T.ID)
        if T.ID(t) == T.ID(t-1)
            final_df(x-1,1) = T.ID(t);
            final_df(x-1,2) = mean(T.gsr_y(t-1:t));
            final_df(x-1,3) = 3;
        else
            final_df(x,1) = T.ID(t);
            final_df(x,2) = T.gsr_y(t);
            final_df(x,3) = T.run(t);
            x = x+1;
        end
    end
   
    % Write labels for final_df
    final_df = array2table(final_df);
    final_df.Properties.VariableNames(1:3)={'Sub', 'gsr_y', 'run'};

    filename = ['gsr_data_' task{i} '.xlsx'];
    writetable(final_df,filename,'Sheet',1,'Range','A1')

    message = ['GSR calculations complete for ', task{i}];
    disp(message)
  
end




