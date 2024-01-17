clear;clc;close all
%% Define File Path
MkdirPath ='G:\OpenFOAMTutorials\Validations\PitchingAirfoil';
FileList = ['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12';'13'];
Ct = zeros(1,size(FileList,1));
for i=1:size(FileList,1)
    fileRead = [MkdirPath '\NACA0012-Re12000-K' FileList(i,:) '\postProcessing\forceCoeffs\0\coefficient.dat'];
    dataRead = importdata(fileRead).data;
    dataLen  = floor(size(dataRead,1)/2);
    thrust   = dataRead(dataLen:end,2);
    % average thrust
    Ct(i) = -sum(thrust)/length(thrust);
end
%% write Ct
writename= 'presentNACA0012.plt';
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