%% targeting dimensionless parameters
clc
clear
format long
PeriodLen = 1.0;
Periodnum = 20.0;
Shear     = 0.00;       % dimensionless shear rate
Amp       = 0.100;       % amplitude (half peak-to-peak value)
dtreal    = 1/1250;     % dimensionless time step by period
doutFlow  = 1/8;        % flow field output time interval per period
doutInfo  = doutFlow/128;    % flow infomation output time interval per period
%% values with dimension
dx        = 0.015;      % mesh size
Lreal     = 1.000;      % plate length
%% parameters with dimension (used in the input file)
%% for reference velocity 11, U_ref is the maximum plunging velocity
Tref      = dx    / dtreal;
Uref      = Lreal / Tref;
freq      = Uref  / (2 * pi * Amp);
period    = 1/freq/Tref;
ShearReal = Shear * Uref / (2 * Amp);
outflow   = doutFlow * period; % outflow / Tref
outInfo   = doutInfo * period; % outflow / Tref
%% print parameters
fprintf('Total Calculate Time:  %.12f\n',Periodnum * PeriodLen * period)
fprintf('Real Shear Rate:       %.13f\n',ShearReal)
fprintf('Flapping Frequency:    %.13f\n',freq)
fprintf('One Period Length:     %.13f\n',period  * PeriodLen)
fprintf('Flow write interval:   %.13f\n',outflow * PeriodLen)
fprintf('Data write interval:   %.13f\n',outInfo * PeriodLen)