%% Calculate The Average Force 
run A_ParamtersDefine.m
%% Reading Path
Abscissa = FileList(1,1);
%% Define Variables
if isNearWall==1
    AverageData = zeros(8,size(FileList,1),4);
else
    AverageData = zeros(7,size(FileList,1),4);
end
for i=1:size(FileList,1)
    FilePath = [MkdirPath par FileList(i,:)];
    % Combinate Path
    forcexF = [FilePath par 'Result' par '5Combination' par 'ForceX.dat']; 
    forceyF = [FilePath par 'Result' par '5Combination' par 'ForceY.dat']; 
    % Reading Files
    forcex = importdata(forcexF).data;
    forcey = importdata(forceyF).data;
    % Other Variables
    time   = str2double(strrep(FileList(i,:),Abscissa,''));
    numlen = size(forcex,1)-1;
    if isNearWall==1
        % Calculate Average Force in x-direction
        acceleAFx = sum(forcex(2:end,2))/numlen;
        frictiAFx = sum(forcex(2:end,3))/numlen;
        vicpreAFx1= sum(forcex(2:end,4))/numlen;
        vicpreAFx2= sum(forcex(2:end,5))/numlen;
        vortexAFx = sum(forcex(2:end,6))/numlen;
        resultAFx = sum(forcex(2:end,7))/numlen;
        truereAFx = sum(forcex(2:end,8))/numlen;
        % Calculate Average Force in y-direction
        acceleAFy = sum(forcey(2:end,2))/numlen;
        frictiAFy = sum(forcey(2:end,3))/numlen;
        vicpreAFy1= sum(forcey(2:end,4))/numlen;
        vicpreAFy2= sum(forcey(2:end,5))/numlen;
        vortexAFy = sum(forcey(2:end,6))/numlen;
        resultAFy = sum(forcey(2:end,7))/numlen;
        truereAFy = sum(forcey(2:end,8))/numlen;
        % Record Data
        AverageData(:,i,1) = [time acceleAFx frictiAFx vicpreAFx1 vicpreAFx2 vortexAFx resultAFx truereAFx];
        AverageData(:,i,2) = [time acceleAFy frictiAFy vicpreAFy1 vicpreAFy2 vortexAFy resultAFy truereAFy];
    else
        % Calculate Average Force in x-direction
        acceleAFx = sum(forcex(2:end,2))/numlen;
        frictiAFx = sum(forcex(2:end,3))/numlen;
        vicpreAFx = sum(forcex(2:end,4))/numlen;
        vortexAFx = sum(forcex(2:end,5))/numlen;
        resultAFx = sum(forcex(2:end,6))/numlen;
        truereAFx = sum(forcex(2:end,7))/numlen;
        % Calculate Average Force in y-direction
        acceleAFy = sum(forcey(2:end,2))/numlen;
        frictiAFy = sum(forcey(2:end,3))/numlen;
        vicpreAFy = sum(forcey(2:end,4))/numlen;
        vortexAFy = sum(forcey(2:end,5))/numlen;
        resultAFy = sum(forcey(2:end,6))/numlen;
        truereAFy = sum(forcey(2:end,7))/numlen;
        % Record Data
        AverageData(:,i,1) = [time acceleAFx frictiAFx vicpreAFx vortexAFx resultAFx truereAFx];
        AverageData(:,i,2) = [time acceleAFy frictiAFy vicpreAFy vortexAFy resultAFy truereAFy];
    end
    fprintf('%s Data Average Ready =========================================\n',FileList(i,:));
end
fprintf('*******************************************************************\n');
%% Write Data
creatfolder([MkdirPath par 'AverageForce'])
% Write Average Force
[~,index] = sort(forcex(1,:));
forcex = forcex(:,index);
forcey = forcey(:,index);
writeforcex = [MkdirPath par 'AverageForce' par 'AverageFx.dat'];
writeforcey = [MkdirPath par 'AverageForce' par 'AverageFy.dat'];
if isNearWall==1
    file=fopen(writeforcex,'w');
    fprintf(file,'VARIABLES=\"%s\",\"AccelerationFx\",\"FrictionFx\",\"VicpreFx1\",\"VicpreFx2\",\"VortexFx\",\"ResultantFx\",\"TrueResFx\"\n',Abscissa);
    for k=1:size(FileList,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',AverageData(1,k,1),AverageData(2,k,1),AverageData(3,k,1),AverageData(4,k,1),AverageData(5,k,1),AverageData(6,k,1),AverageData(7,k,1),AverageData(8,k,1));
    end
    file=fopen(writeforcey,'w');
    fprintf(file,'VARIABLES=\"%s\",\"AccelerationFy\",\"FrictionFy\",\"VicpreFy1\",\"VicpreFy2\",\"VortexFy\",\"ResultantFy\",\"TrueResFy\"\n',Abscissa);
    for k=1:size(FileList,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',AverageData(1,k,2),AverageData(2,k,2),AverageData(3,k,2),AverageData(4,k,2),AverageData(5,k,2),AverageData(6,k,2),AverageData(7,k,2),AverageData(8,k,2));
    end
else
    file=fopen(writeforcex,'w');
    fprintf(file,'VARIABLES=\"%s\",\"AccelerationFx\",\"FrictionFx\",\"VicpreFx\",\"VortexFx\",\"ResultantFx\",\"TrueResFx\"\n',Abscissa);
    for k=1:size(FileList,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',AverageData(1,k,1),AverageData(2,k,1),AverageData(3,k,1),AverageData(4,k,1),AverageData(5,k,1),AverageData(6,k,1),AverageData(7,k,1));
    end
    file=fopen(writeforcey,'w');
    fprintf(file,'VARIABLES=\"%s\",\"AccelerationFy\",\"FrictionFy\",\"VicpreFy\",\"VortexFy\",\"ResultantFy\",\"TrueResFy\"\n',Abscissa);
    for k=1:size(FileList,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',AverageData(1,k,2),AverageData(2,k,2),AverageData(3,k,2),AverageData(4,k,2),AverageData(5,k,2),AverageData(6,k,2),AverageData(7,k,2));
    end
end
fclose all;