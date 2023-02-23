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
CopyPath  = ['G:' par 'DataFile' par 'PlateWallFish' par 'PostData'      par 'Re100A0.50K3.50H0.75S'];
PastePath = ['G:' par 'DataFile' par 'PlateWallFish' par 'PVCECalculate' par 'Re100A0.50K3.50H0.75S'];
% FileList  = ['Wt0.00';'Wt0.10';'Wt0.20';'Wt0.30';'Wt0.40';'Wt0.50';'Wt0.60';'Wt0.80';'Wt1.00';'Wt1.20';'Wt1.40';'Wt1.60';'Wt1.80';'Wt2.00'];
% FileList  = ['WL0.00';'WL0.05';'WL0.10';'WL0.15';'WL0.20';'WL0.25';'WL0.30';'WL0.35';'WL0.40'];
% FileList  = ['K1.00';'K1.50';'K2.00';'K2.50';'K3.00';'K3.50';'K4.00';'K5.00';'K6.00';'K8.00';'K10.0';'K20.0';'K30.0';'K40.0';'K50.0'];
FileList  = ['S0.00';'S0.10';'S0.20';'S0.30';'S0.40';'S0.50';'S0.60';'S0.70';'S0.80';'S0.90';'S1.00'];
% FileList  = ['H0.75';'H1.00';'H1.25';'H1.50';'H1.75';'H2.00';'H2.50';'H3.00';'H5.00';'H10.0'];
%% Data Averaging Paremeters
n_aver    = [1 1 1 1];
%% Force Averaging Parameters
Period1   = 7.6;
Period2   = 9.6;
Periodcon = pi/2;
Period    = Periodcon * ones(1,size(FileList,1)) * 1.0;
% Period = Periodcon * [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.8, 2.0, 2.2, 2.4, 2.6, 2.8, 3.0];
fprintf('Path And Parameter Set!\n');
fprintf('*******************************************************************\n');