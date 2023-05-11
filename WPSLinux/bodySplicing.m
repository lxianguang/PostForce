function [] = bodySplicing(par,FilePath)
%% Splicing For Bodies
    %% Reading Time Data
    subdir      = dir([FilePath par 'DatBody']);
    subdir(1:2) =[];
    bodynum     = length(subdir)/2;
    for i=1:bodynum
        datatime(i,:) = strrep(strrep(subdir(i).name,'.dat',''),'Body001_','');
    end
    %% Reading Body Data
    for i=1:bodynum
        bodyfile1 = [FilePath par 'DatBody' par 'Body001_' datatime(i,:) '.dat'];
        bodyfile2 = [FilePath par 'DatBody' par 'Body002_' datatime(i,:) '.dat'];
        bodydata1 = importdata(bodyfile1).data;
        bodydata2 = importdata(bodyfile2).data;
        numsize   = size(bodydata2,1);
        nbodydata = [bodydata1(numsize:-1:2,:);bodydata2];
        wirtefile = [FilePath par 'DatBodyS' par 'Body' datatime(i,:) '.dat'];
        file=fopen(wirtefile,'w');
        fprintf(file,'variables = x,y,u,v,ax,ay,fxi,fyi,fxr,fyr \n');
        for line=1:size(nbodydata,1)
            fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',nbodydata(line,1),nbodydata(line,2),nbodydata(line,3),nbodydata(line,4),nbodydata(line,5),nbodydata(line,6),nbodydata(line,7),nbodydata(line,8),nbodydata(line,9),nbodydata(line,10));
        end
        fclose all;
    end
    %% Obtaining the combined force of two objects
    forcefile1 = [FilePath par 'DatInfo' par 'ForceDirect_0001.plt'];
    forcefile2 = [FilePath par 'DatInfo' par 'ForceDirect_0002.plt'];
    force1     = importdata(forcefile1).data;
    force2     = importdata(forcefile2).data;
    resultant(:,1)  = force1(:,1);
    resultant(:,2:3)= force1(:,2:3) + force2(:,2:3);
    writeforce = [FilePath par 'DatInfo' par 'ForceDirect.dat'];
    file=fopen(writeforce,'w');
    fprintf(file,' variables= "t"  "fx"  "fy"\n');
    for line=1:size(resultant,1)
        fprintf(file,'%.6f    %.6f    %.6f\n',resultant(line,1),resultant(line,2),resultant(line,3));
    end
    fclose all;
end

