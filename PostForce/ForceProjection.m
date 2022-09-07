clc;
close all;
clear;
%% Read filename
path = 'G:\Data\ShearPlate\Force\Cylinder';
subdir=dir([path '\DatBody']);
if size(subdir,1)<2
   error('There is no files in the folder')
end
subdir(1:2) = [];
finalforce = zeros(length(subdir),3);
%% Projection
for num=1:length(subdir)
    filename = subdir(num).name;
    readfile = [path '\DatBody\' filename];
    % Read data
    data0 = importdata(readfile).data;
    data = [data0(:,1) data0(:,2) data0(:,7) data0(:,8)]; % x, y, fx, fy
    z = data(:,1) + 1i*data(:,2);
    % Caculate
    len = size(data,1);
    force = zeros(len,2);
    dz = [z(2:1:len) - z(1:1:len-1);z(len)-z(len-1)];
    dnorm = -1i*dz./abs(dz);
    dvert = dz./abs(dz);
    dtheta = atan(imag(dnorm)./real(dnorm));
    for i=1:len
       force(i,1) = (real(dnorm(i)) * data(i,3) + imag(dnorm(i)) * data(i,4)) * dnorm(i);
       force(i,2) = (real(dvert(i)) * data(i,3) + imag(dvert(i)) * data(i,4)) * dvert(i);
    end
    finalforce(num,1) = str2double(strrep(strrep(filename,'_01.dat',''),'Body',''));
    finalforce(num,2) = sum(force(:,1))/2;
    finalforce(num,3) = sum(force(:,2))/2;
end
%% Write Final Force
writeforce = [path '\ResultForce\' 'Projection.dat'];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"T\",\"VicousFx\",\"VicousFy\",\"PresFx\",\"PresFy\"\n');
for k=1:length(subdir)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',finalforce(k,1),real(finalforce(k,3)),imag(finalforce(k,3)),real(finalforce(k,2)),imag(finalforce(k,2)));
end
fclose all;