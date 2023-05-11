clc
clear
close all
%% Resultant force decomposition by WPS theory In Nektar++
%% Set Separator According To Different Systems
par = judgesystem();
%% Define File Path
MkdirPath = ['G:' par 'DataFile' par 'PitchingAirfoil2D' par 'Re1700St0.10'];
% MkdirPath = [par 'home' par 'xluo' par 'NACA0015' par 'Pitching' par 'Re1700St0.10'];
FileList  = ['AD0.50';'AD0.75';'AD1.00';'AD1.25';'AD1.50';'AD1.75';'AD2.00';'AD2.25';'AD2.50'];
% FileList = ['AD0.50';'AD0.75'];
%% Calculate Parameters
ListLen   = size(FileList,1);
outStep1 = 5 ; % Number of files output in one period
outStep2 = 50; % Number of files output in one period in continue calculation
Re = 1700;
St = 0.10;
AD = 0.50;
np = 12;       % cpu cores
NT = 30;       % Calculated number of periods
%% Other Parameters
MovingType= 0; % 0 pitching, 1 plunging
Thickness = 0.15;
Uinf      = 1.00;
ReList    = Re*ones(ListLen,1);
StList    = St*ones(ListLen,1);
ADList    = AD*ones(ListLen,1);
for filenum=1:ListLen
    if strcmp(FileList(filenum,1:2),'AD')
        ADList(filenum) = str2num(strrep(FileList(filenum,:),'AD',''));
    elseif strcmp(FileList(filenum,1:2),'St')
        StList(filenum) = str2num(strrep(FileList(filenum,:),'St',''));
    elseif strcmp(FileList(filenum,1:2),'Re')
        ReList(filenum) = str2num(strrep(FileList(filenum,:),'Re',''));
    end
end