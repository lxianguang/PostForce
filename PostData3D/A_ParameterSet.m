clear;clc;close all;fclose all;
%% Set Separator According To Different Systems
par = JudgeSystem();
%% Define File Path
CopyPath  = ['G:' par 'NearWallCases' par 'FishNearPlants3D' par 'SourceData' par 'FishAboveThePlants-6.0'];
PastePath = ['G:' par 'NearWallCases' par 'FishNearPlants3D' par 'DataPoster' par 'FishAboveThePlants-6.0'];
FileList  = ['K0.05';'K0.10';'K0.50';'K1.00';'K3.00';'K5.00';'K7.00';'K10.0'];
%% Data Smoothing Paremeters
n_aver    = [1 1 1 1];   % average times for velocity, power, force, energy
num       = '01';        % the number of the plate
%% Force Averaging Parameters
Period1   = 20.00;
Period2   = 25.00;
Periodcon = pi/2 ;
Period    = Periodcon * ones(1,size(FileList,1));
% Period = Periodcon ./ [0.5,0.6, 0.7, 0.8, 0.9, 1.0];
fprintf('Path And Parameter Set!\n');
fprintf('*******************************************************************\n');