%% Creat Folders
run A_ParameterSet.m
for k=1:size(FileList,1)
    FilePath = [CopyPath par FileList(k,:)];
    CreatFolder([FilePath par 'DatFlow']);
    CreatFolder([FilePath par 'Picture']);
    CreatFolder([FilePath par 'DatBody']);
    CreatFolder([FilePath par 'DatInfo']);
    copyfile(['.' par 'Scripts' par 'VelocityPlot.lay'] ,[FilePath par 'VelocityPlot.lay']);
    copyfile(['.' par 'Scripts' par 'VortexPlot.lay'  ] ,[FilePath par 'VortexPlot.lay'  ]);
end
fprintf('Files ready!\n');
fprintf('*******************************************************************\n');