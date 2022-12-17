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
    CreatDir([FilePath '\Result\1VortexForce'  ]);
    CreatDir([FilePath '\Result\2VicPreForce'  ]);
    CreatDir([FilePath '\Result\3AddedForce'   ]);
    CreatDir([FilePath '\Result\4FrictionForce']);
    CreatDir([FilePath '\Result\5Combination'  ]);
    CreatDir([FilePath '\Result\6PictureView'  ]);
    CopyFile('.\Scripts\ForceCalculate.mcr' , FilePath);
    CopyFile('.\Scripts\VortexFlowPlot.mcr' , FilePath);
    CopyFile('.\Scripts\PhiACalculate.sh'   ,[FilePath '\DatGeo']);
    CopyFile('.\Scripts\NearWallPlate.xml'  ,[FilePath '\DatGeo']);
    CopyFile('.\Scripts\ForceAndPower.lay'  ,[FilePath '\Result']);
    %% Rename Files
    if exist([FilePath '\DatFlow'],'dir')
        subdir=dir([FilePath '\DatFlow']);
        if size(subdir,1)<2
           error('There is no files in the folder')
        end
        subdir(1:2) = [];
        for i=1:length(subdir)
            if i<10
                newname = ['Flow00' num2str(i) '.plt'];
            elseif i<100
                newname = ['Flow0' num2str(i) '.plt'];
            else
                newname = ['Flow' num2str(i) '.plt'];
            end
            oldname = subdir(i).name;
            if ~strcmp(newname, oldname)
            oldpath = fullfile([FilePath '\DatFlow'],oldname);
            newpath = fullfile([FilePath '\DatFlow'],newname);
            movefile(oldpath,newpath)
            end
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