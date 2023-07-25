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
CopyPath  = ['G:' par 'NearWallCases' par 'FishNearPlants' par 'SourceData' par 'Re200Kf3.50D2.00H1.00L1.00Kp3.00F'];
PastePath = ['G:' par 'NearWallCases' par 'FishNearPlants' par 'PostForces' par 'Re200Kf3.50D2.00H1.00L1.00Kp3.00F'];
% FileList  = ['K0.25';'K0.50';'K0.75';'K1.00';'K1.50';'K2.00';'K2.50';'K3.00';'K3.50';'K4.00';'K4.50';'K5.00';'K6.00';'K7.00';'K10.0';'K15.0';'K30.0';'K50.0'];
FileList  = ['F0.40';'F0.50';'F0.60';'F0.70';'F0.80';'F0.90';'F1.00';'F1.10'];
% FileList  = ['D0.50';'D0.75';'D1.00';'D1.25';'D1.50';'D1.75';'D2.00'];
%% Data Averaging Paremeters
n_aver    = [1 1 1 1];   % average times for velocity, power, force, energy
num       = '01';        % the number of the plate
%% Force Averaging Parameters
Period1   = 10.00;
Period2   = 20.00;
Periodcon = 1/1.0;
% Period    = Periodcon * ones(1,size(FileList,1)) * 1.0;
Period = Periodcon ./ [0.4,0.5,0.6, 0.7, 0.8, 0.9, 1.0, 1.1];
fprintf('Path And Parameter Set!\n');
fprintf('*******************************************************************\n');