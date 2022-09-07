clc;
clear;
close all;
%% Creat Folders
Flag = 1;   %  0 Don't Rename; 1 Rename
path = 'G:\Data\ShearPlate\Force\Re100A0.50Rho1.00S0.00K3.50_1';
CreatDir([path '\DatPhi']);
CreatDir([path '\Picture']);
CreatDir([path '\Result']);
CreatDir([path '\Picture\PostPicture']);
CreatDir([path '\Result\Combination']);
CreatDir([path '\Result\VortexForce']);
CreatDir([path '\Result\VicPreForce']);
CreatDir([path '\Result\VicousForce']);
%% Rename Files
subdir=dir([path '\DatFlow']);
if size(subdir,1)<2
   error('There is no files in the folder')
end
subdir(1:2) = [];
if Flag
    for i=1:length(subdir)
        if i<10
            newname = ['Flow00' num2str(i) '.plt'];
        elseif i<100
            newname = ['Flow0' num2str(i) '.plt'];
        else
            newname = ['Flow' num2str(i) '.plt'];
        end
        oldname = subdir(i).name;
        oldpath = fullfile([path '\DatFlow'],oldname);
        newpath = fullfile([path '\DatFlow'],newname);
        movefile(oldpath,newpath)
    end
end
%% Functions
function [] = CreatDir(path)
if ~exist(path,'dir')
    mkdir(path);
end
end