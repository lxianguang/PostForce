clear;clc;close all
%% Parameters
fileName  = ['St0.25';'St0.50';'St0.75';'St1.00';'St1.25'];
filePath  = 'G:\OpenFOAM-v2306\dynamicMesh\infiniteWingMotion\Heaving3D\H0.00\Re2000L1.00A2.00-n\';
fileNum   = size(fileName,1);
forceRef  = 0.5 * 1000 * 6;   % F_ref = 0.5 * rho * Sref
%% Averaging
meanDrag  = zeros(fileNum,3);
meanLift  = zeros(fileNum,3);
for i=1:fileNum
    forceData = importdata([filePath fileName(i,:) '\postProcessing\forcesWing\0\force.dat']).data;
    forceLen  = floor(size(forceData,1)/2);
    forceTime = forceData(:,1);
    %  total force, pressure force, viscous force
    forceDrag = [forceData(:,2) forceData(:,5) forceData(:,8)]/forceRef;
    forceLift = [forceData(:,3) forceData(:,6) forceData(:,9)]/forceRef; 
    for j=forceLen:size(forceData,1)-1
        meanDrag(i,:) = meanDrag(i,:) + 0.5*(forceTime(j+1) - forceTime(j-1))*forceDrag(j,:);
        meanLift(i,:) = meanLift(i,:) + 0.5*(forceTime(j+1) - forceTime(j-1))*forceLift(j,:);
    end
    meanDrag(i,:)  = meanDrag(i,:)/(forceTime(end-1) - forceTime(forceLen));
    meanLift(i,:)  = meanLift(i,:)/(forceTime(end-1) - forceTime(forceLen));
end
%% Write Data
%  drag
filename = [filePath 'dataPosting\averageDrag.dat'];
file     = fopen(filename,'w');
fprintf(file,'VARIABLES="St_c","f_t","f_p","f_v"\n');
for i=1:fileNum
    fprintf(file,'%6f    %6f    %6f    %6f\n',str2num(fileName(i,end-3:end)),meanDrag(i,1),meanDrag(i,2),meanDrag(i,3));
end
%  lift
filename = [filePath 'dataPosting\averageLift.dat'];
file     = fopen(filename,'w');
fprintf(file,'VARIABLES="St_c","f_t","f_p","f_v"\n');
for i=1:fileNum
    fprintf(file,'%6f    %6f    %6f    %6f\n',str2num(fileName(i,end-3:end)),meanLift(i,1),meanLift(i,2),meanLift(i,3));
end
fclose all;