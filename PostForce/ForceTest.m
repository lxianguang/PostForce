clc
clear
%% Caculate Parameters
startnum = 1024;
lastnum = 2048;
%% Caculate Average Force
path = 'G:\Data\FlappingPlate\Re100K3.50Rho1.00S0.00';
subdir=dir([path '\DatInfo']);
if size(subdir,1)<2
   error('There is no files in the folder')
end
subdir(1:2) = [];
Fmean = zeros(length(subdir),1);
for i=1:length(subdir)
    lastn = lastnum;
    name = subdir(i).name;
    filename = [path '\DatInfo\' name];
    data = importdata(filename).data;
    Fxall = data(:,2);
    while length(Fxall)<lastn
        lastn = floor((startnum + lastn)/2);
    end
    Fx=Fxall(startnum:lastn);
    Fmean(i) = sum(Fx)/length(Fx);
    fprintf('number:%d    name:%s    lastnumber:%d    Average:%.6f\n',i,strrep(subdir(i).name,'.plt',''),lastn,Fmean(i));
end
%% output data
classify = zeros(size(Fmean));
for i=1:length(Fmean)
   if Fmean(i)>0
      classify(i) = 'T';
   else
      classify(i) = 'R';
   end
end

file=fopen([path '\AverageForce.txt'],'w');
fprintf(file,'VARIABLES=\"name\",\"Fx_mean\",\"umax\"\n');
for i=1:length(Fmean)
    fprintf(file,'%s    %s    %.6f\n',strrep(subdir(i).name,'.plt',''),classify(i),Fmean(i));
end
fclose(file);