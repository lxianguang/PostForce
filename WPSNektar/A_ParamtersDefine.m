clear;clc;close all
%% Resultant force decomposition by WPS theory 
%% Set Separator According To Different Systems (windows or linux)
par = judgesystem();
%% Define Case Path
casePath   = 'F:\StudyFiles\DataTools\PostProcessing\LBMPostData2DCase\Test';
%% Force Combanation Parameters
bodyType   =  1; % 0 closed body, 1 single plate, 2 two plates clamp
isNearWall =  0; % 0 no, 1 yes
