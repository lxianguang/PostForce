clear;clc;close all
%% Define File Path
MkdirPath ='G:\OpenFOAMTutorials\wingMotion_blockMesh\Validations\PitchingAirfoil';
FileList = ['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12';'13'];
Ct = zeros(1,size(FileList,1));
for i=1:size(FileList,1)
    fileRead = [MkdirPath '\NACA0015-Re12000-K' FileList(i,:) '\postProcessing\forceCoeffs\0\coefficient.dat'];
    dataRead = importdata(fileRead).data;
    dataLen  = floor(size(dataRead,1)/2);
    thrust   = dataRead(dataLen:end,2);
    time     = dataRead(dataLen:end,1);
    % average thrust
    for k=1:length(thrust)-1
        thrustAve = (thrust(k) + thrust(k+1))/2;
        dealtT    = time(k+1) - time(k);
        Ct(i) =  Ct(i) + thrustAve * dealtT;
    end
    Ct(i) = -Ct(i) / (time(end)-time(1));
end
%% write Ct
writename= 'presentNACA0015.plt';
file=fopen([MkdirPath '\ThrustComparsion\' writename],'w');
fprintf(file,'VARIABLES="K","Ct"\n');
for i=1:size(FileList,1)
    fprintf(file,'%10f %10f\n',str2num(FileList(i,:)),Ct(i));
end
fclose all;
%% plot Cd, Cl
figure(1)
plot(str2num(FileList)',Ct,'r*')
xlim([0,14]);ylim([-0.05,0.2]);grid on