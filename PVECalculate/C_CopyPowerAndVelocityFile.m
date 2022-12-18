clc
clear
%% Parameters
run A_DefineFilePath.m
CreatDir([PastePath '\Power'])
CreatDir([PastePath '\Energy'])
CreatDir([PastePath '\Velocity'])
CreatDir([PastePath '\Picture'])
CreatDir([PastePath '\Points'])
for i=1:size(FileList,1)
    fprintf('%s\n',FileList(i,:));
    startfile1 = [CopyPath '\' FileList(i,:) '\DatInfo\Power_0001.plt'];
    % startfile2 = [CopyPath '\' FileList(i,:) '\DatInfo\SampBodyCentM_0001.plt'];
    startfile2 = [CopyPath '\' FileList(i,:) '\DatInfo\SampBodyMean_0001.plt'];
    startfile3 = [CopyPath '\' FileList(i,:) '\DatInfo\Energy_0001.plt'];
    % startfile4 = [CopyPath '\' FileList(i,:) '\DatInfo\SampBodyNodeB0001_0001.plt'];
    startfile4 = [CopyPath '\' FileList(i,:) '\DatInfo\SampBodyNodeBegin_0001.plt'];
    goalfile1  = [PastePath '\Power\' FileList(i,:) '.dat'];
    goalfile2  = [PastePath '\Velocity\' FileList(i,:) '.dat'];
    goalfile3  = [PastePath '\Energy\' FileList(i,:) '.dat'];
    goalfile4  = [PastePath '\Points\' FileList(i,:) '.dat'];
    CopyFile(startfile1,goalfile1);
    CopyFile(startfile2,goalfile2);
    CopyFile(startfile3,goalfile3);
    CopyFile(startfile4,goalfile4);
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