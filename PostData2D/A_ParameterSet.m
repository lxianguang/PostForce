clear;clc;close all;fclose all;
%% Set Separator According To Different Systems
par = JudgeSystem();
%% Define File Path
CopyPath  = ['G:' par 'NearWallCases' par 'FishNearPlants' par 'SourceData' par 'Part4_2' par 'Re200Kf3.50D0.25H1.00L1.00F0.80Kp'];
PastePath = ['G:' par 'NearWallCases' par 'FishNearPlants' par 'PostData'   par 'Part4_2' par 'Re200Kf3.50D0.25H1.00L1.00F0.80Kp'];
FileList  = ['K1.00';'K2.00';'K3.00';'K4.00';'K5.00';'K6.00'];
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