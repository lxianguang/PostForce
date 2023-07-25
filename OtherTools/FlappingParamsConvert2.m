%% targeting dimensionless parameters (Tref = dt/dtreal, the real period is not fixed)
clc
clear
format long
PeriodNum = 30.0;
freq      = 0.013;
Shear     = 0.00;            % dimensionless shear rate
Amp       = 0.25;            % amplitude (half peak-to-peak value)
dtReal    = 1e-4;            % Real time in a step
doutFlow  = 1/8;             % flow field output time interval per period
doutInfo  = doutFlow/125;    % flow infomation output time interval per period
%% values with dimension
dx        = 0.010;           % mesh size, dx = dt
Lreal     = 1.000;           % plate length
%% parameters with dimension (used in the input file)
%% for reference velocity 11, U_ref is the maximum plunging velocity
Tref      = dx/dtReal;          % real calculate time, 1e-4 a step
PeriodLen = 1/freq/Tref;   % period = (1/freq)/Tref
Uref      = 2.0*pi*freq*Amp;
ShearReal = Shear*Uref/(2*Amp);
outflow   = doutFlow*PeriodLen; % outflow / Tref
outInfo   = doutInfo*PeriodLen; % outflow / Tref
%% print parameters
fprintf('Total Calculate Time:  %.12f\n',PeriodNum * PeriodLen)
fprintf('Real Shear Rate:       %.13f\n',ShearReal)
fprintf('One Period Length:     %.13f\n',PeriodLen )
fprintf('Flow write interval:   %.13f\n',outflow)
fprintf('Data write interval:   %.13f\n',outInfo)