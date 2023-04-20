clear
clc
%% Input parameters for NACA0015 pitching
Uinfty = 1.;
Vinfty = 0.;
St = 0.30;
AD = 2.00;
NT = 30.0;
thickness = 0.15;
freq      = St*Uinfty/thickness;
Amplitude = AD * thickness;
T  = 1/freq; 
t  =(NT*T:0.001:(NT+1)*T)';
%% Added-mass matrix
mass = zeros(3);
mass(1, 1) = 1.6223089e-02;
mass(1, 2) = 0;
mass(1, 3) = 0;
mass(2, 1) = 0;
mass(2, 2) = 7.8017544e-01;
mass(2, 3) = 0;
mass(3, 1) = 0;
mass(3, 2) = 3.8843205e-01;
mass(3, 3) = 2.1707965e-01;
%% Auxi vars
len = length(t);
omega = 2*pi*freq;
angle   = asin(Amplitude*0.5)*( sin(omega*t)-     omega*t.*exp(-t*omega));
dangle  = asin(Amplitude*0.5)*( cos(omega*t)+ (omega*t-1).*exp(-t*omega) )*omega;
ddangle = asin(Amplitude*0.5)*(-sin(omega*t)+(-omega*t+2).*exp(-t*omega) )*omega*omega;
%% Calculate
Fax = zeros(len, 1);
Fay = zeros(len, 2);
for ii=1:1:len
    Ua = [-Uinfty, -Vinfty]';
    dUa = [0, 0]';
    theta   =   angle(ii);
    dtheta  =  dangle(ii);
    ddtheta = ddangle(ii);
    Fa = ComputeAddedMass2D(Ua,dUa,theta,dtheta,ddtheta,mass);
    Fax(ii) = Fa(1);
    Fay(ii) = Fa(2);
end
force = [t Fax Fay];
%% Write data
% write mesh file
filename = '.\Scripts\AddedMassFocre.dat';
file=fopen(filename,'w');
fprintf(file,'VARIABLES="T","Fx","Fy"');
for i=1:len
    fprintf(file,'%10f    %10f    %10f\n',force(i,1),force(i,2),force(i,3));
end
fclose all;
%% Plot
figure;
plot(force(:,1), force(:,2), '.r-')
hold on
plot(force(:,1), force(:,3), '.b-')
legend('Fx', 'Fy');
title('Added mass force')
pause(1.0)
close all