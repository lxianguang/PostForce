clear;clc;close all;
%% parameters
for nfile=0:2
    filenumb = num2str(nfile);
    filename = ['precice-Solid-watchpoint-Flap-Tip' filenumb '.log'];
    filepath = 'G:\DealiiPreciceFOAM\Turek-Hron-FSI3-3D1\solid-dealii';
    %% read file
    filedata = importdata([filepath '\' filename]).data;
    filelines= size(filedata,1);
    %% write file
    writename= ['point' filenumb '.plt'];
    file=fopen([filepath '\' writename],'w');
    fprintf(file,'VARIABLES="time","x","y","dx","dy","fx","fy"\n');
    for i=1:filelines
        fprintf(file,'%10f %10f %10f %10f %10f %10f %10f\n',filedata(i,:));
    end
    fclose all;
    fprintf('file: %d write ready\n', nfile);
end