clc;
close all;
clear;
%% Parameters
Re = 100;
path = 'G:\DataFile\ShearPlate\Force\Re100A0.50S1.00\K50.0';
subdir=dir([path '\Result\VortexForce']);
len = size(subdir,1)/2-1;
%% Reading Time
maindir0 = [path '\Result\Combination\AddMassForce.dat'];
data0 = importdata(maindir0).data;
%% Reading And Interpolation Velocity 
maindir00 = [path '\Result\Combination\SampBodyCentM.dat'];
if ~exist(maindir00,'file')
    error('No velocity! file')
end
velocity0 = importdata(maindir00).data;
velocityx = interp1(velocity0(:,1),velocity0(:,4),data0(:,1),'spline');
velocityy = interp1(velocity0(:,1),velocity0(:,5),data0(:,1),'spline');
%% AddMassForce Power Caculate
AddMassForce = zeros(len, 5);
for i=1:size(data0,1)
    AddMassForce(i,1) = data0(i,1);
    AddMassForce(i,2) = data0(i,2);
    AddMassForce(i,3) = data0(i,3);
    AddMassForce(i,4) = data0(i,2) * velocityx(i);
    AddMassForce(i,5) = data0(i,3) * velocityy(i);
end
writeforce = [path '\Result\Combination\AddMassForce.dat' ];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"Time\",\"AddMassFx\",\"AddMassFy\",\"AddMassPowerX\",\"AddMassPowerY\"\n');
for k=1:len
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',AddMassForce(k,1),AddMassForce(k,2),AddMassForce(k,3),AddMassForce(k,4),AddMassForce(k,5));
end
fclose(file);
%% VortexForce Combination
VortexForce = zeros(len, 5);
for i=1:len
    [filename1, filename2] = FilenameGet(i);
    readfile1 = [path '\Result\VortexForce\' filename1];
    readfile2 = [path '\Result\VortexForce\' filename2];
    fx = importdata(readfile1).data;
    fy = importdata(readfile2).data;
    VortexForce(i,1) = data0(i,1);
    VortexForce(i,2) = fx;
    VortexForce(i,3) = fy;
    VortexForce(i,4) = fx * velocityx(i);
    VortexForce(i,5) = fy * velocityy(i);
end
writeforce = [path '\Result\Combination\DatVortexForce.dat' ];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"Time\",\"VortexFx\",\"VortexFy\",\"VortexPowerX\",\"VortexPowerY\"\n');
for k=1:len
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',VortexForce(k,1),VortexForce(k,2),VortexForce(k,3),VortexForce(k,4),VortexForce(k,5));
end
fclose(file);
%% VicPreForce Combination
VicPreForce = zeros(len, 5);
for i=1:len
    [filename1, filename2] = FilenameGet(i);
    readfile1 = [path '\Result\VicPreForce\' filename1];
    readfile2 = [path '\Result\VicPreForce\' filename2];
    fx = importdata(readfile1).data;
    fy = importdata(readfile2).data;
    VicPreForce(i,1) = data0(i,1);
    VicPreForce(i,2) = fx/Re;
    VicPreForce(i,3) = fy/Re;
    VicPreForce(i,4) = fx/Re * velocityx(i);
    VicPreForce(i,5) = fy/Re * velocityy(i);
end
writeforce = [path '\Result\Combination\DatVicPreForce.dat' ];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"Time\",\"VicPreFx\",\"VicPreFy\",\"VicPrePowerX\",\"VicPrePowerY\"\n');
for k=1:len
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',VicPreForce(k,1),VicPreForce(k,2),VicPreForce(k,3),VicPreForce(k,4),VicPreForce(k,5));
end
fclose(file);
%% VicousForce Combination
VicousForce = zeros(len, 5);
for i=1:len
    [filename1, filename2] = FilenameGet(i);
    readfile1 = [path '\Result\VicousForce\' filename1];
    readfile2 = [path '\Result\VicousForce\' filename2];
    fx = importdata(readfile1).data;
    fy = importdata(readfile2).data;
    VicousForce(i,1) = data0(i,1);
    VicousForce(i,2) = fx/Re;
    VicousForce(i,3) = fy/Re;
    VicousForce(i,4) = fx/Re * velocityx(i);
    VicousForce(i,5) = fy/Re * velocityy(i);
end
writeforce = [path '\Result\Combination\DatVicousForce.dat' ];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"Time\",\"VicousFx\",\"VicousFy\",\"VicousPowerX\",\"VicousPowerY\"\n');
for k=1:len
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',VicousForce(k,1),VicousForce(k,2),VicousForce(k,3),VicousForce(k,4),VicousForce(k,5));
end
fclose(file);
%% Force Addition
maindir1 = [path '\Result\Combination\DatVortexForce.dat'];
data1 = importdata(maindir1).data;
maindir2 = [path '\Result\Combination\DatVicPreForce.dat'];
data2 = importdata(maindir2).data;
maindir3 = [path '\Result\Combination\DatVicousForce.dat'];
data3 = importdata(maindir3).data;
Force = zeros(len, 5);
for k=1:size(data3,1)
   Force(k,1) = data0(k,1);
   Force(k,2) = data1(k,2)+data2(k,2)+data3(k,2)+data0(k,2);
   Force(k,3) = data1(k,3)+data2(k,3)+data3(k,3)+data0(k,3);
   Force(k,4) = data1(k,4)+data2(k,4)+data3(k,4)+AddMassForce(k,4);
   Force(k,5) = data1(k,5)+data2(k,5)+data3(k,5)+AddMassForce(k,5);
end
writeforce = [path '\Result\Combination\ResultantForce.dat' ];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"Time\",\"ForceX\",\"ForceY\",\"PowerX\",\"PowerY\"\n');
for k=1:size(data1,1)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',Force(k,1),Force(k,2),Force(k,3),Force(k,4),Force(k,5));
end
fclose all;
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