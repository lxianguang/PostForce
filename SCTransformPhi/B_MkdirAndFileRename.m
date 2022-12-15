clc;
clear;
close all;
%% Creat Folders
Flag = 1;   %  0 Don't Rename; 1 Rename
run A_DefineFilePath.m
for k=1:size(FileList,1)
    fprintf('%s\n',FileList(k,:));
    FilePath = [MkdirPath '\' FileList(k,:)];
    CreatDir([FilePath '\DatPhi']);
    CreatDir([FilePath '\Result']);
    CreatDir([FilePath '\Result\PictureView']);
    CreatDir([FilePath '\Result\Combination']);
    CreatDir([FilePath '\Result\VortexForce']);
    CreatDir([FilePath '\Result\VicPreForce']);
    CreatDir([FilePath '\Result\VicousForce']);
    CopyFile('.\Scripts\ForceCaculate.mcr',FilePath);
    CopyFile('.\Scripts\VortexFlowPlot.mcr',FilePath);
    CopyFile('.\Scripts\ForceAndPower.lay',[FilePath '\Result']);
    %% Rename Files
    subdir=dir([FilePath '\DatFlow']);
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
            oldpath = fullfile([FilePath '\DatFlow'],oldname);
            newpath = fullfile([FilePath '\DatFlow'],newname);
            movefile(oldpath,newpath)
        end
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