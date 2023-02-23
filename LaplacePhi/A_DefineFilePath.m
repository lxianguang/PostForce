clc
clear
%% Set Separator According To Different Systems
if ispc
    par = '\';
else
    par = '/';
end
%% Define File Path
% MkdirPath = ['F:' par 'IntervalPlate' par 'ForceCalculate' par 'Re100A0.25WtWL' par 'K1.00Wt0.40S0.20'];
% FileList  = ['Wt0.00';'Wt0.10';'Wt0.20';'Wt0.30';'Wt0.40';'Wt0.50';'Wt0.60';'Wt0.80';'Wt1.00'];
% FileList  = ['WL0.00';'WL0.05';'WL0.10';'WL0.15';'WL0.20';'WL0.25';'WL0.30';'WL0.35';'WL0.40'];
% FileList  = ['S0.00';'S0.10';'S0.20';'S0.30';'S0.40';'S0.50'];
%% Test
MkdirPath = [par 'home' par 'data' par 'xluo' par 'LaplaceTest'];
FileList =('Cylinder4');
%% Data Smooth Parameters
n_aver = [0 0 0 0 0 0];  % data averaging times for accleration, velocity, force, power, point velocity, stress energy
%% Force Combanation Parameters
Re = 100;
fprintf('Path And Parameter Set!\n');
fprintf('*******************************************************************\n');