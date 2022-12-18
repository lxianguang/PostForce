clc;
close all;
clear;
%% Parameters
Re = 100;
run A_DefineFilePath.m
for k=1:size(FileList,1)
    fprintf('%s\n',FileList(k,:));
    FilePath = [MkdirPath '\' FileList(k,:)];
    %% Reading Time
    subdir      = dir([FilePath '\DatBody']);
    subdir(1:2) = [];
    numlen      = size (subdir,1);
    datatime    = zeros(numlen,1);
    for i=1:numlen
       datatime(i) = str2double(strrep(strrep(subdir(i).name,'_001.dat',''),'Body','')); 
    end
    %% Interpolation Velocity And Resultant Force
    maindir1  = [FilePath '\DatInfo\SampBodyMean_0001.plt'];
    velocity0 = importdata(maindir1).data;
    velocityx = interp1(velocity0(:,1),velocity0(:,4),datatime,'spline');
    velocityy = interp1(velocity0(:,1),velocity0(:,5),datatime,'spline');
    maindir2  = [FilePath '\DatInfo\ForceDirect_0001.plt'];
    force0    = importdata(maindir2).data;
    forcex    = interp1(force0(:,1),force0(:,2),datatime,'spline');
    forcey    = interp1(force0(:,1),force0(:,3),datatime,'spline');
    %% Acceleration Force And Power Combination
    AccelerationForce = zeros(numlen, 4);
    for i=1:numlen
        [filename1, filename2] = FilenameGet(i);
        readfile1 = [FilePath '\Result\3AddedForce\' filename1];
        readfile2 = [FilePath '\Result\3AddedForce\' filename2];
        fx = importdata(readfile1).data*2;
        fy = importdata(readfile2).data*2;
        AccelerationForce(i,1) = -fx;
        AccelerationForce(i,2) = -fy;
        AccelerationForce(i,3) = -fx * velocityx(i);
        AccelerationForce(i,4) = -fy * velocityy(i);
    end
    %% Vortex Force And Power Combination
    VortexForce = zeros(numlen, 4);
    for i=1:numlen
        [filename1, filename2] = FilenameGet(i);
        readfile1 = [FilePath '\Result\1VortexForce\' filename1];
        readfile2 = [FilePath '\Result\1VortexForce\' filename2];
        fx = importdata(readfile1).data*2;
        fy = importdata(readfile2).data*2;
        VortexForce(i,1) = fx;
        VortexForce(i,2) = fy;
        VortexForce(i,3) = fx * velocityx(i);
        VortexForce(i,4) = fy * velocityy(i);
    end
    %% VicPre Force And Power Combination
    VicPreForce = zeros(numlen, 4);
    for i=1:numlen
        [filename1, filename2] = FilenameGet(i);
        readfile1 = [FilePath '\Result\2VicPreForce\' filename1];
        readfile2 = [FilePath '\Result\2VicPreForce\' filename2];
        fx = importdata(readfile1).data*2;
        fy = importdata(readfile2).data*2;
        VicPreForce(i,1) = fx/Re;
        VicPreForce(i,2) = fy/Re;
        VicPreForce(i,3) = fx/Re * velocityx(i);
        VicPreForce(i,4) = fy/Re * velocityy(i);
    end
    %% VicousForce Combination
    VicousForce = zeros(numlen, 4);
    for i=1:numlen
        [filename1, filename2] = FilenameGet(i);
        readfile1 = [FilePath '\Result\4FrictionForce\' filename1];
        readfile2 = [FilePath '\Result\4FrictionForce\' filename2];
        fx = importdata(readfile1).data*2;
        fy = importdata(readfile2).data*2;
        VicousForce(i,1) = fx/Re;
        VicousForce(i,2) = fy/Re;
        VicousForce(i,3) = fx/Re * velocityx(i);
        VicousForce(i,4) = fy/Re * velocityy(i);
    end
    %% Resultant Force Addition
    ResultantForce = zeros(numlen, 4);
    for i=1:numlen
       ResultantForce(i,1) = AccelerationForce(i,1)+VicousForce(i,1)+VortexForce(i,1)+VicPreForce(i,1);
       ResultantForce(i,2) = AccelerationForce(i,2)+VicousForce(i,2)+VortexForce(i,2)+VicPreForce(i,2);
       ResultantForce(i,3) = AccelerationForce(i,3)+VicousForce(i,3)+VortexForce(i,3)+VicPreForce(i,3);
       ResultantForce(i,4) = AccelerationForce(i,4)+VicousForce(i,4)+VortexForce(i,4)+VicPreForce(i,4);
    end
    %% True Resultant Force Record
    TrueResultant = zeros(numlen, 4);
    for i=1:numlen
       TrueResultant(i,1) = forcex(i);
       TrueResultant(i,2) = forcey(i);
       TrueResultant(i,3) = forcex(i)*velocityx(i);
       TrueResultant(i,4) = forcey(i)*velocityy(i);
    end
    %% Write Data
    % Force in x-direction
    writeforce = [FilePath '\Result\5Combination\ForceX.dat' ];
    file=fopen(writeforce,'w');
    fprintf(file,'VARIABLES=\"T\",\"AccelerationFx\",\"FrictionFx\",\"VicpreFx\",\"VortexFx\",\"ResultantFx\",\"TrueResFx\"\n');
    for i=1:numlen
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),AccelerationForce(i,1),VicousForce(i,1),VicPreForce(i,1),VortexForce(i,1),ResultantForce(i,1),TrueResultant(i,1));
    end
    close all;
    % Force in y-direction
    writeforce = [FilePath '\Result\5Combination\ForceY.dat' ];
    file=fopen(writeforce,'w');
    fprintf(file,'VARIABLES=\"T\",\"AccelerationFy\",\"FrictionFy\",\"VicpreFy\",\"VortexFy\",\"ResultantFy\",\"TrueResFy\"\n');
    for i=1:numlen
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),AccelerationForce(i,2),VicousForce(i,2),VicPreForce(i,2),VortexForce(i,2),ResultantForce(i,2),TrueResultant(i,2));
    end
    close all;
    % Power in x-direction
    writeforce = [FilePath '\Result\5Combination\PowerX.dat' ];
    file=fopen(writeforce,'w');
    fprintf(file,'VARIABLES=\"T\",\"AccelerationPx\",\"FrictionPx\",\"VicprePx\",\"VortexPx\",\"ResultantPx\",\"TrueResPx\"\n');
    for i=1:numlen
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),AccelerationForce(i,3),VicousForce(i,3),VicPreForce(i,3),VortexForce(i,3),ResultantForce(i,3),TrueResultant(i,3));
    end
    close all;
    % Power in y-direction
    writeforce = [FilePath '\Result\5Combination\PowerY.dat' ];
    file=fopen(writeforce,'w');
    fprintf(file,'VARIABLES=\"T\",\"AccelerationPy\",\"FrictionPy\",\"VicprePy\",\"VortexPy\",\"ResultantPy\",\"TrueResPy\"\n');
    for i=1:numlen
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),AccelerationForce(i,4),VicousForce(i,4),VicPreForce(i,4),VortexForce(i,4),ResultantForce(i,4),TrueResultant(i,4));
    end
    fclose all;
end

%% Funtions
function [name1,name2] = FilenameGet(num)
if num<10
    name1 = ['Fx00' num2str(num) '.txt'];
    name2 = ['Fy00' num2str(num) '.txt'];
elseif num<100
    name1 = ['Fx0' num2str(num) '.txt'];
    name2 = ['Fy0' num2str(num) '.txt'];
else
    name1 = ['Fx' num2str(num) '.txt'];
    name2 = ['Fy' num2str(num) '.txt'];
end
end