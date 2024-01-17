clear;clc;close all;
%% parameters
starttime = 0.00;
endtime   = 20.0;
deltatime = 1e-2;
roundtime = 1.e6;
filename  = 'force.dat';
filepath  = 'G:\DealiiPreciceFOAM\ValidationExamples\FlexiblePlateInCrossFlow3D\fluid-openfoam\postProcessing\forces\0';
%% settings
filelines = (endtime - starttime) / deltatime;
filedata  = importdata([filepath '\' filename]).data;
filewrite = zeros(filelines, 10);
writename = 'force.plt';
line = 1;
%% read file
for i=1:size(filedata,1) - 1
    if (round(filedata(i  ,1)*roundtime) == round(line*deltatime*roundtime)) && ... 
       (round(filedata(i+1,1)*roundtime) ~= round(line*deltatime*roundtime))
        filewrite(line,:) = filedata(i,:);
        line = line + 1;
    end
end
filewrite(end,:) = filedata(end,:);
%% write file
file=fopen([filepath '\' writename],'w');
fprintf(file,'VARIABLES="time","total_x","total_y","total_z","pressure_x","pressure_y","pressure_z","viscous_x","viscous_y","viscous_z"\n');
for i=1:filelines
    fprintf(file,'%10f %10f %10f %10f %10f %10f %10f %10f %10f %10f\n',filewrite(i,:));
end
fclose all;
%% plot data
% plot(filewrite(:,1),filewrite(:,4))