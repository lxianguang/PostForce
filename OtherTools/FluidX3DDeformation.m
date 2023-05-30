clc
clear
%% parameters
l = 128;
h = 12.;
a = 20/180*pi;
x = (-l/2:1:l/2);
le =length(x);
y0 = zeros(size(x));
y1 = zeros(size(x));
y2 = zeros(size(x));
ap = zeros(size(x));
%% calcaute
for i=1:le
    xlabel = x(i)/l;
    ap(i)  = h*(0.02-0.0825*(xlabel+0.50)+0.1625*(xlabel+0.50)*(xlabel+0.50))*cos(2*pi*(xlabel+0.50))*10; 
    y0(i)  = h*(0.2969 * sqrt(xlabel+0.50) - 0.1260 * (xlabel+0.50) - 0.3516 * (xlabel+0.50)^2 + 0.2843 * (xlabel+0.50)^3 - 0.1036 * (xlabel+0.50)^4)*10;
    y1(i)  = ap(i)+y0(i);
    y2(i)  = ap(i)-y0(i);
end
nx = [x(1:1:le) x(le-1:-1:1)];
ny = [y1(1:1:le) y2(le-1:-1:1)];
%% plot
plot(nx,ny,'k','LineWidth',2.0,'LineStyle','-');
axis equal