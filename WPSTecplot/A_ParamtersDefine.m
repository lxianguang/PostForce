clc
clear
close all
%% Resultant force decomposition by WPS theory 
%% Set Separator According To Different Systems
par = judgesystem();
%% Define File Path
% MkdirPath = [par 'home' par 'data' par 'xluo' par 'CylinderNearWall2'];
MkdirPath =['G:' par 'NearWallCases' par 'FishNearPlants3D' par 'VortexPlot'];
% FileList = ['K1.00';'K1.50';'K2.00';'K2.50';'K3.00';'K3.50';'K4.00';'K5.00';'K6.00';'K8.00';'K10.0'];
% FileList = ['H1.00';'H1.25';'H1.50';'H1.75';'H2.00';'H2.50';'H3.00';'H5.00'];
FileList = ('PlantsInChannelFlow');
%% Force Combanation Parameters
Re = 200;        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
bodyType   =  3; % 0 closed body, 1 single plate, 2 two plates clamp
isNearWall =  0; % 0 no, 1 yes
%% Acceleration Information
Amp = [0.25 0.00];
Phi = [-90.0 0.00]/180*pi;
Fre = 0.0025/0.01;
n_aver = 3;  % data averaging times for accleration