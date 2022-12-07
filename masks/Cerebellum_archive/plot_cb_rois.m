clear
close all;
clc

% Script to make histogram of CB subregion volumes
% Jimmy Wyngaarden, 6 Dec 22

% Import data
%roidir='/data/projects/istart-eyeballs/masks/Cerebellum_archive/';
roidir='~/Documents/Github/istart-eyeballs/masks/Cerebellum_archive/'
[~,~,data]=xlsread([roidir 'roi_volumes2.xls']);
data=data(:,1:2);

% Format data
df=cell(28,4);
for i=1:length(data)
    if mod(i,2)~=0
        df(i,1)=data(i,1);
        df(i,2)=data(i,2);
        df(i,3)=data(i+1,1);
        df(i,4)=data(i+1,2);
    end
end

% Remove empty cells
emptyCells=cellfun('isempty',df);
df(all(emptyCells,2),:)=[];

% Plot volumes; histogram
figure
vols=cell2mat(df(:,3));
histogram(vols,10)
xlabel("Voxels")

figure
nvols=vols(vols>1);
boxplot(nvols)

figure
boxplot(vols)

% Plot volumes; bar graph
figure
bar(vols)
xticks(1:36)
xticklabels(["L IV", "R IV", "L V", "R V", "L VI", "R VI", "L Vermis VI", "R Vermis VI", "L Crus I", "R Crus I", "L Vermis Crus I", "R Vermis Crus I", "L Crus II", "R Crus II", "L Vermis Crus II", "R Vermis Crus II", "L VIIb", "R VIIb", "L Vermis VIIb", "R Vermis VIIb", "L VIIIa", "R VIIIa", "L Vermis VIIIa", "R Vermis VIIIa", "L VIIIb", "R VIIIb", "L Vermis VIIIb", "R Vermis VIIIb", "L IX", "R IX", "L Vermis IX", "R Vermis IX", "L X", "R X", "L Vermis X", "R Vermis X"]);
ylabel("Voxels")

mean(nvols)

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot volumes; histogram
figure
vols=cell2mat(df(:,3));
histogram(vols,10)
xlabel("Voxels")

figure
nvols=vols(vols>1);
boxplot(nvols)

figure
boxplot(vols)

% Plot volumes; bar graph
figure
bar(vols)
xticks(1:36)
xticklabels(["L IV", "R IV", "L V", "R V", "L VI", "R VI", "Vermis VI", "L Crus I", "R Crus I", "Vermis Crus I", "L Crus II", "R Crus II", "Vermis Crus II", "L VIIb", "R VIIb", "Vermis VIIb", "L VIIIa", "R VIIIa", "Vermis VIIIa", "L VIIIb", "R VIIIb", "Vermis VIIIb", "L IX", "R IX", "Vermis IX", "L X", "R X", "Vermis X"]);
ylabel("Voxels")

thresh=(mean(nvols))*.10;
