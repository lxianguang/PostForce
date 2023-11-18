%% Data posting
run A_ParameterSet.m
%% Define Variables
len           = size(FileList,1);
Abscissa      = FileList(1,1);
name          = zeros(len,1);
efficiency    = zeros(len,1);
powerAver     = zeros(len,1);
velocityAver  = zeros(len,1);
forceAver     = zeros(len,1);
stressEnergy  = zeros(len,1);
%% Calculate 
for k=1:len
    %% read data 
    name(k)  = str2double(strrep(FileList(k,:),Abscissa,''));
    ntime    = importdata([PastePath par 'Power'     par FileList(k,:) '.dat']).data(:,1);
    power    = importdata([PastePath par 'Power'     par FileList(k,:) '.dat']).data(:,3); 
    velocity = importdata([PastePath par 'Velocity'  par FileList(k,:) '.dat']).data(:,5); 
    energy   = importdata([PastePath par 'Energy'    par FileList(k,:) '.dat']).data(:,7); 
    force    = importdata([PastePath par 'Force'     par FileList(k,:) '.dat']).data(:,2); 
    %% extract data 
    index1   = find(ntime <= Period1 * Period(k));
    index2   = find(ntime >= Period2 * Period(k));
    inum1    = index1(end);
    inum2    = index2(1)-1;
    %% get period data
    newvelocity = velocity (inum1:inum2); 
    newpower    = power    (inum1:inum2);
    newenergy   = energy   (inum1:inum2);
    newforce    = force    (inum1:inum2);
    %% calculate average data
    velocityAver (k) = abs(sum(newvelocity)/length(newpower));
    powerAver    (k) = abs(sum(newpower   )/length(newpower));
    stressEnergy (k) = abs(sum(newenergy  )/length(newpower));
    efficiency   (k) = velocityAver(k     )/powerAver(k     );
    % kineticEnergy    = sum(newvelocity.^2) /length(newpower)/2;
    % efficiency   (k) = kineticEnergy       /(powerAver(i));
    fprintf('%s Force Average Ready =====================================\n',FileList(k,:));
end
fprintf('*******************************************************************\n');
fprintf('Have you change the period length ?????????????????????????????????\n');
%% sort data
[name,index]   = sort        (name );
efficiency1    = efficiency  (index);
powerAvearage1 = powerAver   (index);
velAvearage1   = velocityAver(index);
stressEnergy1  = stressEnergy(index);
%% write data
writefile      = [PastePath par 'Result' par 'PostData.dat'];
file=fopen(writefile,'w');
fprintf(file,'VARIABLES=\"%s\",\"P_Avearage\",\"U_Avearage\",\"Efficiency\",\"TotalEnergy\"\n',Abscissa);
for k=1:length(name)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f\n',name(k),powerAvearage1(k),velAvearage1(k),efficiency1(k),stressEnergy1(k));
end
fclose all;