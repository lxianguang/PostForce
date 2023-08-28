run A_ParameterSet.m
outputnum = 1000;
for nfile=1:size(FileList,1)
    filepath  = [CopyPath par FileList(nfile,:) par 'DatInfo'];
    subdir    = dir(filepath);
    filenum   = GetFileNumber(subdir,'Energy_');
    energysum = zeros(filenum-1,outputnum+1);
    energynum = zeros(100000,7); 
    for num=2:filenum
        filename = GetFileName('Energy',num);
        lines    = GetFileLines([filepath par filename]);
        file     = fopen([filepath par filename]);
        str      = fgetl(file);
        for line = 1:lines-1
            str  = fgetl(file);
            energynum(line,:) = str2num(str);
        end
        fclose(file);
        error = find(energynum<=-100);
        energynum(error) = 0.0;
        orderset = -(num-filenum-1);
        outputstep = fix((lines-1)/outputnum);
        energysum(orderset,1) = orderset;
        for n=2:outputnum+1
            energysum(orderset,n) = energynum(n*outputstep,7);
        end
        fprintf('File Number(%s):%d\n',FileList(nfile,:),num);
    end
    fprintf('%s Energy arrange Ready ====================================\n',FileList(nfile,:));
    %% write data
    CreatFolder([filepath par 'EnergyArrange']);
    % write average files
    writefile = [filepath par 'EnergyArrange' par 'EnergyArrange.dat'];
    file      = fopen(writefile,'w');
    fprintf(file,'VARIABLES=\"n\",\"Et\"\n');
    for i=1:filenum-1
        fprintf(file,'%.6f    %.6f\n',energysum(i,1),sum(energysum(i,2:end))/outputnum);
    end
    fclose all;
    % write instantaneous files
    for n=2:outputnum+1
        writename = GetFileName('EnergyArrange',n-1);
        writefile = [filepath par 'EnergyArrange' par writename];
        file      = fopen(writefile,'w');
        fprintf(file,'VARIABLES=\"n\",\"Et\"\n');
        for i=1:filenum-1
            fprintf(file,'%.6f    %.6f\n',energysum(i,1),energysum(i,n));
        end
        fclose all;
    end
end
%% plot 
%plot(energysum(:,1),energysum(:,2))