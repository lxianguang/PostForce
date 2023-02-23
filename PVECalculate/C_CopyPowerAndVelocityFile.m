%% Parameters
run B_DataAveraging.m
CreatDir([PastePath par 'Power'   ])   
CreatDir([PastePath par 'Energy'  ])
CreatDir([PastePath par 'Velocity'])
CreatDir([PastePath par 'Result'  ])
CreatDir([PastePath par 'Force   '])
for i=1:size(FileList,1)
    startfile1 = [CopyPath par FileList(i,:) par 'DatInfoS' par 'Power_0002.plt'       ];
    startfile2 = [CopyPath par FileList(i,:) par 'DatInfoS' par 'SampBodyMean_0002.plt'];
    startfile3 = [CopyPath par FileList(i,:) par 'DatInfoS' par 'Energy_0002.plt'      ];
    startfile4 = [CopyPath par FileList(i,:) par 'DatInfoS' par 'ForceDirect_0002.plt' ];
    startfile5 = ['.' par 'Scripts' par 'PVCE.lay'];
    goalfile1  = [PastePath par 'Power'    par FileList(i,:) '.dat'];
    goalfile2  = [PastePath par 'Velocity' par FileList(i,:) '.dat'];
    goalfile3  = [PastePath par 'Energy'   par FileList(i,:) '.dat'];
    goalfile4  = [PastePath par 'Force'    par FileList(i,:) '.dat'];
    goalfile5  = [PastePath par 'Result'   par 'PVECPlot.lay'];
    copyfile(startfile1,goalfile1);
    copyfile(startfile2,goalfile2);
    copyfile(startfile3,goalfile3);
    copyfile(startfile4,goalfile4);
    copyfile(startfile5,goalfile5);
    fprintf('%s File Copy Ready =========================================\n',FileList(i,:));
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