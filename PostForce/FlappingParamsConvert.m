%% targeting dimensionless parameters
clc
clear
format long
Periodnum = 20 * 2.5;
Shear = 0.20; %dimensionless shear rate
Amp=0.25; % amplitude (half peak-to-peak value)
dt = 1/10000.; % dimensionless time step by period
doutFlow = 1/8; %flow field output time interval per period
doutInfo = 1/1024;%flow infomation output time interval per period
%% values with dimension
dtreal = 1/100.;%mesh size
Lreal = 1.0; %plate length
%% parameters with dimension (used in the input file)
%% for reference velocity 11, U_ref is the maximum plunging velocity
T = dtreal / dt;
Uref = Lreal / T;
f = Uref / (2 * pi * Amp);
period = Uref / f;
ShearReal = Shear*Uref / (2 * Amp);
outflow = doutFlow * period; % outflow / Tref
outInfo = doutInfo * period; % outflow / Tref
%% print parameters
fprintf('Total Calculate Time:  %.12f\n',Periodnum*period)
fprintf('Real Shear Rate:       %.13f\n',ShearReal)
fprintf('Flapping Frequency:    %.13f\n',f)
fprintf('One Period Length:     %.13f\n',period)
fprintf('Flow write interval:   %.13f\n',outflow)
fprintf('Data write interval:   %.13f\n',outInfo)