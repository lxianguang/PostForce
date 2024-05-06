clear;clc;close all;fclose all;
%% Set Separator According To Different Systems
par = JudgeSystem();
%% Define File Path
CopyPath  = ['G:' par 'NearWallCases' par 'FishNearPlants2D' par 'SourceData' par 'Part3_1' par 'Re200Kf3.50D0.25H1.00L1.00Kp3.00F'];
PastePath = ['G:' par 'NearWallCases' par 'FishNearPlants2D' par 'PostData'   par 'Part3_1' par 'Re200Kf3.50D0.25H1.00L1.00Kp3.00F'];
FileList  = ['F0.80'];
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