run A_ParameterSet.m
for nfile=1:size(FileList,1)
    subdir    = dir([CopyPath par FileList(nfile,:) par 'DatInfo']);
    filenum   = GetFileNumber(subdir,'Energy_');
    energysum = zeros(100000,7);
    energynum = zeros(100000,7);
    for num=2:filenum
        filename = GetFileName('Energy',num);
        filepath = [CopyPath par FileList(nfile,:) par 'DatInfo' par filename];
        lines    = GetFileLines(filepath);
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
        fprintf('File Number(%s):%d\n',FileList(nfile,:),num);
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
end