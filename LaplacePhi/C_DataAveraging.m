clc
clear
close all
%% FilePath
run A_DefineFilePath.m
for n=1:size(FileList,1)
    fprintf('%s\n',FileList(n,:));
    subdir=dir([MkdirPath '\' FileList(n,:) '\DatBody']);
    if size(subdir,1)<2
       error('There is no files in the folder')
    end
    subdir(1:2)   = [];
    % Aaveraging For Acceleration
    for num=1:size(subdir,1)
        BodyPath0 = [MkdirPath '\' FileList(n,:) '\DatBody\'  subdir(num).name];
        BodyPath1 = [MkdirPath '\' FileList(n,:) '\DatBodyN\' subdir(num).name];
        BodyData  = importdata(BodyPath0).data;
        NewBody   = dataAveraging(BodyData,5);
        file=fopen(BodyPath1,'w');
        fprintf(file,'variables = x,y,u,v,ax,ay,fxi,fyi,fxr,fyr \n');
        for i=1:size(BodyData,1)
            fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewBody(i,1),NewBody(i,2),NewBody(i,3),NewBody(i,4),NewBody(i,5),NewBody(i,6),NewBody(i,7),NewBody(i,8),NewBody(i,9),NewBody(i,10));
        end
    end
    fclose all;
    % Averaging For Velocity
    VelocityPath0 = [MkdirPath '\' FileList(n,:) '\DatInfo\SampBodyMean_0001.plt' ];
    VelocityPath1 = [MkdirPath '\' FileList(n,:) '\DatInfo\0SampBodyMean_0001.plt'];
    preparation(VelocityPath1,VelocityPath0)
    Velocitydata  = importdata(VelocityPath0).data;
    NewVelocity   = dataAveraging(Velocitydata,1);
    movefile(VelocityPath0,VelocityPath1)
    file=fopen(VelocityPath0,'w');
    fprintf(file,'variables= "t"  "x"  "y"  "u"  "v"  "ax"  "ay"\n');
    for i=1:size(Velocitydata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewVelocity(i,1),NewVelocity(i,2),NewVelocity(i,3),NewVelocity(i,4),NewVelocity(i,5),NewVelocity(i,6),NewVelocity(i,7));
    end
    VelocityError = maxerror(Velocitydata(:,4),NewVelocity(:,4));
    fprintf('U max error:%.6f percent\n',VelocityError*100);
    % Averaging For Force
    ForcePath0    = [MkdirPath '\' FileList(n,:) '\DatInfo\ForceDirect_0001.plt'  ];
    ForcePath1    = [MkdirPath '\' FileList(n,:) '\DatInfo\0ForceDirect_0001.plt' ];
    preparation(ForcePath1,ForcePath0)
    Forcedata     = importdata(ForcePath0).data;
    NewForce      = dataAveraging(Forcedata,10);
    movefile(ForcePath0,ForcePath1)
    file=fopen(ForcePath0,'w');
    fprintf(file,' variables= "t"  "Fx"  "Fy"\n');
    for i=1:size(Forcedata,1)
        fprintf(file,'%.6f    %.6f    %.6f\n',NewForce(i,1),NewForce(i,2),NewForce(i,3));
    end
    ForceError = maxerror(Forcedata(:,2),NewForce(:,2));
    fprintf('F max error:%.6f percent\n',ForceError*100);
%     % Averaging For Power
%     PowerPath0    = [MkdirPath '\' FileList(n,:) '\DatInfo\Power_0001.plt'  ];
%     PowerPath1    = [MkdirPath '\' FileList(n,:) '\DatInfo\0Power_0001.plt' ];
%     preparation(PowerPath1,PowerPath0)
%     Powerdata     = importdata(PowerPath0).data;
%     NewPower      = dataAveraging(Powerdata,10);
%     movefile(PowerPath0,PowerPath1)
%     file=fopen(PowerPath0,'w');
%     fprintf(file,' variables= "t" "Ptot" "Paero" "Piner" "Pax" "Pay"  "Pix" "Piy" \n');
%     for i=1:size(Powerdata,1)
%         fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewPower(i,1),NewPower(i,2),NewPower(i,3),NewPower(i,4),NewPower(i,5),NewPower(i,6),NewPower(i,7),NewPower(i,8));
%     end
%     PowerError = maxerror(Powerdata(:,3),NewPower(:,3));
%     fprintf('P max error:%.6f percent\n',PowerError*100);
%     % Averaging For Energy
%     EnergyPath0    = [MkdirPath '\' FileList(n,:) '\DatInfo\Energy_0001.plt'  ];
%     EnergyPath1    = [MkdirPath '\' FileList(n,:) '\DatInfo\0Energy_0001.plt' ];
%     preparation(EnergyPath1,EnergyPath0)
%     Energydata     = importdata(EnergyPath0).data;
%     NewEnergy      = dataAveraging(Energydata,1);
%     movefile(EnergyPath0,EnergyPath1)
%     file=fopen(EnergyPath0,'w');
%     fprintf(file,'variables= "t","Es","Eb","Ep","Ek","Ew","Et"\n');
%     for i=1:size(Energydata,1)
%         fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewEnergy(i,1),NewEnergy(i,2),NewEnergy(i,3),NewEnergy(i,4),NewEnergy(i,5),NewEnergy(i,6),NewEnergy(i,7));
%     end
%     EnergyError = maxerror(Energydata(:,4),NewEnergy(:,4));
%     fprintf('E max error:%.6f percent\n',EnergyError*100);
    fclose all;
end

function [] = preparation(filename0,filename1)
if  exist(filename0,'file')
    delete(filename1)
    movefile(filename0,filename1)
end
end

function [ndata] = dataAveraging(data,n)
for i=1:n
    data = dataaveraging(data);
end
ndata = data;
end

function [error] = maxerror(data0,data1)
    [m,p]  = max(data0);
    error1 = abs((m - data1(p))/m);
    [n,q]  = min(data0);
    error2 = abs((n - data1(q))/n);
    error  = max(error1,error2);
end