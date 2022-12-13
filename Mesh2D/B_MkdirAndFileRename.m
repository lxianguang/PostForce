clc;
clear;
close all;
%% Creat Folders
run A_DefineFilePath.m
for k=1:size(FileList,1)
    fprintf('%s\n',FileList(k,:));
    FilePath = [MkdirPath '\' FileList(k,:)];
    CreatDir([FilePath '\DatPhi']);
    CreatDir([FilePath '\Result']);
    CreatDir([FilePath '\DatGeo']);
    CreatDir([FilePath '\Result\PictureView']);
    CreatDir([FilePath '\Result\Combination']);
    CreatDir([FilePath '\Result\VortexForce']);
    CreatDir([FilePath '\Result\VicPreForce']);
    CreatDir([FilePath '\Result\VicousForce']);
    CopyFile('..\Scripts\ForceCaculate.mcr',FilePath);
    CopyFile('..\Scripts\VortexFlowPlot.mcr',FilePath);
    CopyFile('..\Scripts\ForceAndPower.lay',[FilePath '\Result']);
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