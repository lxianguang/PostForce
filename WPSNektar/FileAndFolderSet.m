function [] = fileAndFolderSet(MkdirPath, par, FileList, isNearWall)
%Files and folders initialization
filenames = [];
for k=1:size(FileList,1)
    %% Creat Folders
    filenames = [filenames FileList(k,:) ' '];
    FilePath  = [MkdirPath par FileList(k,:)];
    creatfolder([FilePath par 'DatPhi']);
    creatfolder([FilePath par 'DatGeo']);
    creatfolder([FilePath par 'DatFigures']);
    %% Rename Files
    subdir=dir([FilePath par 'DatFlow']);
    if length(subdir)<=2
        error('Check the file path!!!');
    end
    subdir(1:2) = [];
    for i=1:length(subdir)
        [newname,~] = filenameget(i,'Flow','Flow','.plt');
        oldname = subdir(i).name;
        if ~strcmp(newname, oldname)
        oldpath = [FilePath par 'DatFlow' par oldname];
        newpath = [FilePath par 'DatFlow' par newname];
        movefile(oldpath,newpath)
        end
    end
    %% Copy Calculate Scripts
    vortexScript= [FilePath  par 'VortexFlowPlot.mcr'];
    laplaceSet  = [FilePath  par 'DatGeo' par 'LaplaceSet.xml'];
    forcecalcu  = [FilePath  par 'ForceCalculate.sh'];
    runforce    = [MkdirPath par 'RunFocre.sh'      ];
    if isNearWall
        copyfile(['.' par 'Scripts' par 'NearWall'  par 'LaplaceSet.xml'] ,laplaceSet);
    else
        copyfile(['.' par 'Scripts' par 'AwayWall'  par 'LaplaceSet.xml'] ,laplaceSet);
    end
    if ispc
        copyfile(['.' par 'Scripts' par 'Universal' par 'VortexFlowPlot1.mcr'] ,vortexScript);
    else
        copyfile(['.' par 'Scripts' par 'Universal' par 'VortexFlowPlot2.mcr'] ,vortexScript);
    end
    copyfile(['.' par 'Scripts' par 'Universal' par 'ForceCalculate.sh'] ,forcecalcu);
    copyfile(['.' par 'Scripts' par 'Universal' par 'RunFocre.sh'      ] ,runforce  );
    %% Change Scripts Parameters
    rewritefile(forcecalcu  ,5,num2str(i));
    rewritefile(vortexScript,3,num2str(i));
    rewritefile(vortexScript,6,FilePath  );
    rewritefile(runforce    ,1,filenames );
    fprintf('%s Files Ready  ============================================\n',FileList(k,:));
end
fprintf('*******************************************************************\n');
end