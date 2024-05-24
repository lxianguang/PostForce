clear;clc;close all
%% Parameters
filePath = 'data\ProfileX1.20.dat';
%% Read file
fileData = importdata(filePath).data;
%% Regularized output
fileLen  = size(fileData,1);
fileWrite= fopen('data\velocityProfile.dat','w');
fprintf(fileWrite,'{');
for i=1:fileLen-1
    fprintf(fileWrite,'%6f,',fileData(i,1));
    if(mod(i,10)==0)
        fprintf(fileWrite,'\\');
        fprintf(fileWrite,'\n');
    end
end
fprintf(fileWrite,'%6f};',fileData(end,1));
fprintf(fileWrite,'\n\n');
fprintf(fileWrite,'{');
for i=1:fileLen-1
    fprintf(fileWrite,'%6f,',fileData(i,2));
    if(mod(i,10)==0)
        fprintf(fileWrite,'\\');
        fprintf(fileWrite,'\n');
    end
end
fprintf(fileWrite,'%6f};',fileData(end,2));

fclose all;