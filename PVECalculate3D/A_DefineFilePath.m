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
CopyPath  = ['G:' par 'DataFile' par 'FishNearWall3D' par 'PostData'      par 'Re100A0.25R2.00K2.00H4.50S'];
PastePath = ['G:' par 'DataFile' par 'FishNearWall3D' par 'PVCECalculate' par 'Re100A0.25R2.00K2.00H4.50S'];
% FileList  = ['K1.00';'K1.50';'K2.00';'K2.50';'K3.00';'K4.00';'K5.00';'K8.00';'K15.0'];
FileList  = ['S0.00';'S0.20';'S0.40';'S0.60';'S0.80';'S1.00';'S1.20'];
% FileList  = ['H1.00';'H1.25';'H1.50';'H1.75';'H2.00';'H2.50';'H3.00';'H4.00';'H5.00';'H10.0'];
%% Data Averaging Paremeters
n_aver    = [1 1 3 1];  % data averaging times for velocity, power,  force, stress energy
num       = '01';   % the number of the soild
%% Force Averaging Parameters
Period1   = 7.8;
Period2   = 9.8;
Periodcon = pi/2;
Period    = Periodcon * ones(1,size(FileList,1)) * 1.0;
% Period = Periodcon * [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.8, 2.0, 2.2, 2.4, 2.6, 2.8, 3.0];
fprintf('Path And Parameter Set!\n');
fprintf('*******************************************************************\n');