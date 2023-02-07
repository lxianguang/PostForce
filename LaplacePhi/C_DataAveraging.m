%% FilePath
run B_MkdirAndFileRename.m
%% Smooth Lines
for n=1:size(FileList,1)
    subdir=dir([MkdirPath par FileList(n,:) par 'DatBody']);
    if size(subdir,1)<2
       error('There is no files in the folder')
    end
    subdir(1:2)   = [];
    AccelError = zeros(1,size(subdir,1));
    % Aaveraging For Acceleration
    for num=1:size(subdir,1)
        BodyPath0 = [MkdirPath par FileList(n,:) par 'DatBody'  par subdir(num).name];
        BodyPath1 = [MkdirPath par FileList(n,:) par 'DatBodyS' par subdir(num).name];
        BodyData  = importdata(BodyPath0).data;
        NewBody0  = dataAveraging(BodyData(:,3:end),n_aver(1));
        NewBody   = [BodyData(:,1:2) NewBody0];
        file=fopen(BodyPath1,'w');
        fprintf(file,'variables = x,y,u,v,ax,ay,fxi,fyi,fxr,fyr \n');
        for i=1:size(BodyData,1)
            fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewBody(i,1),NewBody(i,2),NewBody(i,3),NewBody(i,4),NewBody(i,5),NewBody(i,6),NewBody(i,7),NewBody(i,8),NewBody(i,9),NewBody(i,10));
        end
    AccelError(i) = maxerror(BodyData(:,5),NewBody(:,5));
    end
    fprintf('Acceleration max error:%.6f percent\n',max(AccelError)*100);
    % Averaging For Velocity
    VelocityPath0 = [MkdirPath par FileList(n,:) par 'DatInfo'  par 'SampBodyMean_0001.plt'];
    VelocityPath1 = [MkdirPath par FileList(n,:) par 'DatInfoS' par 'SampBodyMean_0001.plt'];
    Velocitydata  = importdata(VelocityPath0).data;
    NewVelocity0  = dataAveraging(Velocitydata(:,4:end),n_aver(2));
    NewVelocity   = [Velocitydata(:,1:3) NewVelocity0];
    file=fopen(VelocityPath1,'w');
    fprintf(file,'variables= "t"  "x"  "y"  "u"  "v"  "ax"  "ay"\n');
    for i=1:size(Velocitydata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewVelocity(i,1),NewVelocity(i,2),NewVelocity(i,3),NewVelocity(i,4),NewVelocity(i,5),NewVelocity(i,6),NewVelocity(i,7));
    end
    VelocityError = maxerror(Velocitydata(:,4),NewVelocity(:,4));
    fprintf('Velocity     max error:%.6f percent\n',VelocityError*100);
    % Averaging For Force
    ForcePath0    = [MkdirPath par FileList(n,:) par 'DatInfo'  par 'ForceDirect_0001.plt' ];
    ForcePath1    = [MkdirPath par FileList(n,:) par 'DatInfoS' par 'ForceDirect_0001.plt' ];
    Forcedata     = importdata(ForcePath0).data;
    NewForce0     = dataAveraging(Forcedata(:,2:end),n_aver(3));
    NewForce      = [Forcedata(:,1) NewForce0];
    file=fopen(ForcePath1,'w');
    fprintf(file,' variables= "t"  "Fx"  "Fy"\n');
    for i=1:size(Forcedata,1)
        fprintf(file,'%.6f    %.6f    %.6f\n',NewForce(i,1),NewForce(i,2),NewForce(i,3));
    end
    ForceError = maxerror(Forcedata(:,2),NewForce(:,2));
    fprintf('Force        max error:%.6f percent\n',ForceError*100);
    % Averaging For Power
    PowerPath0    = [MkdirPath par FileList(n,:) par 'DatInfo'  par 'Power_0001.plt' ];
    PowerPath1    = [MkdirPath par FileList(n,:) par 'DatInfoS' par 'Power_0001.plt' ];
    Powerdata     = importdata(PowerPath0).data;
    NewPower0     = dataAveraging(Powerdata(:,2:end),n_aver(4));
    NewPower      = [Powerdata(:,1) NewPower0];
    file=fopen(PowerPath1,'w');
    fprintf(file,' variables= "t" "Ptot" "Paero" "Piner" "Pax" "Pay"  "Pix" "Piy"\n');
    for i=1:size(Powerdata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewPower(i,1),NewPower(i,2),NewPower(i,3),NewPower(i,4),NewPower(i,5),NewPower(i,6),NewPower(i,7),NewPower(i,8));
    end
    PowerError = maxerror(Powerdata(:,3),NewPower(:,3));
    fprintf('Power        max error:%.6f percent\n',PowerError*100);
    % Averaging For Point Velocity
    PointPath0    = [MkdirPath par FileList(n,:) par 'DatInfo'  par 'SampBodyNodeBegin_0001.plt' ];
    PointPath1    = [MkdirPath par FileList(n,:) par 'DatInfoS' par 'SampBodyNodeBegin_0001.plt' ];
    Pointdata     = importdata(PointPath0).data;
    NewPoint0     = dataAveraging(Pointdata(:,2:end),n_aver(5));
    NewPoint      = [Pointdata(:,1) NewPoint0];
    file=fopen(PointPath1,'w');
    fprintf(file,' variables= "t"  "x"  "y"  "u"  "v"  "ax"  "ay"\n');
    for i=1:size(Pointdata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewPoint(i,1),NewPoint(i,2),NewPoint(i,3),NewPoint(i,4),NewPoint(i,5),NewPoint(i,6),NewPoint(i,7));
    end
    PointError = maxerror(Pointdata(:,5),NewPoint(:,5));
    fprintf('Point        max error:%.6f percent\n',PointError*100);
    % Averaging For Stress Energy
    EnergyPath0  = [MkdirPath par FileList(n,:) par 'DatInfo'  par 'Energy_0001.plt' ];
    EnergyPath1  = [MkdirPath par FileList(n,:) par 'DatInfoS' par 'Energy_0001.plt' ];
    Energydata   = importdata(EnergyPath0).data;
    NewEnergy0   = dataAveraging(Energydata(:,2:end),n_aver(6));
    NewEnergy    = [Energydata(:,1) NewEnergy0];
    file=fopen(EnergyPath1,'w');
    fprintf(file,' variables= "t","Es","Eb","Ep","Ek","Ew","Et"\n');
    for i=1:size(Energydata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewEnergy(i,1),NewEnergy(i,2),NewEnergy(i,3),NewEnergy(i,4),NewEnergy(i,5),NewEnergy(i,6),NewEnergy(i,7));
    end
    EnergyError = maxerror(Energydata(:,4),NewEnergy(:,4));
    fprintf('Energy       max error:%.6f percent\n',EnergyError*100);
    fclose all;
    fprintf('%s Smooth Ready ============================================\n',FileList(n,:));
end
fprintf('*******************************************************************\n');
contrastplot(BodyData(:,1)    ,BodyData(:,5)    ,NewBody(:,1)    ,NewBody(:,5)    ,1, 'Acceleration')
contrastplot(Velocitydata(:,1),Velocitydata(:,4),NewVelocity(:,1),NewVelocity(:,4),2,     'Velocity')
contrastplot(Forcedata(:,1)   ,Forcedata(:,2)   ,NewForce(:,1)   ,NewForce(:,2)   ,3,        'Force')
contrastplot(Powerdata(:,1)   ,Powerdata(:,3)   ,NewPower(:,1)   ,NewPower(:,3)   ,4,        'Power')
contrastplot(Pointdata(:,1)   ,Pointdata(:,5)   ,NewPoint(:,1)   ,NewPoint(:,5)   ,5,'PointVelocity')
contrastplot(Energydata(:,1)  ,Energydata(:,4)  ,NewEnergy(:,1)  ,NewEnergy(:,4)  ,6,       'Energy')
function [ndata] = dataAveraging(data,n)
if n
    for i=1:n
        data = dataaveraging(data);
    end
end
ndata = data;
end

function [error] = maxerror(data0,data1)
    [m, n] = size(data0);
    err    = data0-data1;
    error  = sqrt(sum(sum(err.*err))/m/n);
end

function [] = contrastplot(data1,data2,data3,data4,n,ntitle)
    figure(n)
    plot(data1,data2)
    hold on 
    plot(data3,data4)
    title(ntitle)
end