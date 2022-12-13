clc
clear
%% Calculate The Work Consumed By The Plate Per Unit Distance
%% Parameters
run A_DefineFilePath.m
startPeriod = 9;
endPeriod   = 11;
Period0     = pi/2;
%% Read Data
subdir=dir([PastePath '\Power']);
Period = Period0 * ones(1,size(subdir,1)) * 1.0;
% Period = Period0 * [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.8, 2.0, 2.2, 2.4, 2.6, 2.8, 3.0];
if size(subdir,1)<2 || size(subdir,1)<2
   error('There is no files in the folder')
end
subdir(1:2)         = [];
Abscissa            = subdir(1).name;
Abscissa(end-7:end) = [];
fprintf('Have you change the period length?\n');
%% Defien Variables
name             = zeros(size(subdir,1),1);
costAverage      = zeros(size(subdir,1),1);
powerAvearage    = zeros(size(subdir,1),1);
velocityAvearage = zeros(size(subdir,1),1);
stressEnergy     = zeros(size(subdir,1),1);
%% Calculate 
for i=1:size(subdir,1)
    fprintf('%s\n',FileList(i,:));
    starttime = startPeriod * Period(i);
    endtime   = endPeriod * Period(i);
    % read data 
    name(i)  = str2double(strrep(strrep(subdir(i).name,Abscissa,''),'.dat',''));
    data1    = importdata([PastePath '\Power\' subdir(i).name]).data; 
    data2    = importdata([PastePath '\Velocity\' subdir(i).name]).data; 
    data3    = importdata([PastePath '\Energy\' subdir(i).name]).data; 
    data4    = importdata([PastePath '\Points\' subdir(i).name]).data; 
    power    = data1(:,3);
    velocity = data2(:,4);
    energy   = data3(:,4);
    velpoint = data4(:,5);
    % fix data
%     velpoint(find(abs(velpoint)<0.03)) = 0;
%     velpoint(find(velpoint ~= 0))      = 1;
%     power  = power .* velpoint;
%     energy = energy .* velpoint;
    % get period data
    index1   = find(data1(:,1)<starttime);
    index2   = find(data1(:,1)>endtime);
    startnum = index1(end) + 1;
    endnum   = index2(1) - 1;
    time     = data1(startnum:endnum,1);
    newvel   = velocity(startnum:endnum);
    newpower = power(startnum:endnum);
    newcost  = newpower./newvel;
    newenergy= energy(startnum:endnum);
    % calculate average
    velocityAvearage(i) = abs(sum(newvel)/length(newvel));
    powerAvearage(i)    = abs(sum(newpower)/length(newpower));
    % costAverage(i)      = abs(sum(newcost)/length(newcost));
    costAverage(i)      = powerAvearage(i)/velocityAvearage(i);
    stressEnergy(i)     = abs(sum(newenergy)/length(newenergy));
end
writefile         = [PastePath '\PVCE.dat'];
[name, index]     = sort(name);
costAverage1      = costAverage(index);
powerAvearage1    = powerAvearage(index);
velocityAvearage1 = velocityAvearage(index);
stressEnergy1     = stressEnergy(index);
file=fopen(writefile,'w');
fprintf(file,'VARIABLES=\"%s\",\"P_Avearage\",\"U_Avearage\",\"Efficiency\",\"StressEnergy\"\n',Abscissa);
for i=1:length(name)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',name(i),powerAvearage1(i),velocityAvearage1(i),(1/costAverage1(i)),stressEnergy1(i));
end
fclose all;