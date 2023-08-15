clc
clear
run A_DefineFilePath.m
%% parameters
for nfile=1:size(FileList,1)
    lines     = GetFileLines([CopyPath par FileList(nfile,:) par 'DatInfo' par 'Energy_0002.plt']);
    energysum = zeros(lines-1,7);
    energynum = zeros(lines-1,7);
    subdir    = dir([CopyPath par FileList(nfile,:) par 'DatInfo']);
    filenum   = size(subdir,1)-6;
    for num=2:filenum
        filename = getname(num);
        filepath = [CopyPath par FileList(nfile,:) par 'DatInfo' par filename];
        file     = fopen(filepath);
        str      = fgetl(file);
        for line = 1:lines-1
            str  = fgetl(file);
            energynum(line,:) = str2num(str);
        end
        fclose(file);
        error = find(energynum<=-100);
        energynum(error) = 0.0;
        energysum(:,2:7) = energysum(:,2:7) + energynum(:,2:7);
        fprintf('File Number:%d\n',num);
    end
    %energysum(:,2:7) = energysum(:,2:7)/(filenum - 1);
    energysum(:,1)   = energysum(:,1) + energynum(:,1);
    fprintf('%s Energy sum Ready ========================================\n',FileList(nfile,:));
    %% write data
    writefile = [CopyPath par FileList(nfile,:) par 'DatInfo' par 'EnergySum.dat'];
    file      = fopen(writefile,'w');
    fprintf(file,'VARIABLES=\"t\",\"Ex\",\"Ey\",\"Es\",\"Ev\",\"Et\"\n');
    for i=1:lines-1
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',energysum(i,1),energysum(i,2),energysum(i,3),energysum(i,4),energysum(i,5),energysum(i,7));
    end
    fclose all;
    %% plot 
    plot(energysum(:,1),energysum(:,4))
end
%% function
function [filename] = getname(n)
if n<10
    filename = ['Energy_000' num2str(n) '.plt'];
elseif n<100
    filename = ['Energy_00'  num2str(n) '.plt'];
else
    filename = ['Energy_0'   num2str(n) '.plt'];
end
end