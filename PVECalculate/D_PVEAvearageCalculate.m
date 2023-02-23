clc
clear
%% Calculate The Work Consumed By The Plate Per Unit Distance
run A_DefineFilePath.m
%% Read Data
len = size(FileList,1);
Abscissa = FileList(1,:);
Abscissa(end-3:end)=[];
%% Defien Variables
name         = zeros(len,1);
efficiency   = zeros(len,1);
powerAver    = zeros(len,1);
velocityAver = zeros(len,1);
stressEnergy = zeros(len,1);
forceAver    = zeros(len,1);
%% Calculate 
for i=1:len
    % read data 
    name(i)  = str2double(strrep(FileList(i,:),Abscissa,''));
    ntime    = importdata([PastePath par 'Power'    par FileList(i,:) '.dat']).data(:,1);
    power    = importdata([PastePath par 'Power'    par FileList(i,:) '.dat']).data(:,3); 
    velocity = importdata([PastePath par 'Velocity' par FileList(i,:) '.dat']).data(:,4); 
    energy   = importdata([PastePath par 'Energy'   par FileList(i,:) '.dat']).data(:,4); 
    force    = importdata([PastePath par 'Force'    par FileList(i,:) '.dat']).data(:,2); 
    % extract data 
    index1   = find(ntime < Period1 * Period(i));
    index2   = find(ntime > Period2 * Period(i));
    inum1    = index1(end);
    inum2    = index2(1)-1;
    % fix data
%     velpoint(find(abs(velpoint)<0.03)) = 0;
%     velpoint(find(velpoint ~= 0))      = 1;
%     power  = power .* velpoint;
%     energy = energy .* velpoint;
    % get period data
    newvelocity = velocity (inum1:inum2); 
    newpower    = power    (inum1:inum2);
    newenergy   = energy   (inum1:inum2);
    newforce    = force    (inum1:inum2);
    % calculate average
    kineticEnergy   = 0.5 * sum((abs(newvelocity)+name(i)*2).^2)/length(newpower);
    velocityAver(i) = abs(sum(newvelocity)/length(newpower)) + name(i)*2; % Relative velocity of flow field
    powerAver(i)    = abs(sum(newpower   )/length(newpower)) + kineticEnergy;
    stressEnergy(i) = abs(sum(newenergy  )/length(newpower));
    % efficiency(i)   = velocityAver(i     )/powerAver(i     );
    efficiency(i)   = kineticEnergy/powerAver(i)/Period(i);
    fprintf('%s Force Average Ready =====================================\n',FileList(i,:));
end
fprintf('*******************************************************************\n');
fprintf('Have you change the period length ?????????????????????????????????\n');
[name,index]   = sort(name);
efficiency1    = efficiency  (index);
powerAvearage1 = powerAver   (index);
velAvearage1   = velocityAver(index);
stressEnergy1  = stressEnergy(index);
% write data
writefile      = [PastePath par 'Result' par 'PVCE.dat'];
file=fopen(writefile,'w');
fprintf(file,'VARIABLES=\"%s\",\"P_Avearage\",\"U_Avearage\",\"Efficiency\",\"StressEnergy\"\n',Abscissa);
for i=1:length(name)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',name(i),powerAvearage1(i),velAvearage1(i),efficiency1(i),stressEnergy1(i));
end
fclose all;