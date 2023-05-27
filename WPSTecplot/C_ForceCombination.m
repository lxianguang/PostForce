%% File Parameters
run A_ParamtersDefine.m
for k=1:size(FileList,1)
    FilePath = [MkdirPath par FileList(k,:)];
    %% Reading Time
    if bodyType==0
        subdir  = dir([FilePath par 'DatBody' ]);
    else
        subdir  = dir([FilePath par 'DatBodyS']);
    end
    subdir(1:2) = [];
    numlen      = size (subdir,1);
    datatime    = zeros(numlen,1);
    for i=1:numlen
        if bodyType==2
            datatime(i) = str2double(strrep(strrep(subdir(i).name,'.dat',''),'Body',''));
        else
            abc = strrep(strrep(subdir(i).name,'.dat',''),'Body','');
            datatime(i) = str2double(strrep(strrep(abc,'001',''),'_',''));
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
    %% Acceleration Force And Power Combination
    AccelerationForce = zeros(numlen, 2);
    for i=1:numlen
        [filename1, filename2] = filenameget(i,'Fx','Fy','.txt');
        readfile1 = [FilePath par 'Result' par '3AcceleForce' par filename1];
        readfile2 = [FilePath par 'Result' par '3AcceleForce' par filename2];
        fx = importdata(readfile1).data*2;
        fy = importdata(readfile2).data*2;
        AccelerationForce(i,1) = -fx;
        AccelerationForce(i,2) = -fy;
    end
    %% Vortex Force And Power Combination
    VortexForce = zeros(numlen, 2);
    for i=1:numlen
        [filename1, filename2] = filenameget(i,'Fx','Fy','.txt');
        readfile1 = [FilePath par 'Result' par '1VortexForce' par filename1];
        readfile2 = [FilePath par 'Result' par '1VortexForce' par filename2];
        fx = importdata(readfile1).data*2;
        fy = importdata(readfile2).data*2;
        VortexForce(i,1) = fx;
        VortexForce(i,2) = fy;
    end
    %% VicPre Force And Power Combination
    if isNearWall==1
        VicPreForce = zeros(numlen, 2, 2);
        for i=1:numlen
            [filename1, filename2] = filenameget(i,'Fx01_','Fy01_','.txt');
            [filename3, filename4] = filenameget(i,'Fx02_','Fy02_','.txt');
            readfile1 = [FilePath par 'Result' par '2VicPreForce' par filename1];
            readfile2 = [FilePath par 'Result' par '2VicPreForce' par filename2];
            readfile3 = [FilePath par 'Result' par '2VicPreForce' par filename3];
            readfile4 = [FilePath par 'Result' par '2VicPreForce' par filename4];
            fx1 = importdata(readfile1).data*2;
            fy1 = importdata(readfile2).data*2;
            fx2 = importdata(readfile3).data*2;
            fy2 = importdata(readfile4).data*2;
            VicPreForce(i,1,1) = fx1 / Re;
            VicPreForce(i,2,1) = fy1 / Re;
            VicPreForce(i,1,2) = fx2 / Re;
            VicPreForce(i,2,2) = fy2 / Re;
        end
    else
        VicPreForce = zeros(numlen, 2);
        for i=1:numlen
            [filename1, filename2] = filenameget(i,'Fx','Fy','.txt');
            readfile1 = [FilePath par 'Result' par '2VicPreForce' par filename1];
            readfile2 = [FilePath par 'Result' par '2VicPreForce' par filename2];
            fx = importdata(readfile1).data*2;
            fy = importdata(readfile2).data*2;
            VicPreForce(i,1) = fx/Re;
            VicPreForce(i,2) = fy/Re;
        end
    end
    %% VicousForce Combination
    VicousForce = zeros(numlen, 2);
    for i=1:numlen
        if isNearWall==1
            [filename1, filename2] = filenameget(i,'Fx01_','Fy01_','.txt');
        else
            [filename1, filename2] = filenameget(i,'Fx','Fy','.txt');
        end
        readfile1 = [FilePath par 'Result' par '4FrictionForce' par filename1];
        readfile2 = [FilePath par 'Result' par '4FrictionForce' par filename2];
        fx = importdata(readfile1).data*2;
        fy = importdata(readfile2).data*2;
        VicousForce(i,1) = fx/Re;
        VicousForce(i,2) = fy/Re;
    end 
    %% Resultant Force Addition
    ResultantForce = zeros(numlen, 4);
    if isNearWall==1
        for i=1:numlen
            ResultantForce(i,1) = AccelerationForce(i,1)+VicousForce(i,1)+VortexForce(i,1)+VicPreForce(i,1,1)+VicPreForce(i,1,2);
            ResultantForce(i,2) = AccelerationForce(i,2)+VicousForce(i,2)+VortexForce(i,2)+VicPreForce(i,2,1)+VicPreForce(i,2,2);
        end
    else
        for i=1:numlen
           ResultantForce(i,1) = AccelerationForce(i,1)+VicousForce(i,1)+VortexForce(i,1)+VicPreForce(i,1);
           ResultantForce(i,2) = AccelerationForce(i,2)+VicousForce(i,2)+VortexForce(i,2)+VicPreForce(i,2);
        end
    end
    %% True Resultant Force Record
    TrueResultant = zeros(numlen, 2);
    for i=1:numlen
       TrueResultant(i,1) = forcex(i);
       TrueResultant(i,2) = forcey(i);
    end
    %% Write Data
    if isNearWall==1
        % Force in x-direction
        writeforce = [FilePath par 'Result' par '5Combination' par 'ForceX.dat' ];
        file=fopen(writeforce,'w');
        fprintf(file,'VARIABLES=\"T\",\"AccelerationFx\",\"FrictionFx\",\"VicpreFx1\",\"VicpreFx2\",\"VortexFx\",\"ResultantFx\",\"TrueResFx\"\n');
        for i=1:numlen
            fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),AccelerationForce(i,1),VicousForce(i,1),VicPreForce(i,1,1),VicPreForce(i,1,2),VortexForce(i,1),ResultantForce(i,1),TrueResultant(i,1));
        end
        close all;
        % Force in y-direction
        writeforce = [FilePath par 'Result' par '5Combination' par 'ForceY.dat' ];
        file=fopen(writeforce,'w');
        fprintf(file,'VARIABLES=\"T\",\"AccelerationFy\",\"FrictionFy\",\"VicpreFy1\",\"VicpreFy2\",\"VortexFy\",\"ResultantFy\",\"TrueResFy\"\n');
        for i=1:numlen
            fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),AccelerationForce(i,2),VicousForce(i,2),VicPreForce(i,2,1),VicPreForce(i,2,2),VortexForce(i,2),ResultantForce(i,2),TrueResultant(i,2));
        end
        fclose all;
    else
        % Force in x-direction
        writeforce = [FilePath par 'Result' par '5Combination' par 'ForceX.dat' ];
        file=fopen(writeforce,'w');
        fprintf(file,'VARIABLES=\"T\",\"AccelerationFx\",\"FrictionFx\",\"VicpreFx\",\"VortexFx\",\"ResultantFx\",\"TrueResFx\"\n');
        for i=1:numlen
            fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),AccelerationForce(i,1),VicousForce(i,1),VicPreForce(i,1),VortexForce(i,1),ResultantForce(i,1),TrueResultant(i,1));
        end
        % Force in y-direction
        writeforce = [FilePath par 'Result' par '5Combination' par 'ForceY.dat' ];
        file=fopen(writeforce,'w');
        fprintf(file,'VARIABLES=\"T\",\"AccelerationFy\",\"FrictionFy\",\"VicpreFy\",\"VortexFy\",\"ResultantFy\",\"TrueResFy\"\n');
        for i=1:numlen
            fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',datatime(i),AccelerationForce(i,2),VicousForce(i,2),VicPreForce(i,2),VortexForce(i,2),ResultantForce(i,2),TrueResultant(i,2));
        end
    end
    fclose all;
    fprintf('%s Combination End =========================================\n',FileList(k,:));
end
fprintf('*******************************************************************\n');