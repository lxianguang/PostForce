%% targeting dimensionless parameters (Tref = Lref/Uref, the real period is fixed)
clc
clear
format long
Periodnum = 30.0;
Shear     = 0.00;       % dimensionless shear rate
Amp       = 0.25;       % amplitude (half peak-to-peak value)
dtreal    = 1/10000;     % dimensionless time step by period
doutFlow  = 1/8;        % flow field output time interval per period
doutInfo  = doutFlow/128;    % flow infomation output time interval per period
%% values with dimension
dx        = 0.010;      % mesh size
Lreal     = 1.000;      % plate length
%% parameters with dimension (used in the input file)
%% for reference velocity 11, U_ref is the maximum plunging velocity
Tref      = dx    / dtreal;
Uref      = Lreal / Tref;
freq      = Uref  / (2 * pi * Amp);
period    = (1/freq)/Tref;
ShearReal = Shear * Uref / (2 * Amp);
outflow   = doutFlow * period; % outflow / Tref
outInfo   = doutInfo * period; % outflow / Tref
%% print parameters
fprintf('Total Calculate Time:  %.12f\n',Periodnum * period)
fprintf('Real Shear Rate:       %.13f\n',ShearReal)
fprintf('Flapping Frequency:    %.13f\n',freq)
fprintf('One Period Length:     %.13f\n',period )
fprintf('Flow write interval:   %.13f\n',outflow)
fprintf('Data write interval:   %.13f\n',outInfo)