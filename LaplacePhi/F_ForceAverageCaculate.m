%% Calculate The Average Force 
run A_DefineFilePath.m
%% Reading Path
Abscissa = FileList(1,:);
Abscissa(end-3:end) = [];
%% Define Variables
AverageData = zeros(7,size(FileList,1),4);
for i=1:size(FileList,1)
    FilePath = [MkdirPath par FileList(i,:)];
    % Combinate Path
    forcexF = [FilePath par 'Result' par '5Combination' par 'ForceX.dat']; 
    forceyF = [FilePath par 'Result' par '5Combination' par 'ForceY.dat']; 
    powerxF = [FilePath par 'Result' par '5Combination' par 'PowerX.dat']; 
    PoweryF = [FilePath par 'Result' par '5Combination' par 'PowerY.dat']; 
    % Reading Files
    forcex = importdata(forcexF).data;
    forcey = importdata(forceyF).data;
    powerx = importdata(powerxF).data;
    powery = importdata(PoweryF).data;
    % Other Variables
    time = str2double(strrep(FileList(i,:),Abscissa,''));
    numlen = size(forcex,1)-1;
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
    % Calculate Average Power in x-direction
    acceleAPx = sum(powerx(2:end,2))/numlen;
    frictiAPx = sum(powerx(2:end,3))/numlen;
    vicpreAPx = sum(powerx(2:end,4))/numlen;
    vortexAPx = sum(powerx(2:end,5))/numlen;
    resultAPx = sum(powerx(2:end,6))/numlen;
    truereAPx = sum(powerx(2:end,7))/numlen;
    % Calculate Average Power in y-direction
    acceleAPy = sum(powery(2:end,2))/numlen;
    frictiAPy = sum(powery(2:end,3))/numlen;
    vicpreAPy = sum(powery(2:end,4))/numlen;
    vortexAPy = sum(powery(2:end,5))/numlen;
    resultAPy = sum(powery(2:end,6))/numlen;
    truereAPy = sum(powery(2:end,7))/numlen;
    % Record Data
    AverageData(:,i,1) = [time acceleAFx frictiAFx vicpreAFx vortexAFx resultAFx truereAFx];
    AverageData(:,i,2) = [time acceleAFy frictiAFy vicpreAFy vortexAFy resultAFy truereAFy];
    AverageData(:,i,3) = [time acceleAPx frictiAPx vicpreAPx vortexAPx resultAPx truereAPx];
    AverageData(:,i,4) = [time acceleAPy frictiAPy vicpreAPy vortexAPy resultAPy truereAPy];
end
fprintf('%s Data Average Ready =========================================\n',FileList(i,:));
fprintf('*******************************************************************\n');
%% Write Data
CreatDir([MkdirPath par 'PostAverage'])
% Write Average Force
[~,index] = sort(forcex(1,:));
forcex = forcex(:,index);
forcey = forcey(:,index);
writeforcex = [MkdirPath par 'PostAverage' par 'AverageFx.dat'];
writeforcey = [MkdirPath par 'PostAverage' par 'AverageFy.dat'];
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
fclose all;
% Write Average Power
powerx = powerx(:,index);
powery = powery(:,index);
writepowerx = [MkdirPath par 'PostAverage' par 'AveragePx.dat'];
writepowery = [MkdirPath par 'PostAverage' par 'AveragePy.dat'];
file=fopen(writepowerx,'w');
fprintf(file,'VARIABLES=\"%s\",\"AccelerationPx\",\"FrictionPx\",\"VicprePx\",\"VortePx\",\"ResultantPx\",\"TrueResPx\"\n',Abscissa);
for k=1:size(FileList,1)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',AverageData(1,k,3),AverageData(2,k,3),AverageData(3,k,3),AverageData(4,k,3),AverageData(5,k,3),AverageData(6,k,3),AverageData(7,k,3));
end
file=fopen(writepowery,'w');
fprintf(file,'VARIABLES=\"%s\",\"AccelerationPy\",\"FrictionPy\",\"VicprePy\",\"VortexPy\",\"ResultantPy\",\"TrueResPy\"\n',Abscissa);
for k=1:size(FileList,1)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',AverageData(1,k,4),AverageData(2,k,4),AverageData(3,k,4),AverageData(4,k,4),AverageData(5,k,4),AverageData(6,k,4),AverageData(7,k,4));
end
fclose all;

function [] = CreatDir(path)
if ~exist(path,'dir')
    mkdir(path);
end
end