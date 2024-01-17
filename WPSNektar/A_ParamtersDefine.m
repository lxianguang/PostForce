clear;clc;close all
%% Resultant force decomposition by WPS theory 
%% Set Separator According To Different Systems (windows or linux)
par = judgesystem();
%% Define File Path
MkdirPath =['F:' par 'DailyWork' par 'CalculateTest'];
FileList = ('Test');
% FileList = ['D6.00';'D7.00';'D8.00'];
%% Force Combanation Parameters
bodyType   =  1; % 0 closed body, 1 single plate, 2 two plates clamp
isNearWall =  0; % 0 no, 1 yes