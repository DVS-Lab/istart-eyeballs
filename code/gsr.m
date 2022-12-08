clear
close all;
clc

% Script to combine gsr_y values across runs for ISTART tasks
% Jimmy Wyngaarden, 8 Dec 22

% Set up dirs
codedir = '/data/projects/istart-eyeballs/code'; % Run code from this path.
addpath(codedir)
datadir = '/data/projects/istart-data/derivatives';
addpath(datadir)

for task='doors'