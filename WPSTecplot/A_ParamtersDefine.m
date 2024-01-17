clc
clear
close all
%% Resultant force decomposition by WPS theory 
%% Set Separator According To Different Systems (windows or linux)
par = judgesystem();    
%% Define File Path
MkdirPath =['F:' par 'DailyWork' par 'Test'];
FileList = ('K5St0.6Al0.2psi270');
% FileList = ['H1.00';'H1.25';'H1.50';'H1.75';'H2.00';'H2.50';'H3.00';'H5.00'];
%% Force Combanation Parameters
Re = 200;        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
bodyType   =  3; % 0 closed body, 1 single plate, 2 two plates clamp
isNearWall =  0; % 0 no, 1 yes
%% Acceleration Information
Amp = [0.25 0.00];
Phi = [-90.0 0.00]/180*pi;
Fre = 0.0025/0.01;
n_aver = 0;  % data averaging times