function [] = fileAndFolderSet(casePath, par, isNearWall)
% Files and folders initialization
% Creat folders
creatfolder([casePath par 'DatPhi']);
creatfolder([casePath par 'DatGeo']);
creatfolder([casePath par 'DatFigures']);
% Rename flow files
subdir=dir ([casePath par 'DatFlow']);
if length(subdir)<=2
    error('Check the file path!!! There is no flow files');
end
subdir(1:2) = [];
for i=1:length(subdir)
    [newname,~] = fileNumberGet(i,'Flow','Flow','.plt');
    oldname = subdir(i).name;
    if ~strcmp(newname, oldname)
    oldpath = [casePath par 'DatFlow' par oldname];
    newpath = [casePath par 'DatFlow' par newname];
    movefile(oldpath,newpath)
    end
end
% Copy scripts
vortexScript= [casePath  par 'VortexFlowPlot.mcr'];
laplaceSet  = [casePath  par 'DatGeo' par 'LaplaceSet.xml'];
forcecalcu  = [casePath  par 'ForceCalculate.sh'];
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
% Change scripts parameters
rewritefile(forcecalcu  ,5,num2str(i));
rewritefile(vortexScript,3,num2str(i));
rewritefile(vortexScript,6,casePath  );
fprintf('*******************************************************************\n');
fprintf('Scripts writing ready: %s\n',casePath);
fprintf('*******************************************************************\n');
end