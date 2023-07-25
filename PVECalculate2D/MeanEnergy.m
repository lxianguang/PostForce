clc
clear
run A_DefineFilePath.m
%% parameters
startnum = 10000;
lastnum  = 20000;
average  = zeros(size(FileList,1),4);
for nfile=1:size(FileList,1)
    filepath = [CopyPath par FileList(nfile,:) par 'DatInfo' par 'EnergySum.dat'];
    filedata = importdata(filepath).data;   
    aveargen = sum(filedata(startnum:lastnum,4:6))/(lastnum-startnum+1);
    average(nfile,1) = str2num(FileList(nfile,2:end));
    average(nfile,2:4) = aveargen;
    %% plot 
    fprintf('%s Energy average Ready ====================================\n',FileList(nfile,:));
end
%% write data
writefile = [CopyPath par 'Post' par 'EnergyAverage.dat'];
CreatDir([CopyPath par 'Post']);
file      = fopen(writefile,'w');
fprintf(file,'VARIABLES=\"K\",\"Es\",\"Ev\",\"Et\"\n');
for i=1:size(FileList,1)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f\n',average(i,1),average(i,2),average(i,3),average(i,4));
end
fclose all;
%% function
function [] = CreatDir(path)
if ~exist(path,'dir')
    mkdir(path);
end
end