clc
clear
%% Calculate The Work Consumed By The Plate Per Unit Distance
%% Parameters
path = 'G:\DataFile\IntervalPlate\PVCECalculate\Re100A0.25K3.50S0.20Wt';
Abscissa = 'Wt';
startPeriod = 14;
endPeriod = 19;
%% Read Data
writefile = [path '\PVCE.dat'];
subdir1=dir([path '\Power']);
subdir2=dir([path '\Velocity']);
if size(subdir1,1)<2 || size(subdir2,1)<2
   error('There is no files in the folder')
end
subdir1(1:2) = [];
subdir2(1:2) = [];
% Period = pi/2 * ones(1,size(subdir1,1)) * 1.7;
Period = pi/2 * [1.0 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0];
name = zeros(size(subdir1,1),1);
costAverage = zeros(size(subdir1,1),1);
powerAvearage = zeros(size(subdir1,1),1);
velocityAvearage = zeros(size(subdir1,1),1);
%% Calculate 
for i=1:size(subdir1,1)
    starttime = startPeriod * Period(i);
    endtime = endPeriod * Period(i);
    % read data 
    name(i) = str2double(strrep(strrep(subdir1(i).name,Abscissa,''),'.dat',''));
    data1 = importdata([path '\Power\' subdir1(i).name]).data; 
    data2 = importdata([path '\Velocity\' subdir2(i).name]).data; 
    power = data1(:,3);
    velocity = data2(:,4);
    % get period data
    index1 = find(data1(:,1)<starttime);
    index2 = find(data1(:,1)>endtime);
    startnum = index1(end) + 1;
    endnum = index2(1) - 1;
    time = data1(startnum:endnum,1);
    newpower = power(startnum:endnum);
    newvelocity = velocity(startnum:endnum);
    newcost = newpower./newvelocity;
    % calculate average
    costAverage(i) = abs(sum(newcost)/length(newcost));
    powerAvearage(i) = abs(sum(newpower)/length(newpower));
    velocityAvearage(i) = abs(sum(newvelocity)/length(newvelocity));
end
[name, index] = sort(name);
costAverage1 = costAverage(index);
powerAvearage1 = powerAvearage(index);
velocityAvearage1 = velocityAvearage(index);
file=fopen(writefile,'w');
fprintf(file,'VARIABLES=\"%s\",\"P_Avearage\",\"U_Avearage\",\"C_Average\",\"Efficiency\"\n',Abscissa);
for i=1:length(name)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',name(i),powerAvearage1(i),velocityAvearage1(i),costAverage1(i),1/costAverage1(i));
end
fclose all;