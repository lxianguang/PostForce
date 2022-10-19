clc
clear
%% Parameters
% filelist = ['K1.00';'K2.00';'K3.00';'K3.50';'K4.00';'K5.00';'K6.00';'K7.00';'K8.00';'K9.00';'K10.0';'K15.0';'K20.0';'K30.0';'K40.0';'K50.0'];
% filelist = ['S0.00';'S.025';'S.050';'S.075';'S0.10';'S0.15';'S0.20';'S0.25';'S0.30';'S0.40';'S0.50';'S0.60'];
filelist = ['Wt0.00';'Wt0.10';'Wt0.20';'Wt0.30';'Wt0.40';'Wt0.50';'Wt0.60';'Wt0.70';'Wt0.80';'Wt0.90';'Wt1.00'];
pathcopy = 'G:\DataFile\IntervalPlate\PostData\Re100A0.25K3.50S0.20Wt';
pathpaste = 'G:\DataFile\IntervalPlate\PVCECalculate\Re100A0.25K3.50S0.20Wt';
CreatDir([pathpaste '\Power'])
CreatDir([pathpaste '\Velocity'])
CreatDir([pathpaste '\Picture'])
for i=1:size(filelist,1)
    startfile1 = [pathcopy '\' filelist(i,:) '\DatInfo\Power_0001.plt'];
    startfile2 = [pathcopy '\' filelist(i,:) '\DatInfo\SampBodyCentM_0001.plt'];
    goalfile1 = [pathpaste '\Power\' filelist(i,:) '.dat'];
    goalfile2 = [pathpaste '\Velocity\' filelist(i,:) '.dat'];
    CopyFile(startfile1,goalfile1);
    CopyFile(startfile2,goalfile2);
end
%% Functions
function [] = CreatDir(path)
if ~exist(path,'dir')
    mkdir(path);
end
end

function [] = CopyFile(path1,path2)
if ~exist(path2,'file')
    copyfile(path1,path2);
end
end