clc
clear
close all
%% FilePath
run A_DefineFilePath.m
for n=1:size(FileList,1)
    fprintf('%s\n',FileList(n,:));
    % Averaging For Velocity
    VelocityPath0 = [CopyPath '\' FileList(n,:) '\DatInfo\SampBodyMean_0001.plt' ];
    VelocityPath1 = [CopyPath '\' FileList(n,:) '\DatInfo\0SampBodyMean_0001.plt'];
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
%     % Averaging For Force
%     ForcePath0    = [CopyPath '\' FileList(n,:) '\DatInfo\ForceDirect_0001.plt'  ];
%     ForcePath1    = [CopyPath '\' FileList(n,:) '\DatInfo\0ForceDirect_0001.plt' ];
%     preparation(ForcePath1,ForcePath0)
%     Forcedata     = importdata(ForcePath0).data;
%     NewForce      = dataAveraging(Forcedata,10);
%     movefile(ForcePath0,ForcePath1)
%     file=fopen(ForcePath0,'w');
%     fprintf(file,' variables= "t"  "Fx"  "Fy"\n');
%     for i=1:size(Forcedata,1)
%         fprintf(file,'%.6f    %.6f    %.6f\n',NewForce(i,1),NewForce(i,2),NewForce(i,3));
%     end
%     ForceError = maxerror(Forcedata(:,2),NewForce(:,2));
%     fprintf('F max error:%.6f percent\n',ForceError*100);
    % Averaging For Power
    PowerPath0    = [CopyPath '\' FileList(n,:) '\DatInfo\Power_0001.plt'  ];
    PowerPath1    = [CopyPath '\' FileList(n,:) '\DatInfo\0Power_0001.plt' ];
    preparation(PowerPath1,PowerPath0)
    Powerdata     = importdata(PowerPath0).data;
    NewPower      = dataAveraging(Powerdata,1);
    movefile(PowerPath0,PowerPath1)
    file=fopen(PowerPath0,'w');
    fprintf(file,' variables= "t" "Ptot" "Paero" "Piner" "Pax" "Pay"  "Pix" "Piy" \n');
    for i=1:size(Powerdata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewPower(i,1),NewPower(i,2),NewPower(i,3),NewPower(i,4),NewPower(i,5),NewPower(i,6),NewPower(i,7),NewPower(i,8));
    end
    PowerError = maxerror(Powerdata(:,3),NewPower(:,3));
    fprintf('P max error:%.6f percent\n',PowerError*100);
    % Averaging For Energy
    EnergyPath0    = [CopyPath '\' FileList(n,:) '\DatInfo\Energy_0001.plt'  ];
    EnergyPath1    = [CopyPath '\' FileList(n,:) '\DatInfo\0Energy_0001.plt' ];
    preparation(EnergyPath1,EnergyPath0)
    Energydata     = importdata(EnergyPath0).data;
    NewEnergy      = dataAveraging(Energydata,1);
    movefile(EnergyPath0,EnergyPath1)
    file=fopen(EnergyPath0,'w');
    fprintf(file,'variables= "t","Es","Eb","Ep","Ek","Ew","Et"\n');
    for i=1:size(Energydata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewEnergy(i,1),NewEnergy(i,2),NewEnergy(i,3),NewEnergy(i,4),NewEnergy(i,5),NewEnergy(i,6),NewEnergy(i,7));
    end
    EnergyError = maxerror(Energydata(:,4),NewEnergy(:,4));
    fprintf('E max error:%.6f percent\n',EnergyError*100);
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
    aver   = sum(data0)/length(data0);
    error  = max(abs((data0-data1)/aver));
end