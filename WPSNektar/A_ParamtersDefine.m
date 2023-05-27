clear
clc
close all
%% Resultant force decomposition by WPS theory 
%% Set Separator According To Different Systems
par = judgesystem();
%% Define File Path
MkdirPath = ['G:' par 'DataFile' par 'TwoPlateClamp2D'];
FileList = ('D5.00');
% FileList = ['D6.00';'D7.00';'D8.00';'D9.00';'D10.0';'D11.0';'D12.0';'D13.0';'D14.0';'D15.0';'D16.0'];
%% Data Smooth Parameters
n_aver = 3;  % data averaging times for accleration
%% Force Combanation Parameters
Re = 200;        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
bodyType   =  2; % 0 closed body, 1 single plate, 2 two plates clamp
isNearWall =  0; % 0 no, 1 yes