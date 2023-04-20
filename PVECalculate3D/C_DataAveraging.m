%% FilePath
run A_DefineFilePath.m
%% Smooth Lines
for n=1:size(FileList,1)
    CreatDir([CopyPath par FileList(n,:) par 'DatInfoS']);
    % Averaging For Velocity
    VelocityPath0 = [CopyPath par FileList(n,:) par 'DatInfo'  par 'SampBodyCentM00' num '.plt'];
    VelocityPath1 = [CopyPath par FileList(n,:) par 'DatInfoS' par 'SampBodyCentM00' num '.plt'];
    Velocitydata0 = importdata(VelocityPath0);
    Velocitydata  = str2num(cell2mat(Velocitydata0(2:end)));
    NewVelocity0  = dataAveraging(Velocitydata(:,5:end),n_aver(1));
    NewVelocity   = [Velocitydata(:,1:4) NewVelocity0];
    file=fopen(VelocityPath1,'w');
    fprintf(file,'variables= "t"  "x"  "y"  "z"  "u"  "v"  "w"  "ax"  "ay"  "az"\n');
    for i=1:size(Velocitydata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewVelocity(i,1),NewVelocity(i,2),NewVelocity(i,3),NewVelocity(i,4),NewVelocity(i,5),NewVelocity(i,6),NewVelocity(i,7),NewVelocity(i,8),NewVelocity(i,9),NewVelocity(i,10));
    end
    VelocityError = maxerror(Velocitydata(:,5),NewVelocity(:,5));
    fprintf('Velocity     max error:%.6f percent\n',VelocityError*100);
    % Averaging For Power
    PowerPath0    = [CopyPath par FileList(n,:) par 'DatInfo'  par 'Power00' num '.plt' ];
    PowerPath1    = [CopyPath par FileList(n,:) par 'DatInfoS' par 'Power00' num '.plt' ];
    Powerdata0    = importdata(PowerPath0);
    Powerdata     = str2num(cell2mat(Powerdata0(2:end)));
    NewPower0     = dataAveraging(Powerdata(:,2:end),n_aver(2));
    NewPower      = [Powerdata(:,1) NewPower0];
    file=fopen(PowerPath1,'w');
    fprintf(file,' variables= "t" "Ptot" "Paero" "Piner" "Pax" "Pay" "Paz" "Pix" "Piy" "Piz"\n');
    for i=1:size(Powerdata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewPower(i,1),NewPower(i,2),NewPower(i,3),NewPower(i,4),NewPower(i,5),NewPower(i,6),NewPower(i,7),NewPower(i,8),NewPower(i,9),NewPower(i,10));
    end
    PowerError = maxerror(Powerdata(:,3),NewPower(:,3));
    fprintf('Power        max error:%.6f percent\n',PowerError*100);
    % Averaging For Force
    ForcePath0    = [CopyPath par FileList(n,:) par 'DatInfo'  par 'ForceDirect00' num '.plt' ];
    ForcePath1    = [CopyPath par FileList(n,:) par 'DatInfoS' par 'ForceDirect00' num '.plt' ];
    Forcedata0    = importdata(ForcePath0);
    Forcedata     = str2num(cell2mat(Forcedata0(2:end)));
    NewForce0     = dataAveraging(Forcedata(:,2:end),n_aver(3));
    NewForce      = [Forcedata(:,1) NewForce0];
    file=fopen(ForcePath1,'w');
    fprintf(file,' variables= "t"  "Fx"  "Fy"  "Fz"\n');
    for i=1:size(Forcedata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f\n',NewForce(i,1),NewForce(i,2),NewForce(i,3),NewForce(i,4));
    end
    ForceError = maxerror(Forcedata(:,2),NewForce(:,2));
    fprintf('Force        max error:%.6f percent\n',ForceError*100);
    % Averaging For Stress Energy
    EnergyPath0  = [CopyPath par FileList(n,:) par 'DatInfo'  par 'Energy00' num '.plt' ];
    EnergyPath1  = [CopyPath par FileList(n,:) par 'DatInfoS' par 'Energy00' num '.plt' ];
    Energydata0  = importdata(EnergyPath0);
    Energydata   = str2num(cell2mat(Energydata0(2:end)));
    NewEnergy0   = dataAveraging(Energydata(:,2:end),n_aver(4));
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
contrastplot(Velocitydata(:,1),Velocitydata(:,5),NewVelocity(:,1),NewVelocity(:,5),1,'Velocity')
contrastplot(Powerdata(:,1)   ,Powerdata(:,3)   ,NewPower(:,1)   ,NewPower(:,3)   ,2,   'Power')
contrastplot(Forcedata(:,1)   ,Forcedata(:,2)   ,NewForce(:,1)   ,NewForce(:,2)   ,3,   'Force')
contrastplot(Energydata(:,1)  ,Energydata(:,4)  ,NewEnergy(:,1)  ,NewEnergy(:,4)  ,4,  'Energy')
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

function [] = CreatDir(path)
if ~exist(path,'dir')
    mkdir(path);
end
end