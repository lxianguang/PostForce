clear
clc
%% Abscissa Set
x = (0:0.001:1);
%% Ordinate Calculation
y = zeros(1,length(x));
for i=1:length(x)
    y(i) = theory(x(i));
end
%% Write Data
filename = '.\Scripts\Test.dat';
file=fopen(filename,'w');
fprintf(file,'VARIABLES="x","y"\n');
for i=1:length(x)
    fprintf(file,'%10f    %10f\n',x(i),y(i));
end
fclose all;
%% Plot
figure;
plot(x, y, '.r-')
xlim([x(1) x(end)])
axis equal
%% theory line function
function y = theory(x)
h = 0.20;
y = h/0.2*(0.2969*sqrt(x)-0.1260*x-0.3516*x^2+0.2843*x^3-0.1015*x^4);
end