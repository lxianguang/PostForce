run DefineFilePath.m
%% Calculate Average Forces
creatfolder([MkdirPath par 'AverageFocre']);
Abscissa = FileList(1,1:2);
AverageForceX = zeros(ListLen,7);
AverageForceY = zeros(ListLen,7);
for filenum=1:ListLen
    % read force files
    nFile = [MkdirPath par FileList(filenum,:) 'Continue'];
    ForceX= importdata([nFile par 'ForceX.dat']).data;
    ForceY= importdata([nFile par 'ForceY.dat']).data;
    % other variables
    abscissa = str2double(strrep(FileList(filenum,:),Abscissa,''));
    datalen  = size(ForceX,1)-1;
    % Calculate Average Force in x-direction
    VortexFx       = sum(ForceX(2:end,2))/datalen;
    FrictionFx     = sum(ForceX(2:end,3))/datalen;
    AccelerationFx = sum(ForceX(2:end,4))/datalen;
    VicpressFx     = sum(ForceX(2:end,5))/datalen;
    WPSFx          = sum(ForceX(2:end,6))/datalen;
    NektarFx       = sum(ForceX(2:end,7))/datalen;
    % Calculate Average Force in y-direction
    VortexFy       = sum(ForceY(2:end,2))/datalen;
    FrictionFy     = sum(ForceY(2:end,3))/datalen;
    AccelerationFy = sum(ForceY(2:end,4))/datalen;
    VicpressFy     = sum(ForceY(2:end,5))/datalen;
    WPSFy          = sum(ForceY(2:end,6))/datalen;
    NektarFy       = sum(ForceY(2:end,7))/datalen;
    % Record Data
    AverageForceX(filenum,:) = [abscissa VortexFx FrictionFx AccelerationFx VicpressFx WPSFx NektarFx];
    AverageForceY(filenum,:) = [abscissa VortexFy FrictionFy AccelerationFy VicpressFy WPSFy NektarFy];
    fprintf('%s Force Averaging Ready ===========================================\n',FileList(filenum,:));
end
%% Write Force Data
writeforce = [MkdirPath par 'AverageFocre' par 'ForceX.dat'];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"%s\",\"Vortex\",\"Friction\",\"Acceleration\",\"Vicpress\",\"WPS\",\"Nektar\"\n',Abscissa);
for i=1:ListLen
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',AverageForceX(i,1),AverageForceX(i,2),AverageForceX(i,3),AverageForceX(i,4),AverageForceX(i,5),AverageForceX(i,6),AverageForceX(i,7));
end
fclose(file);
writeforce = [MkdirPath par 'AverageFocre' par 'ForceY.dat'];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"%s\",\"Vortex\",\"Friction\",\"Acceleration\",\"Vicpress\",\"WPS\",\"Nektar\"\n',Abscissa);
for i=1:ListLen
    fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',AverageForceY(i,1),AverageForceY(i,2),AverageForceY(i,3),AverageForceY(i,4),AverageForceY(i,5),AverageForceY(i,6),AverageForceY(i,7));
end
fclose(file);
copyfile(['.' par 'Scripts' par 'ForcePlot.lay'],[MkdirPath par 'AverageFocre' par 'ForcePlot.lay']);
fclose all;