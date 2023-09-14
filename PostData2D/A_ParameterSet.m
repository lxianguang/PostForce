clear;clc;close all;
%% Set Separator According To Different Systems
par = JudgeSystem();
%% Define File Path
CopyPath  = ['G:' par 'NearWallCases' par 'FishNearPlants' par 'SourceData' par 'Part2_1' par 'Re200Kf3.50D0.50H1.00L1.00F1.00Kp'];
PastePath = ['G:' par 'NearWallCases' par 'FishNearPlants' par 'PostData'   par 'Part2_1' par 'Re200Kf3.50D0.50H1.00L1.00F1.00Kp'];
% FileList = ['K0.50';'K1.00';'K1.50';'K2.00';'K2.50';'K3.00';'K3.50';'K4.00';'K5.00';'K6.00';'K8.00';'K10.0'];
% FileList = ['K0.25';'K0.50';'K0.75';'K1.00';'K1.50';'K2.00';'K2.50';'K3.00';'K3.50';'K4.00';'K4.50';'K5.00';'K6.00';'K7.00';'K10.0';'K15.0';'K30.0';'K50.0'];
FileList = ['H1.00';'H1.25';'H1.50';'H1.75';'H2.00';'H2.50';'H3.00';'H4.00';'H6.00';'H10.0'];
% FileList = ['F0.50';'F0.60';'F0.70';'F0.80';'F0.90';'F1.00'];
%% Data Smoothing Paremeters
n_aver    = [1 1 1 1];   % average times for velocity, power, force, energy
num       = '01';        % the number of the plate
%% Force Averaging Parameters
Period1   = 15.00;
Period2   = 20.00;
Periodcon = 1/1.0;
Period    = Periodcon * ones(1,size(FileList,1));
% Period = Periodcon ./ [0.5,0.6, 0.7, 0.8, 0.9, 1.0];
fprintf('Path And Parameter Set!\n');
fprintf('*******************************************************************\n');