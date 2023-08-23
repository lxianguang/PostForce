run A_ParameterSet.m
%% parameters
startnum = 15000;
lastnum  = 25000;
average  = zeros(size(FileList,1),4);
for nfile=1:size(FileList,1)
    filepath = [CopyPath par FileList(nfile,:) par 'DatInfo' par 'EnergySum.dat'];
    filedata = importdata(filepath).data;   
    aveargen = sum(filedata(startnum:lastnum,4:6))/(lastnum-startnum+1);
    average(nfile,1)   = str2num(FileList(nfile,2:end));
    average(nfile,2:4) = aveargen;
    fprintf('%s Energy average Ready ====================================\n',FileList(nfile,:));
end
%% write data
CreatFolder([CopyPath par 'Post']);
writefile = [CopyPath par 'Post' par 'EnergyAverage.dat'];
file      = fopen(writefile,'w');
fprintf(file,'VARIABLES=\"K\",\"Es\",\"Ev\",\"Et\"\n');
for i=1:size(FileList,1)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f\n',average(i,1),average(i,2),average(i,3),average(i,4));
end
fclose all;