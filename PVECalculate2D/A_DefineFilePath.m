clc
clear
close all
%% Set Separator According To Different Systems
if ispc
    par = '\';
else
    par = '/';
end
%% Define File Path
CopyPath  = ['G:' par 'DataFile' par 'FishNearWall2D' par 'PostData'      par 'Re100A0.50K3.50H2.00S'];
PastePath = ['G:' par 'DataFile' par 'FishNearWall2D' par 'PVCECalculate' par 'Re100A0.50K3.50H2.00S'];
% FileList  = ['K1.00';'K1.50';'K2.00';'K2.50';'K3.00';'K3.50';'K4.00';'K5.00';'K6.00';'K8.00';'K10.0';'K20.0';'K30.0';'K40.0';'K50.0'];
FileList  = ['S0.00';'S0.10';'S0.20';'S0.30';'S0.40';'S0.50';'S0.60';'S0.70';'S0.80';'S0.90';'S1.00'];
% FileList  = ['H1.00';'H1.25';'H1.50';'H1.75';'H2.00';'H2.50';'H3.00';'H4.00';'H5.00';'H6.00';'H7.00';'H8.00';'H9.00';'H10.0'];
% FileList  = ['A0.150';'A0.175';'A0.200';'A0.225';'A0.250';'A0.275';'A0.300';'A0.325';'A0.350'];
%% Data Averaging Paremeters
n_aver    = [1 1 1 1];
num       = '01';   % the number of the soild
%% Force Averaging Parameters
Period1   = 13.50;
Period2   = 14.50;
Periodcon = pi/2;
Period    = Periodcon * ones(1,size(FileList,1)) * 1.0;
% Period = Periodcon * [0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4];
fprintf('Path And Parameter Set!\n');
fprintf('*******************************************************************\n');