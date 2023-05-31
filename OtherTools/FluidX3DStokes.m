clc
clear
%% Parameters
t = 10000;
u = 0.010;
L = 256.0;
f = 0.001;
z = (0:1:L);
Re= 2.00;
nu= u*L/Re;
k = sqrt(2*pi*f/2/nu);
%% Profile
U = u*exp(-k*z).*cos(k*z-2*pi*f*t);
%% Plot
plot(z,U);
%% Write Data
filename = '.\Scripts\FuildX3dStokes.dat';
file=fopen(filename,'w');
fprintf(file,'VARIABLES="z","u"\n');
for i=1:length(z)
    fprintf(file,'%10f    %10f\n',z(i),U(i));
end
fclose all;