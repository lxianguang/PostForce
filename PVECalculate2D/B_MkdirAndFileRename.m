%% Creat Folders
run A_DefineFilePath.m
for k=1:size(FileList,1)
    FilePath = [CopyPath par FileList(k,:)];
    CreatDir([FilePath par 'DatFlow']);
    CreatDir([FilePath par 'Picture']);
    CreatDir([FilePath par 'DatBody']);
    CreatDir([FilePath par 'DatInfo']);
    CopyFile(['.' par 'Scripts' par 'VelocityPlot.lay'] ,[FilePath par 'VelocityPlot.lay']);
    CopyFile(['.' par 'Scripts' par 'VortexPlot.lay'  ] ,[FilePath par 'VortexPlot.lay'  ]);
end
fprintf('Files ready!\n');
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