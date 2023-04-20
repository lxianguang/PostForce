clear
clc
close all
%% Resultant force decomposition by WPS theory 
%% Set Separator According To Different Systems
par = judgesystem();
%% Define File Path
% MkdirPath = [par 'home' par 'data' par 'xluo' par 'FishNearWall2D' par 'Re100A0.50K3.50S0.00H'];
MkdirPath =['G:' par 'DataFile' par 'FishNearWall2D' par 'VortexPlot' par 'Re100A0.50K3.50H1.00S'];
% FileList = ['K1.00';'K1.50';'K2.00';'K2.50';'K3.00';'K3.50';'K4.00';'K5.00';'K6.00';'K8.00';'K10.0'];
% FileList = ['H1.00';'H1.25';'H1.50';'H1.75';'H2.00';'H2.50';'H3.00';'H5.00'];
FileList = ('S1.00');
%% Data Smooth Parameters
n_aver = 6;  % data averaging times for accleration
%% Force Combanation Parameters
Re = 100;        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
bodyType   =  1; % 0 closed body, 1 single plate, 2 two plates clamp
isNearWall =  1; % 0 no, 1 yes