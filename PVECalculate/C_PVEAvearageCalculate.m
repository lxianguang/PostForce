clc
clear
%% Calculate The Work Consumed By The Plate Per Unit Distance
run B_CopyPowerAndVelocityFile.m
%% Read Data
len = size(FileList,1);
Abscissa = FileList(1,:);
% Abscissa(end-3:end)=[];
Abscissa(end)=[];
%% Defien Variables
name             = zeros(len,1);
costAverage      = zeros(len,1);
powerAvearage    = zeros(len,1);
velocityAvearage = zeros(len,1);
stressEnergy     = zeros(len,1);
%% Calculate 
for i=1:len
    starttime = startPeriod * Period(i);
    endtime   = endPeriod   * Period(i);
    % read data 
    name(i)  = str2double(strrep(FileList(i,:),Abscissa,''));
    data1    = importdata([PastePath par 'Power'    par FileList(i,:) '.dat']).data; 
    data2    = importdata([PastePath par 'Velocity' par FileList(i,:) '.dat']).data; 
    data3    = importdata([PastePath par 'Energy'   par FileList(i,:) '.dat']).data; 
    data4    = importdata([PastePath par 'Points'   par FileList(i,:) '.dat']).data; 
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
    index2   = find(data1(:,1)>endtime  );
    startnum = index1(end) + 1;
    endnum   = index2(1)   - 1;
    time     = data1 (startnum:endnum,1);
    newvel   = velocity(startnum:endnum);
    newpower = power   (startnum:endnum);
    newenergy= energy  (startnum:endnum);
    % calculate average
    velocityAvearage(i) = abs(sum(newvel)   /length(newvel)   );
    powerAvearage(i)    = abs(sum(newpower) /length(newpower) );
    stressEnergy(i)     = abs(sum(newenergy)/length(newenergy));
    costAverage(i)      = powerAvearage(i)  /velocityAvearage(i);
    
    fprintf('%s Force Average Ready =====================================\n',FileList(i,:));
end
fprintf('*******************************************************************\n');
fprintf('Have you change the period length ?????????????????????????????????\n');
[name,index]   = sort(name);
writefile      = [PastePath par 'Result' par 'PVCE.dat'];
costAverage1   = costAverage     (index);
powerAvearage1 = powerAvearage   (index);
velAvearage1   = velocityAvearage(index);
stressEnergy1  = stressEnergy    (index);
file=fopen(writefile,'w');
fprintf(file,'VARIABLES=\"%s\",\"P_Avearage\",\"U_Avearage\",\"Efficiency\",\"StressEnergy\"\n',Abscissa);
for i=1:length(name)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',name(i),powerAvearage1(i),velAvearage1(i),(1/costAverage1(i)),stressEnergy1(i));
end
fclose all;