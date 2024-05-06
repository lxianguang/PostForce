clear;clc;close all
%% parameters
l = 250;
h = 0.1*l;
x = (-l/2:1:l/2);
t = 0.0;
f = 1e-3;
le =length(x);
y0 = zeros(size(x));
y1 = zeros(size(x));
y2 = zeros(size(x));
ap = zeros(size(x));
ve = zeros(size(x));
%% calcaute
for i=1:le
    xlabel = x(i)/l+0.50;
    ap(i)  = h*(0.200-0.825*xlabel+1.625*xlabel*xlabel)*cos(2*pi*(xlabel-f*t)); 
    y0(i)  = h*(2.969 * sqrt(xlabel) - 1.260 * xlabel - 3.516 * xlabel^2 + 2.843 * xlabel^3 - 1.036 * xlabel^4);
    y1(i)  = ap(i)+y0(i);
    y2(i)  = ap(i)-y0(i);
    ve(i)  = h*(0.200-0.825*xlabel+1.625*xlabel*xlabel)*sin(2*pi*(xlabel-f*t))*2*pi*f;
end
nx = [x(1:1:le) x(le-1:-1:1)];
ny = [y1(1:1:le) y2(le-1:-1:1)];
%% plot
plot(nx,ny,'k','LineWidth',2.0,'LineStyle','-');
axis equal
box on
ax = gca;
ax.BoxStyle = 'full';
set(gca,'xtick',[],'xticklabel',[])
set(gca,'ytick',[],'yticklabel',[])
set(gca,'ztick',[],'zticklabel',[])
axis([-l/1.5 l/1.5 -h*1.5 h*1.5])