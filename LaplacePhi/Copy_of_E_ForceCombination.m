run A_DefineFilePath.m
for k=1:size(FileList,1)
    FilePath = [MkdirPath par FileList(k,:)];
    %% Reading Time
    datatime = (0:1:20);
    numlen = length(datatime);
    %% Acceleration Force And Power Combination
    AccelerationForce = zeros(numlen, 4);
    for i=1:numlen
        [filename1, filename2] = FilenameGet(i);
        readfile1 = [FilePath par 'Result' par '3AddedForce' par filename1];
        readfile2 = [FilePath par 'Result' par '3AddedForce' par filename2];
        fx = importdata(readfile1).data*2;
        fy = importdata(readfile2).data*2;
        AccelerationForce(i,1) = -fx;
        AccelerationForce(i,2) = -fy;
    end
    %% Vortex Force And Power Combination
    VortexForce = zeros(numlen, 4);
    for i=1:numlen
        [filename1, filename2] = FilenameGet(i);
        readfile1 = [FilePath par 'Result' par '1VortexForce' par filename1];
        readfile2 = [FilePath par 'Result' par '1VortexForce' par filename2];
        fx = importdata(readfile1).data*2;
        fy = importdata(readfile2).data*2;
        VortexForce(i,1) = fx;
        VortexForce(i,2) = fy;
    end
    %% VicPre Force And Power Combination
    VicPreForce = zeros(numlen, 4);
    for i=1:numlen
        [filename1, filename2] = FilenameGet(i);
        readfile1 = [FilePath par 'Result' par '2VicPreForce' par filename1];
        readfile2 = [FilePath par 'Result' par '2VicPreForce' par filename2];
        fx = importdata(readfile1).data*2;
        fy = importdata(readfile2).data*2;
        VicPreForce(i,1) = fx/Re;
        VicPreForce(i,2) = fy/Re;
    end
    %% VicousForce Combination
    VicousForce = zeros(numlen, 4);
    for i=1:numlen
        [filename1, filename2] = FilenameGet(i);
        readfile1 = [FilePath par 'Result' par '4FrictionForce' par filename1];
        readfile2 = [FilePath par 'Result' par '4FrictionForce' par filename2];
        fx = importdata(readfile1).data*2;
        fy = importdata(readfile2).data*2;
        VicousForce(i,1) = fx/Re;
        VicousForce(i,2) = fy/Re;
    end
    %% Test Force Combination
    TestForce = zeros(numlen, 4);
    for i=1:numlen
        [filename1, filename2] = FilenameGet(i);
        readfile1 = [FilePath par 'Result' par 'Test' par filename1];
        readfile2 = [FilePath par 'Result' par 'Test' par filename2];
        fx = importdata(readfile1).data*2;
        fy = importdata(readfile2).data*2;
        TestForce(i,1) = fx/Re;
        TestForce(i,2) = fy/Re;
    end
    %% Resultant Force Addition
    ResultantForce = zeros(numlen, 4);
    for i=1:numlen
       ResultantForce(i,1) = AccelerationForce(i,1)+VicousForce(i,1)+VortexForce(i,1)+VicPreForce(i,1)+TestForce(i,1);
       ResultantForce(i,2) = AccelerationForce(i,2)+VicousForce(i,2)+VortexForce(i,2)+VicPreForce(i,2)+TestForce(i,2);
       ResultantForce(i,3) = AccelerationForce(i,3)+VicousForce(i,3)+VortexForce(i,3)+VicPreForce(i,3)+TestForce(i,3);
       ResultantForce(i,4) = AccelerationForce(i,4)+VicousForce(i,4)+VortexForce(i,4)+VicPreForce(i,4)+TestForce(i,4);
    end
    %% Write Data
    % Force in x-direction
    writeforce = [FilePath par 'Result' par '5Combination' par 'ForceX.dat' ];
    file=fopen(writeforce,'w');
    fprintf(file,'VARIABLES=\"T\",\"FrictionFx\",\"VicpreFx\",\"VortexFx\",\"ResultantFx\"\n');
    for i=1:numlen
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),VicousForce(i,1),VicPreForce(i,1),VortexForce(i,1),ResultantForce(i,1));
    end
    close all;
    % Force in y-direction
    writeforce = [FilePath par 'Result' par '5Combination' par 'ForceY.dat' ];
    file=fopen(writeforce,'w');
    fprintf(file,'VARIABLES=\"T\",\"FrictionFy\",\"VicpreFy\",\"VortexFy\",\"ResultantFy\"\n');
    for i=1:numlen
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),VicousForce(i,2),VicPreForce(i,2),VortexForce(i,2),ResultantForce(i,2));
    end
    close all;
    % Power in x-direction
    writeforce = [FilePath par 'Result' par '5Combination' par 'PowerX.dat' ];
    file=fopen(writeforce,'w');
    fprintf(file,'VARIABLES=\"T\",\"FrictionPx\",\"VicprePx\",\"VortexPx\",\"ResultantPx\"\n');
    for i=1:numlen
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),VicousForce(i,3),VicPreForce(i,3),VortexForce(i,3),ResultantForce(i,3));
    end
    close all;
    % Power in y-direction
    writeforce = [FilePath par 'Result' par '5Combination' par 'PowerY.dat' ];
    file=fopen(writeforce,'w');
    fprintf(file,'VARIABLES=\"T\",\"FrictionPy\",\"VicprePy\",\"VortexPy\",\"ResultantPy\"\n');
    for i=1:numlen
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),VicousForce(i,4),VicPreForce(i,4),VortexForce(i,4),ResultantForce(i,4));
    end
    fclose all;
    fprintf('%s Combination End =========================================\n',FileList(k,:));
end
fprintf('*******************************************************************\n');
%% Funtions
function [name1,name2] = FilenameGet(num)
if num<10
    name1 = ['Fx00' num2str(num) '.txt'];
    name2 = ['Fy00' num2str(num) '.txt'];
elseif num<100
    name1 = ['Fx0'  num2str(num) '.txt'];
    name2 = ['Fy0'  num2str(num) '.txt'];
else
    name1 = ['Fx'   num2str(num) '.txt'];
    name2 = ['Fy'   num2str(num) '.txt'];
end
end