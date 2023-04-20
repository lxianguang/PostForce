clc
clear
%% Calculate The Work Consumed By The Plate Per Unit Distance
run A_DefineFilePath.m
%% Read Data
len = size(FileList,1);
Abscissa = FileList(1,:);
Abscissa(end-3:end)=[];
%% Define Variables
name          = zeros(len,1);
efficiency    = zeros(len,1);
powerAver     = zeros(len,1);
velocityAver1 = zeros(len,1);
velocityAver2 = zeros(len,1);
placementAver1= zeros(len,1);
placementAver2= zeros(len,1);
forceAver     = zeros(len,1);
stressEnergy  = zeros(len,1);
%% Calculate 
for i=1:len
    % read data 
    name(i)  = str2double(strrep(FileList(i,:),Abscissa,''));
    ntime    = importdata([PastePath par 'Power'     par FileList(i,:) '.dat']).data(:,1);
    power    = importdata([PastePath par 'Power'     par FileList(i,:) '.dat']).data(:,3); 
    velocity = importdata([PastePath par 'Velocity'  par FileList(i,:) '.dat']).data(:,4); 
    energy   = importdata([PastePath par 'Energy'    par FileList(i,:) '.dat']).data(:,4); 
    force    = importdata([PastePath par 'Force'     par FileList(i,:) '.dat']).data(:,2); 
    placement= importdata([PastePath par 'Placement' par FileList(i,:) '.dat']).data(:,2); 
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
    newplacement= placement(inum1:inum2);
    % calculate average
    uadd = name(i) * 0.00;
    midlen = floor(length(newvelocity)/2);
    
    newvelocity1     = newvelocity(1:midlen  );
    newvelocity2     = newvelocity(midlen:end);
    velocityAver1(i) = abs(sum(uadd - newvelocity1)/length(newvelocity1)); % Relative velocity of flow field
    velocityAver2(i) = abs(sum(uadd - newvelocity2)/length(newvelocity2));
    
    newplacement1    = newplacement(1:midlen  );
    newplacement2    = newplacement(midlen:end);
    placementAver1(i)= sum(abs(newplacement1))/length(newplacement1);
    placementAver2(i)= sum(abs(newplacement2))/length(newplacement1);
    
    powerAver    (i) = abs(sum(newpower     )/length(newpower));
    stressEnergy (i) = abs(sum(newenergy    )/length(newpower))/(powerAver(i)*Period(i));
    
    kineticEnergy    = sum((uadd - newvelocity).^2)/length(newpower)/2;
    efficiency   (i) = kineticEnergy/(powerAver(i)*Period(i));
%   efficiency  (i) = velocityAver(i   )/powerAver(i     );
    fprintf('%s Force Average Ready =====================================\n',FileList(i,:));
end
fprintf('*******************************************************************\n');
fprintf('Have you change the period length ?????????????????????????????????\n');
[name,index]   = sort(name);
efficiency1    = efficiency    (index);
power1         = powerAver     (index);
velocity1      = velocityAver1 (index);
velocity2      = velocityAver2 (index);
stressEnergy1  = stressEnergy  (index);
yplacement1    = placementAver1(index);
yplacement2    = placementAver2(index);
% write data
writefile      = [PastePath par 'Result' par 'PVCE.dat'];
file=fopen(writefile,'w');
fprintf(file,'VARIABLES=\"%s\",\"P_Avearage\",\"U_Avearage1\",\"U_Avearage2\",\"Efficiency\",\"StressEnergy\",\"yPlacement1\",\"yPlacement2\"\n',Abscissa);
for i=1:length(name)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',name(i),power1(i),velocity1(i),velocity2(i),efficiency1(i),stressEnergy1(i),yplacement1(i),yplacement2(i));
end
fclose all;