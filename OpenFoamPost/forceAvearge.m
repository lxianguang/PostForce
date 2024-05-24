clear;clc;close all
%% Parameters
fileName  = ['AoA15Alpha00F1.00-v';'AoA15Alpha02F1.00-v';'AoA15Alpha04F1.00-v';'AoA15Alpha06F1.00-v';'AoA15Alpha08F1.00-v'];
filePath  = 'G:\OpenFOAM-v2306\dynamicMesh\infiniteMovingWing\CaseAoA15PitchingRe2000\';
fileNum   = size(fileName,1);
forceRef  = 0.5 * 1000 * 5;   % F_ref = 0.5 * rho * Sref
beginTime = 5.0;              % the start time for average
%% Averaging
meanDrag  = zeros(fileNum,3);
meanLift  = zeros(fileNum,3);
for i=1:fileNum
    forceData = importdata([filePath fileName(i,:) '\postProcessing\forcesWing\0\force.dat']).data;
    forceTime = forceData(:,1);

    % get last five period
    for n = 2:size(forceData,1)
        if(forceTime(n-1)<=beginTime && forceTime(n)>beginTime)
            beginLen = n - 1;
        end
    end
    %  total force, pressure force, viscous force
    forceDrag = [forceData(:,2) forceData(:,5) forceData(:,8)]/forceRef;
    forceLift = [forceData(:,3) forceData(:,6) forceData(:,9)]/forceRef; 
    for j=beginLen:size(forceData,1)-1
        meanDrag(i,:) = meanDrag(i,:) + 0.5*(forceTime(j+1) - forceTime(j-1))*forceDrag(j,:);
        meanLift(i,:) = meanLift(i,:) + 0.5*(forceTime(j+1) - forceTime(j-1))*forceLift(j,:);
    end
    meanDrag(i,:)  = meanDrag(i,:)/(forceTime(end-1) - forceTime(beginLen));
    meanLift(i,:)  = meanLift(i,:)/(forceTime(end-1) - forceTime(beginLen));
end
%% Write Data
%  drag
filename = [filePath 'PostProcessing\averageDrag-v.dat'];
file     = fopen(filename,'w');
fprintf(file,'VARIABLES="AoA","f_t","f_p","f_v"\n');
for i=1:fileNum
    fprintf(file,'%6f    %6f    %6f    %6f\n',str2num(fileName(i,11:12)),meanDrag(i,1),meanDrag(i,2),meanDrag(i,3));
end
%  lift
filename = [filePath 'PostProcessing\averageLift-v.dat'];
file     = fopen(filename,'w');
fprintf(file,'VARIABLES="AoA","f_t","f_p","f_v"\n');
for i=1:fileNum
    fprintf(file,'%6f    %6f    %6f    %6f\n',str2num(fileName(i,11:12)),meanLift(i,1),meanLift(i,2),meanLift(i,3));
end
fclose all;