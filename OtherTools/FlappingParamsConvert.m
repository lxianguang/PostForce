%% targeting dimensionless parameters
clc
clear
format long
PeriodLen = 1.0;
Periodnum = 10;
Shear     = 0.00;       % dimensionless shear rate
Amp       = 0.25;       % amplitude (half peak-to-peak value)
dt        = 1/10000;    % dimensionless time step by period
doutFlow  = 1/8;        % flow field output time interval per period
doutInfo  = doutFlow/128;    % flow infomation output time interval per period
%% values with dimension
dtreal    = 1/100.;      % mesh size
Lreal     = 1.0;         % plate length
%% parameters with dimension (used in the input file)
%% for reference velocity 11, U_ref is the maximum plunging velocity
T         = dtreal / dt;
Uref      = Lreal / T;
f         = Uref / (2 * pi * Amp);
period    = Uref / f;
ShearReal = Shear*Uref / (2 * Amp);
outflow   = doutFlow * period; % outflow / Tref
outInfo   = doutInfo * period; % outflow / Tref
% outInfo   = (floor(outInfo0/dt)+1)*dt;
%% print parameters
fprintf('Total Calculate Time:  %.12f\n',Periodnum * PeriodLen * period)
fprintf('Real Shear Rate:       %.13f\n',ShearReal)
fprintf('Flapping Frequency:    %.13f\n',f)
fprintf('One Period Length:     %.13f\n',period * PeriodLen)
fprintf('Flow write interval:   %.13f\n',outflow * PeriodLen)
fprintf('Data write interval:   %.13f\n',outInfo * PeriodLen)