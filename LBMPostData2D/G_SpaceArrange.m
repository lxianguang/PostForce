run A_ParameterSet.m
outputnum = 1000;
for nfile=1:size(FileList,1)
    filepath  = [CopyPath par FileList(nfile,:) par 'DatInfo'];
    subdir    = dir(filepath);
    filenum   = GetFileNumber(subdir,'SampBodyNodeEnd_');
    displacementsum = zeros(filenum-1,outputnum+1);
    displacementnum = zeros(100000,7);
    for num=2:filenum
        filename = GetFileName('SampBodyNodeEnd',num);
        lines    = GetFileLines([filepath par filename]);
        file     = fopen([filepath par filename]);
        str      = fgetl(file);
        for line = 1:lines-1
            str  = fgetl(file);
            displacementnum(line,:) = str2num(str);
        end
        fclose(file);
        orderset = -(num-filenum-1);
        outputstep = fix((lines-1)/outputnum);
        displacementsum(orderset,1) = orderset;
        for n=2:outputnum+1
            %displacementsum(orderset,n) = abs(displacementnum((n-2)*outputstep+1,2)-displacementnum(1,2));
            displacementsum(orderset,n) = displacementnum((n-2)*outputstep+1,2)-displacementnum(1,2);
        end
        fprintf('File Number(%s):%d\n',FileList(nfile,:),num);
    end
    fprintf('%s Displacement arrange Ready ==============================\n',FileList(nfile,:));
    %% write data
    CreatFolder([filepath par 'Displacement']);
    % write average files
    writefile = [filepath par 'Displacement' par 'Displacement.dat'];
    file      = fopen(writefile,'w');
    fprintf(file,'VARIABLES=\"n\",\"dx\"\n');
    for i=1:filenum-1
        fprintf(file,'%.6f    %.6f\n',displacementsum(i,1),sum(displacementsum(i,2:end))/outputnum);
    end
    fclose all;
    % write instantaneous files
    for n=2:outputnum+1
        writename = GetFileName('Displacement',n-1);
        writefile = [filepath par 'Displacement' par writename];
        file      = fopen(writefile,'w');
        fprintf(file,'VARIABLES=\"n\",\"dx\"\n');
        for i=1:filenum-1
            fprintf(file,'%.6f    %.6f\n',displacementsum(i,1),displacementsum(i,n));
        end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
        fclose all;
    end
end