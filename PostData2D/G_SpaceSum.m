run A_ParameterSet.m
for nfile=1:size(FileList,1)
    subdir    = dir([CopyPath par FileList(nfile,:) par 'DatInfo']);
    filenum   = GetFileNumber(subdir,'SampBodyNodeEnd_');
    spacesum = zeros(100000,2);
    spacenum = zeros(100000,7);
    for num=2:201
        filename = GetFileName('SampBodyNodeEnd',num);
        filepath = [CopyPath par FileList(nfile,:) par 'DatInfo' par filename];
        lines    = GetFileLines(filepath);
        file     = fopen(filepath);
        str      = fgetl(file);
        for line = 1:lines-1
            str  = fgetl(file);
            spacenum(line,:) = str2num(str);
        end
        fclose(file);
        error = find(spacenum<=-100);
        spacenum(error) = 0.0;
        spacesum(:,2) = spacesum(:,2) + abs(spacenum(:,2)-spacenum(1,2));
        fprintf('File Number(%s):%d\n',FileList(nfile,:),num);
    end
    spacesum(:,1) = spacesum(:,1) + spacenum(:,1);
    fprintf('%s Energy sum Ready ========================================\n',FileList(nfile,:));
    %% write data
    writefile = [CopyPath par FileList(nfile,:) par 'DatInfo' par 'SpaceSum.dat'];
    file      = fopen(writefile,'w');
    fprintf(file,'VARIABLES=\"t\",\"dx\"\n');
    for i=1:lines-1
        fprintf(file,'%.6f    %.6f\n',spacesum(i,1),spacesum(i,2));
    end
    fclose all;
end