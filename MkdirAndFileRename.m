clc;
clear;
close all;
%% Creat Folders
Flag = 1;   %  0 Don't Rename; 1 Rename
path = 'G:\Data\ShearPlate\Force\Re100A0.50S0.00\K3.50';
CreatDir([path '\DatPhi']);
CreatDir([path '\Picture']);
CreatDir([path '\Result']);
CreatDir([path '\Picture\PostPicture']);
CreatDir([path '\Result\Combination']);
CreatDir([path '\Result\VortexForce']);
CreatDir([path '\Result\VicPreForce']);
CreatDir([path '\Result\VicousForce']);
CopyFile('.\Scripts\ForceCaculate.mcr',path);
CopyFile('.\Scripts\VortexFlowPlot.mcr',path);
CopyFile('.\Scripts\AddMassForce.lay',[path '\Result']);
CopyFile('.\Scripts\ResultantForce.lay',[path '\Result']);
CopyFile('.\Scripts\VicousForce.lay',[path '\Result']);
CopyFile('.\Scripts\VicPreForce.lay',[path '\Result']);
CopyFile('.\Scripts\VortexForce.lay',[path '\Result']);
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

function [] = CopyFile(filename,path)
if ~exist([path '\' filename],'file')
    copyfile(filename,path);
end
end