clear;clc;close all
% NACA00xx wing boundary creation
h = 0.12;  % NACA00xx, h = 0.xx
x = [0.000:0.001:0.049 0.05:0.005:1.00];
for i = 1:length(x)
    y(i) = wing(h,x(i));
end

%% calculate parameters
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
fprintf('centerOfMass:(%f %f %f)\n',center)
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
plot(x, y,'r', x ,-y,'r','LineWidth',1.2)
xlim([0 1]); ylim([-0.5 0.5]);

%% output blockMesh parameters
num = find(x==0.02);
% fprintf('============================================\n')
% for i = num+1:length(x)-1
%     fprintf('(%f %f $z0)\n',x(i),y(i))
% end
fprintf('============================================\n')
for i = num+1:length(x)-1
    fprintf('(%f %f $z0)\n',x(i),-y(i))
end
fprintf('============================================\n')
for i = num-1:-1:1
    fprintf('(%f %f $z0)\n',x(i),-y(i))
end
for i = 2:1:num-1
    fprintf('(%f %f $z0)\n',x(i), y(i))
end

function y = wing(h,x)
y = h/0.2*(0.2969*sqrt(x)-0.1260*x-0.3516*x^2+0.2843*x^3-0.1015*x^4);
end