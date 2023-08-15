%% Copy data files to post force folder
run A_ParameterSet.m
CreatFolder([PastePath par 'Power'    ])   
CreatFolder([PastePath par 'Energy'   ])
CreatFolder([PastePath par 'Velocity' ])
CreatFolder([PastePath par 'Result'   ])
CreatFolder([PastePath par 'Force'    ])
for k=1:size(FileList,1)
    startfile1 = [CopyPath par FileList(k,:) par 'DatInfoS' par 'Power_00'        num '.plt'];
    startfile2 = [CopyPath par FileList(k,:) par 'DatInfoS' par 'SampBodyMean_00' num '.plt'];
    startfile3 = [CopyPath par FileList(k,:) par 'DatInfoS' par 'Energy_00'       num '.plt'];
    startfile4 = [CopyPath par FileList(k,:) par 'DatInfoS' par 'ForceDirect_00'  num '.plt'];
    startfile5 = ['.' par 'Scripts' par 'PostData.lay'];
    goalfile1  = [PastePath par 'Power'      par FileList(k,:) '.dat'];
    goalfile2  = [PastePath par 'Velocity'   par FileList(k,:) '.dat'];
    goalfile3  = [PastePath par 'Energy'     par FileList(k,:) '.dat'];
    goalfile4  = [PastePath par 'Force'      par FileList(k,:) '.dat'];
    goalfile5  = [PastePath par 'Result'     par 'PostData.lay'];
    copyfile(startfile1,goalfile1);
    copyfile(startfile2,goalfile2);
    copyfile(startfile3,goalfile3);
    copyfile(startfile4,goalfile4);
    copyfile(startfile5,goalfile5);
    fprintf('%s File Copy Ready =========================================\n',FileList(k,:));
end
fprintf('*******************************************************************\n');