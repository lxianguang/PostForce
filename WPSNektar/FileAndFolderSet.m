%% File Parameters
filenames = [];
for k=1:size(FileList,1)
    %% Creat Folders
    filenames = [filenames FileList(k,:) ' '];
    FilePath = [MkdirPath par FileList(k,:)];
    creatfolder([FilePath par 'DatPhi']);
    % creatfolder([FilePath par 'Result']);
    creatfolder([FilePath par 'DatGeo']);
    creatfolder([FilePath par 'DatBodyS']);
    % creatfolder([FilePath par 'Result' par '1VortexForce'  ]);
    % creatfolder([FilePath par 'Result' par '2VicPreForce'  ]);
    % creatfolder([FilePath par 'Result' par '3AcceleForce'  ]);
    % creatfolder([FilePath par 'Result' par '4FrictionForce']);
    % creatfolder([FilePath par 'Result' par '5Combination'  ]);
    % creatfolder([FilePath par 'Result' par '6PictureView'  ]);
    % copyfileplus(['.' par 'Scripts' par 'Universal' par 'ForcePlotX.lay' ] ,[FilePath par 'Result' par 'ForcePlotX.lay']);
    % copyfileplus(['.' par 'Scripts' par 'Universal' par 'ForcePlotY.lay' ] ,[FilePath par 'Result' par 'ForcePlotY.lay']);
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
%     forceScript = [FilePath  par 'ForceCalculate.mcr'];
    vortexScript= [FilePath  par 'VortexFlowPlot.mcr'];
    laplaceSet  = [FilePath  par 'DatGeo' par 'LaplaceSet.xml'];
    forcecalcu  = [FilePath  par 'ForceCalculate.sh'];
    runforce    = [MkdirPath par 'RunFocre.sh'      ];
    if isNearWall
%         if ispc
%             copyfile(['.' par 'Scripts' par 'NearWall'  par 'ForceCalculate1.mcr'] ,forceScript);
%         else
%             copyfile(['.' par 'Scripts' par 'NearWall'  par 'ForceCalculate2.mcr'] ,forceScript);
%         end
        copyfile(['.' par 'Scripts' par 'NearWall'  par 'LaplaceSet.xml'] ,laplaceSet);
    else
%         if ispc
%             copyfile(['.' par 'Scripts' par 'AwayWall'  par 'ForceCalculate1.mcr'] ,forceScript);
%         else
%             copyfile(['.' par 'Scripts' par 'AwayWall'  par 'ForceCalculate2.mcr'] ,forceScript);
%         end
        copyfile(['.' par 'Scripts' par 'AwayWall'  par 'LaplaceSet.xml'] ,laplaceSet);
    end
%     if bodyType==2
%         if ispc
%             copyfile(['.' par 'Scripts' par 'TwoPlates'  par 'ForceCalculate1.mcr'] ,forceScript);
%         else
%             copyfile(['.' par 'Scripts' par 'TwoPlates'  par 'ForceCalculate2.mcr'] ,forceScript);
%         end
%     end
    if ispc
        copyfile(['.' par 'Scripts' par 'Universal' par 'VortexFlowPlot1.mcr'] ,vortexScript);
    else
        copyfile(['.' par 'Scripts' par 'Universal' par 'VortexFlowPlot2.mcr'] ,vortexScript);
    end
    copyfile(['.' par 'Scripts' par 'Universal' par 'ForceCalculate.sh'] ,forcecalcu);
    copyfile(['.' par 'Scripts' par 'Universal' par 'RunFocre.sh'      ] ,runforce  );
    %% Change Scripts Parameters
%     rewritefile(forceScript,2,num2str(i) );
%     rewritefile(forceScript,3,FilePath   );
%     rewritefile(forceScript,4,strrep(FilePath,'\','\\'));
    rewritefile(forcecalcu  ,5,num2str(i));
    rewritefile(vortexScript,3,num2str(i));
    rewritefile(vortexScript,6,FilePath  );
    rewritefile(runforce    ,1,filenames );
    fprintf('%s Files Ready  ============================================\n',FileList(k,:));
end
fprintf('*******************************************************************\n');