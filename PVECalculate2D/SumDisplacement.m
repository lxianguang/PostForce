clc
clear
run A_DefineFilePath.m
%% parameters
for nfile=1:size(FileList,1)
    lines     = getFileLines([CopyPath par FileList(nfile,:) par 'DatInfo' par 'SampBodyNodeEnd_0002.plt']);
    energysum = zeros(lines-1,2);
    energynum = zeros(lines-1,7);
    subdir    = dir([CopyPath par FileList(nfile,:) par 'DatInfo']);
    filenum   = size(subdir,1)-7;
    for num=2:142
        filename = getname(num);
        filepath = [CopyPath par FileList(nfile,:) par 'DatInfo' par filename];
        file     = fopen(filepath);
        str      = fgetl(file);
        for line = 1:lines-1
            str  = fgetl(file);
            energynum(line,:) = str2num(str);
        end
        fclose(file);
        energysum(:,2) = energysum(:,2) + abs(energynum(:,2)-energynum(1,2));
        fprintf('File Number:%d\n',num);
    end
    %energysum(:,2) = energysum(:,2) / (filenum-1);
    energysum(:,1) = energysum(:,1) + energynum(:,1);
    fprintf('%s Energy sum Ready ========================================\n',FileList(nfile,:));
    %% write data
    writefile = [CopyPath par FileList(nfile,:) par 'DatInfo' par 'DisplacementSum.dat'];
    file      = fopen(writefile,'w');
    fprintf(file,'VARIABLES=\"t\",\"dx\"\n');
    for i=1:lines-1
        fprintf(file,'%.6f    %.6f\n',energysum(i,1),energysum(i,2));
    end
    fclose all;
    %% plot 
    plot(energysum(:,1),energysum(:,2))
end
%% function
function [filename] = getname(n)
if n<10
    filename = ['SampBodyNodeEnd_000' num2str(n) '.plt'];
elseif n<100
    filename = ['SampBodyNodeEnd_00'  num2str(n) '.plt'];
else
    filename = ['SampBodyNodeEnd_0'   num2str(n) '.plt'];
end
end