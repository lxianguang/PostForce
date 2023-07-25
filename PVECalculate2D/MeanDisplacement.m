clc
clear
run A_DefineFilePath.m
%% parameters
startnum = 10000;
lastnum  = 18985;
average  = zeros(size(FileList,1),1);
for nfile=1:size(FileList,1)
    filepath = [CopyPath par FileList(nfile,:) par 'DatInfo' par 'DisplacementSum.dat'];
    filedata = importdata(filepath).data;   
    aveargen = sum(filedata(startnum:lastnum,2))/(lastnum-startnum+1);
    average(nfile,1) = str2num(FileList(nfile,2:end));
    average(nfile,2) = aveargen;
    %% plot 
    fprintf('%s Displacement average Ready ==============================\n',FileList(nfile,:));
end
%% write data
writefile = [CopyPath par 'Post' par 'DisplacementAverage.dat'];
CreatDir([CopyPath par 'Post']);
file      = fopen(writefile,'w');
fprintf(file,'VARIABLES=\"K\",\"dx\"\n');
for i=1:size(FileList,1)
    fprintf(file,'%.6f    %.6f\n',average(i,1),average(i,2));
end
fclose all;
%% function
function [] = CreatDir(path)
if ~exist(path,'dir')
    mkdir(path);
end
end