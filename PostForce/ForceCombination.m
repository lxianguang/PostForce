clc;
close all;
clear;
%% Parameters
t0 = 31.46509;
dt = 0.04901;
Re = 100;
path = 'G:\Data\ShearPlate\Force\Re100A0.50Rho1.00S0.00K3.50_1';
subdir=dir([path '\ResultForce\VortexForce']);
len = size(subdir,1)/2-1;
%% VortexForce Combination
VortexForce = zeros(len, 3);
for i=1:len
    [filename1, filename2] = FilenameGet(i);
    readfile1 = [path '\ResultForce\VortexForce\' filename1];
    readfile2 = [path '\ResultForce\VortexForce\' filename2];
    fx = importdata(readfile1).data;
    fy = importdata(readfile2).data;
    VortexForce(i,1) = t0 + dt * (i - 1);
    VortexForce(i,2) = fx;
    VortexForce(i,3) = fy;
end
writeforce = [path '\ResultForce\Combination\DatVortexForce.dat' ];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"Time\",\"VortexFx\",\"VortexFy\"\n');
for k=1:len
    fprintf(file,'%.6f    %.6f    %.6f\n',VortexForce(k,1),VortexForce(k,2),VortexForce(k,3));
end
fclose(file);
%% VicPreForce Combination
VicPreForce = zeros(len, 3);
for i=1:len
    [filename1, filename2] = FilenameGet(i);
    readfile1 = [path '\ResultForce\VicPreForce\' filename1];
    readfile2 = [path '\ResultForce\VicPreForce\' filename2];
    fx = importdata(readfile1).data;
    fy = importdata(readfile2).data;
    VicPreForce(i,1) = t0 + dt * (i - 1);
    VicPreForce(i,2) = fx/Re;
    VicPreForce(i,3) = fy/Re;
end
writeforce = [path '\ResultForce\Combination\DatVicPreForce.dat' ];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"Time\",\"VicPreFx\",\"VicPreFy\"\n');
for k=1:len
    fprintf(file,'%.6f    %.6f    %.6f\n',VicPreForce(k,1),VicPreForce(k,2),VicPreForce(k,3));
end
fclose(file);
%% VicousForce Combination
VicousForce = zeros(len, 3);
for i=1:len
    [filename1, filename2] = FilenameGet(i);
    readfile1 = [path '\ResultForce\VicousForce\' filename1];
    readfile2 = [path '\ResultForce\VicousForce\' filename2];
    fx = importdata(readfile1).data;
    fy = importdata(readfile2).data;
    VicousForce(i,1) = t0 + dt * (i - 1);
    VicousForce(i,2) = fx/Re;
    VicousForce(i,3) = fy/Re;
end
writeforce = [path '\ResultForce\Combination\DatVicousForce.dat' ];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"Time\",\"VicousFx\",\"VicousFy\"\n');
for k=1:len
    fprintf(file,'%.6f    %.6f    %.6f\n',VicousForce(k,1),VicousForce(k,2),VicousForce(k,3));
end
fclose(file);
%% Force Addition
maindir1 = [path '\ResultForce\Combination\DatVortexForce.dat'];
data1 = importdata(maindir1).data;
maindir2 = [path '\ResultForce\Combination\DatVicPreForce.dat'];
data2 = importdata(maindir2).data;
maindir3 = [path '\ResultForce\Combination\DatVicousForce.dat'];
data3 = importdata(maindir3).data;
maindir4 = [path '\ResultForce\Combination\AddMassForce.dat'];
data4 = importdata(maindir3).data;
Force = zeros(len, 3);
for k=1:size(data3,1)
   Force(k,1) = data1(k,4);
   Force(k,2) = data1(k,2)+data2(k,2)+data3(k,2)+data4(k,2);
   Force(k,3) = data1(k,3)+data2(k,3)+data3(k,3)+data4(k,3);
end
writeforce = [path '\ResultForce\Combination\DatForce.dat' ];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"Time\",\"ForceX\",\"ForceY\"\n');
for k=1:size(data1,1)
    fprintf(file,'%.6f    %.6f    %.6f\n',Force(k,1),Force(k,2),Force(k,3));
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