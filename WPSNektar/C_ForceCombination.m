%% File Parameters
run A_ParamtersDefine.m
for k=1:size(FileList,1)
    FilePath = [MkdirPath par FileList(k,:)];
    %% Reading Time
    subdir      = dir([FilePath par 'DatBody']);
    subdir(1:2) = [];
    numlen      = size (subdir,1);
    datatime    = zeros(numlen,1);
    for i=1:numlen
        if bodyType==2
            datatime(i) = str2double(strrep(strrep(subdir(i).name,'.dat',''),'Body',''));
        else
            datatime(i) = str2double(strrep(strrep(subdir(i).name,'.dat',''),'Body001_',''));
        end
    end
    %% Interpolation Resultant Force
    if bodyType==2
        maindir0  = [FilePath par 'DatInfo' par 'ForceDirect.dat'];
    else
        maindir0  = [FilePath par 'DatInfo' par 'ForceDirect_0001.plt'];
    end
    force0    = importdata(maindir0).data;
    forcex    = interp1(force0(:,1),force0(:,2),datatime,'spline');
    forcey    = interp1(force0(:,1),force0(:,3),datatime,'spline');
    %% Extract Forces
    ForceFile = [FilePath par 'forceLog.txt'];
    Forces    = zeros(numlen,6);
    file = fopen(ForceFile,'r+');
    line = 0;
    while ~feof(file)
        line = line + 1;
        tline = fgetl(file);
        txt{line}= tline;
    end
    fclose(file);
    for i=1:numlen
        Forceline = 5*i;
        ForceNums = str2num(strrep(txt{Forceline},'RESULT',''))*2;
        Forces(i,1:4) = ForceNums;
        Forces(i,5) = sum(ForceNums);
        Forces(i,6) = forcex(i);
    end
    %% Write Data
    % Force in x-direction
    writeforce = [FilePath par 'ForceX.dat'];
    file=fopen(writeforce,'w');
    fprintf(file,'VARIABLES=\"T\",\"VortexFx\",\"FrictionFx\",\"AccelerationFx\",\"VicpreFx\",\"ResultantFx\",\"TrueResFx\"\n');
    for i=2:numlen
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),Forces(i,1),Forces(i,2),Forces(i,3),Forces(i,4),Forces(i,5),Forces(i,6));
    end
    % Force in y-direction
    writeforce = [FilePath par 'ForceY.dat' ];
    file=fopen(writeforce,'w');
    fprintf(file,'VARIABLES=\"T\",\"AccelerationFy\",\"FrictionFy\",\"VicpreFy\",\"VortexFy\",\"ResultantFy\",\"TrueResFy\"\n');
    for i=1:numlen
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),AccelerationForce(i,2),VicousForce(i,2),VicPreForce(i,2),VortexForce(i,2),ResultantForce(i,2),TrueResultant(i,2));
    end
    fclose all;
    fprintf('%s Combination End =========================================\n',FileList(k,:));
end
fprintf('*******************************************************************\n');