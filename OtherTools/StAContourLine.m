clear
clc
%% Out Put Contour Line Of StA
Kn = 0.27;
St = (0.00:0.001:0.40);
% St = (0.03:0.001:0.40);
len= length(St);
% AD = Kn./St;
AD = Kn * St;
%% Write Data
filename = '.\Scripts\StContourLine.dat';
file=fopen(filename,'w');
fprintf(file,'VARIABLES="StD","AD"\n');
for i=1:len
    fprintf(file,'%10f    %10f\n',St(i),AD(i));
end
fclose all;
%% Plot
figure;
plot(St, AD, '.r-')
axis([0.00 0.30  0 2.0])
pause(1.0)
close all