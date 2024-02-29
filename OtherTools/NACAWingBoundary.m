clear;clc;close all;
% NACA00xx wing boundary creation
h     = 0.160;  % NACA00xx, h = 0.xx
angle = pi/18;  % attack angle (pi)
pivot = 0.000;  % pivot point in x axis
x = [0.000:0.001:0.049 0.05:0.005:1.00];
for i = 1:length(x)
    y(i) = wing(h,x(i));
end
%% calculate parameters
fprintf('============================================\n')
rho   = 1000;
thick = 1.00;
area  = 0.00;
% area and mass
for i = 1:length(x)-1
    area = area + (x(i+1)-x(i))*(y(i+1)+y(i));
end
fprintf('area: %f\nmass: %f\n',area,area*thick*rho)
%center of mass
center = zeros(1,3);
for i = 1:length(x)-1
    center(1) = center(1) + (x(i+1)+x(i))/2*(x(i+1)-x(i))*(y(i+1)+y(i))/area;
end
ncenter(1) =  (center(1)-pivot)*cos(angle)+center(2)*sin(angle);
ncenter(2) = -(center(1)-pivot)*sin(angle)+center(2)*cos(angle);
fprintf('centerOfMass :(%f %f)\n', ncenter)
%moment of inertia
xn =  0.0:0.0001:1.0;
yn = -0.5:0.0010:0.5;
momentZ = 0.0;
for i = 1:length(xn)-1
    for j = 1:length(yn)-1
        dx = (xn(i+1) - xn(i));
        dy = (yn(j+1) - yn(j));
        xp = (xn(i+1) + xn(i))/2;
        yp = (yn(j+1) + yn(j))/2;
        if abs(wing(h,xp)) > abs(yp)
            momentZ = momentZ + thick*rho*((xp-center(1))^2+(yp-center(2))^2)*dx*dy;
        end
    end
end
fprintf('momentOfZAxis: %f\n',momentZ)
%% plot
nx1 =  (x-pivot)*cos(angle)+y*sin(angle);
ny1 = -(x-pivot)*sin(angle)+y*cos(angle);
nx2 =  (x-pivot)*cos(angle)-y*sin(angle);
ny2 = -(x-pivot)*sin(angle)-y*cos(angle);

plot(nx1, ny1,'r', nx2, ny2,'b','LineWidth',1.2)
xlim([0-pivot 1-pivot]); ylim([-0.5 0.5]);

%% output blockMesh parameters
num = find(x==0.04);
fprintf('fixed point 08:(%f10 %f10)\n', nx2(num), ny2(num))
fprintf('fixed point 09:(%f10 %f10)\n', nx2(end), ny2(end))
fprintf('fixed point 11:(%f10 %f10)\n', nx1(num), ny1(num))
fprintf('fixed point 12:(%f10 %f10)\n', nx1(end), ny1(end))
fprintf('============================================\n')
filename = '.\Scripts\NACAWingBoundary.dat';
file=fopen(filename,'w');
fprintf(file,'1============================================\n');
for i = num-1:-1:1
    fprintf(file,'        (%f %f $z0)\n',nx2(i),ny2(i));
end
for i = 2:1:num-1
    fprintf(file,'        (%f %f $z0)\n',nx1(i),ny1(i));
end
fprintf(file,'2============================================\n');
for i = num+1:length(x)-1
    fprintf(file,'        (%f %f $z0)\n',nx2(i),ny2(i));
end
fprintf(file,'3============================================\n');
for i = num+1:length(x)-1
    fprintf(file,'        (%f %f $z0)\n',nx1(i),ny1(i));
end
fprintf(file,'4============================================\n');
for i = num-1:-1:1
    fprintf(file,'        (%f %f $z1)\n',nx2(i),ny2(i));
end
for i = 2:1:num-1
    fprintf(file,'        (%f %f $z1)\n',nx1(i),ny1(i));
end
fprintf(file,'5============================================\n');
for i = num+1:length(x)-1
    fprintf(file,'        (%f %f $z1)\n',nx2(i),ny2(i));
end
fprintf(file,'6============================================\n');
for i = num+1:length(x)-1
    fprintf(file,'        (%f %f $z1)\n',nx1(i),ny1(i));
end
fclose all;

function y = wing(h,x)
y = h/0.2*(0.2969*sqrt(x)-0.1260*x-0.3516*x^2+0.2843*x^3-0.1015*x^4);
end