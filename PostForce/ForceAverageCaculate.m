clc
clear
%% Calculate The Average Force Of Swimming Plate In Shear Flow
%% Reading Path
path = 'G:\DataFile\ShearPlate\Force\ShearPlate\Re100A0.50S0.00';
Abscissa = 'K';
periodnum = 32;
subdir = dir(path);
subdir(1:2)=[];
forcex = zeros(6,size(subdir,1));
forcey = zeros(6,size(subdir,1));
powerx = zeros(6,size(subdir,1));
powery = zeros(6,size(subdir,1));
deficit = zeros(2,size(subdir,1));
for i=1:size(subdir,1)
    forcex(1,i) = str2double(strrep(subdir(i).name,Abscissa,''));
    forcey(1,i) = forcex(1,i);
    powerx(1,i) = forcex(1,i);
    powery(1,i) = forcex(1,i);
    deficit(1,i) = forcex(1,i);
    % Combinate Path
    addmassF = [path '\' subdir(i).name '\Result\Combination\AddMassForce.dat']; 
    frictionF = [path '\' subdir(i).name '\Result\Combination\DatVicousForce.dat']; 
    vicpreF = [path '\' subdir(i).name '\Result\Combination\DatVicPreForce.dat']; 
    vortexF = [path '\' subdir(i).name '\Result\Combination\DatVortexForce.dat']; 
    resultantF = [path '\' subdir(i).name '\Result\Combination\ResultantForce.dat'];
    deficitF = [path '\' subdir(i).name '\Result\Combination\VelocityDeficit.dat'];
    % Reading Files
    addmass = importdata(addmassF).data;
    friction = importdata(frictionF).data;
    vicpre = importdata(vicpreF).data;
    vortex = importdata(vortexF).data;
    resultant = importdata(resultantF).data;
    vdeficit = importdata(deficitF).data;
    % Calculate Average Force
    num = size(addmass,1);
    resultantA = sum(resultant(end-periodnum+1:end,2:3))/periodnum;
    addmassA = sum(addmass(end-periodnum+1:end,2:3))/periodnum;
    frictionA = sum(friction(end-periodnum+1:end,2:3))/periodnum;
    vicpreA = sum(vicpre(end-periodnum+1:end,2:3))/periodnum;
    vortexA = sum(vortex(end-periodnum+1:end,2:3))/periodnum;
    % Calculate Average Power
    resultantP = sum(resultant(end-periodnum+1:end,4:5))/periodnum;
    addmassP = sum(addmass(end-periodnum+1:end,4:5))/periodnum;
    frictionP = sum(friction(end-periodnum+1:end,4:5))/periodnum;
    vicpreP = sum(vicpre(end-periodnum+1:end,4:5))/periodnum;
    vortexP = sum(vortex(end-periodnum+1:end,4:5))/periodnum;
    % Calculate velocity deficit
    deficitA = sum(vdeficit(end-periodnum+1:end,2))/periodnum;
    % Record Data
    forcex(2:6,i) = [addmassA(1) frictionA(1) vicpreA(1) vortexA(1) resultantA(1)];
    forcey(2:6,i) = [addmassA(2) frictionA(2) vicpreA(2) vortexA(2) resultantA(2)];
    powerx(2:6,i) = [addmassP(1) frictionP(1) vicpreP(1) vortexP(1) resultantP(1)];
    powery(2:6,i) = [addmassP(2) frictionP(2) vicpreP(2) vortexP(2) resultantP(2)];
    deficit(2,i) = deficitA;
end
%% Write Data
% Write Average Force
[~,index] = sort(forcex(1,:));
forcex = forcex(:,index);
forcey = forcey(:,index);
writeforcex = [path '\AverageFx.dat'];
writeforcey = [path '\AverageFy.dat'];
file=fopen(writeforcex,'w');
fprintf(file,'VARIABLES=\"%s\",\"AddmassFx\",\"FrictionFx\",\"VicpreFx\",\"VortexFx\",\"ResultantFx\"\n',Abscissa);
for k=1:size(forcex,2)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',forcex(1,k),forcex(2,k),forcex(3,k),forcex(4,k),forcex(5,k),forcex(6,k));
end
file=fopen(writeforcey,'w');
fprintf(file,'VARIABLES=\"%s\",\"AddmassFy\",\"FrictionFy\",\"VicpreFy\",\"VortexFy\",\"ResultantFy\"\n',Abscissa);
for k=1:size(forcey,2)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',forcey(1,k),forcey(2,k),forcey(3,k),forcey(4,k),forcey(5,k),forcey(6,k));
end
fclose all;
% Write Average Power
powerx = powerx(:,index);
powery = powery(:,index);
power = powerx + powery;
power(1,:) = powerx(1,:);
writepowerx = [path '\AveragePx.dat'];
writepowery = [path '\AveragePy.dat'];
writepower = [path '\AverageP.dat'];
file=fopen(writepowerx,'w');
fprintf(file,'VARIABLES=\"%s\",\"AddmassPx\",\"FrictionPx\",\"VicprePx\",\"VortePx\",\"ResultantPx\"\n',Abscissa);
for k=1:size(powerx,2)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',powerx(1,k),powerx(2,k),powerx(3,k),powerx(4,k),powerx(5,k),powerx(6,k));
end
file=fopen(writepowery,'w');
fprintf(file,'VARIABLES=\"%s\",\"AddmassPy\",\"FrictionPy\",\"VicprePy\",\"VortexPy\",\"ResultantPy\"\n',Abscissa);
for k=1:size(powery,2)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',powery(1,k),powery(2,k),powery(3,k),powery(4,k),powery(5,k),powery(6,k));
end
file=fopen(writepower,'w');
fprintf(file,'VARIABLES=\"%s\",\"AddmassPy\",\"FrictionPy\",\"VicprePy\",\"VortexPy\",\"ResultantPy\"\n',Abscissa);
for k=1:size(powery,2)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',power(1,k),power(2,k),power(3,k),power(4,k),power(5,k),power(6,k));
end
fclose all;
% write velocity deficit
deficit = deficit(:,index);
writedeficit = [path '\AverageDeficit.dat'];
file=fopen(writedeficit,'w');
fprintf(file,'VARIABLES=\"%s\",\"AverageDeficit\"\n',Abscissa);
for k=1:size(deficit,2)
    fprintf(file,'%.6f    %.6f\n',deficit(1,k),deficit(2,k));
end
fclose all;