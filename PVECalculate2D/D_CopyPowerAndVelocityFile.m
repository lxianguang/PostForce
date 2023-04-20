%% Parameters
run C_DataAveraging.m
CreatDir([PastePath par 'Power'    ])   
CreatDir([PastePath par 'Energy'   ])
CreatDir([PastePath par 'Velocity' ])
CreatDir([PastePath par 'Result'   ])
CreatDir([PastePath par 'Force'    ])
CreatDir([PastePath par 'Placement'])
for i=1:size(FileList,1)
    startfile1 = [CopyPath par FileList(i,:) par 'DatInfoS' par 'Power_00'           num '.plt'];
    startfile2 = [CopyPath par FileList(i,:) par 'DatInfoS' par 'SampBodyMean_00'    num '.plt'];
    startfile3 = [CopyPath par FileList(i,:) par 'DatInfoS' par 'Energy_00'          num '.plt'];
    startfile4 = [CopyPath par FileList(i,:) par 'DatInfoS' par 'ForceDirect_00'     num '.plt'];
    startfile5 = [CopyPath par FileList(i,:) par 'DatInfo'  par 'SampBodyAngular_00' num '.plt'];
    startfile6 = ['.' par 'Scripts' par 'PUESY.lay'];
    goalfile1  = [PastePath par 'Power'      par FileList(i,:) '.dat'];
    goalfile2  = [PastePath par 'Velocity'   par FileList(i,:) '.dat'];
    goalfile3  = [PastePath par 'Energy'     par FileList(i,:) '.dat'];
    goalfile4  = [PastePath par 'Force'      par FileList(i,:) '.dat'];
    goalfile5  = [PastePath par 'Placement'  par FileList(i,:) '.dat'];
    goalfile6  = [PastePath par 'Result'     par 'PUESY.lay'];
    copyfile(startfile1,goalfile1);
    copyfile(startfile2,goalfile2);
    copyfile(startfile3,goalfile3);
    copyfile(startfile4,goalfile4);
    copyfile(startfile5,goalfile5);
    copyfile(startfile6,goalfile6);
    fprintf('%s File Copy Ready =========================================\n',FileList(i,:));
end
fprintf('*******************************************************************\n');
%% Functions
function [] = CreatDir(path)
if ~exist(path,'dir')
    mkdir(path);
end
end