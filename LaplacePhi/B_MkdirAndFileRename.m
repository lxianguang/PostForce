%% Creat Folders
run A_DefineFilePath.m
for k=1:size(FileList,1)
    FilePath = [MkdirPath par FileList(k,:)];
    CreatDir([FilePath par 'DatPhi']);
    CreatDir([FilePath par 'Result']);
    CreatDir([FilePath par 'DatGeo']);
    CreatDir([FilePath par 'DatBodyS']);
    CreatDir([FilePath par 'DatInfoS']);
    CreatDir([FilePath par 'Result' par '1VortexForce'  ]);
    CreatDir([FilePath par 'Result' par '2VicPreForce'  ]);
    CreatDir([FilePath par 'Result' par '3AddedForce'   ]);
    CreatDir([FilePath par 'Result' par '4FrictionForce']);
    CreatDir([FilePath par 'Result' par '5Combination'  ]);
    CreatDir([FilePath par 'Result' par '6PictureView'  ]);
    CopyFile(['.' par 'Scripts' par 'ForceCalculate.mcr'] ,[FilePath par 'ForceCalculate.mcr']);
    CopyFile(['.' par 'Scripts' par 'VortexFlowPlot.mcr'] ,[FilePath par 'VortexFlowPlot.mcr']);
    CopyFile(['.' par 'Scripts' par 'PhiACalculate.sh'  ] ,[FilePath par 'DatGeo' par 'PhiACalculate.sh']);
    CopyFile(['.' par 'Scripts' par 'NearWallPlate.xml' ] ,[FilePath par 'DatGeo' par 'NearWallPlate.xml']);
    CopyFile(['.' par 'Scripts' par 'ForceAndPower.lay' ] ,[FilePath par 'Result' par 'ForceAndPower.lay']);
    %% Rename Files
    if exist([FilePath par 'DatFlow'],'dir')
        subdir=dir([FilePath par 'DatFlow']);
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
            oldpath = fullfile([FilePath par 'DatFlow'],oldname);
            newpath = fullfile([FilePath par 'DatFlow'],newname);
            movefile(oldpath,newpath)
            end
        end
    end
    fprintf('%s Files Ready  ============================================\n',FileList(k,:));
end
fprintf('*******************************************************************\n');
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