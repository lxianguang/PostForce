clear;clc;close all;
%% parameters
for nfile=1:3
    filenumb = num2str(nfile);
    filename = ['precice-Solid-watchpoint-Flap-Tip' filenumb '.log'];
    filepath = 'G:\DealiiPreciceFOAM\ValidationExamples\FlexiblePlateInCrossFlow3D\solid-dealii';
    %% read file
    filedata = importdata([filepath '\' filename]).data;
    filelines= size(filedata,1);
    %% write file
    writename= ['displacement' filenumb '.plt'];
    file=fopen([filepath '\' writename],'w');
    fprintf(file,'VARIABLES="time","x","y","z","dx","dy","dz","fx","fy","fz"\n');
    for i=1:filelines
        fprintf(file,'%10f %10f %10f %10f %10f %10f %10f %10f %10f %10f\n',filedata(i,1:10));
    end
    fclose all;
    fprintf('file: %d write ready\n', nfile);
end