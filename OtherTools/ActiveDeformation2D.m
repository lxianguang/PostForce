clear
clc
close all
%% Parameters
x  =(0:0.01:1);
t  =(0:0.01:1);
height = 0.12;   %NACA00XX
Amp = 0.02-0.0825*x+0.1625*x.*x;
len=length(x);
y0 = zeros(size(x));
dy = zeros(size(x));
y1 = zeros(length(t),length(x));
y2 = zeros(length(t),length(x));
%% Deformation
for j=1:length(t)
    for i=1:length(x)
        xlabel = (x(i)-x(1))/max(x);
        y0(i)  = height*(0.2969 * sqrt(xlabel) - 0.1260 * xlabel - 0.3516 * xlabel^2 + 0.2843 * xlabel^3 - 0.1036 * xlabel^4)*10/2;
        dy(i)  = Amp(i)*cos(2*pi*(x(i)-t(j)));
        y1(j,i) = dy(i) + y0(i);
        y2(j,i) = dy(i) - y0(i);
    end
end
x1 = [x(1:1:len) x(len-1:-1:1)];
y = [y1(:,1:1:len) y2(:,len-1:-1:1)];
%% Plot
% theta = 15;
% a=plot(x1,y(1,:),'k','LineWidth',2.0,'LineStyle','-');
% axis equal
% axis([-0.5 1.5 -1 1])
% hold on
%% pitching
% b=plot(x1,y(1,:)+0.25,'k','LineWidth',2.0,'LineStyle','-.');
% c=plot(x1,y(1,:)-0.25,'k','LineWidth',2.0,'LineStyle','-.');
%% plunging
% b=plot(x1*cos(theta/180*pi)-y(1,:)*sin(theta/180*pi),x1*sin(theta/180*pi)+y(1,:)*cos(theta/180*pi),'k','LineWidth',2.0,'LineStyle','-.');
% c=plot(x1*cos(-theta/180*pi)-y(1,:)*sin(-theta/180*pi),x1*sin(-theta/180*pi)+y(1,:)*cos(-theta/180*pi),'k','LineWidth',2.0,'LineStyle','-.');
%% plunging + pitching
% b=plot(x1*cos(theta/180*pi)-y(1,:)*sin(theta/180*pi),x1*sin(theta/180*pi)+y(1,:)*cos(theta/180*pi)+0.15,'k','LineWidth',2.0,'LineStyle','-.');
% c=plot(x1*cos(-theta/180*pi)-y(1,:)*sin(-theta/180*pi),x1*sin(-theta/180*pi)+y(1,:)*cos(-theta/180*pi)-0.15,'k','LineWidth',2.0,'LineStyle','-.');

for k=1:length(t)
    a=plot(x1,y(k,:),'k','LineWidth',1.4);
    axis equal
    axis([-0.5 1.5 -1 1])
    [A, map] = rgb2ind(frame2im(getframe),256);
    if k==1
        imwrite(A,map,'.\Scripts\2D.gif','LoopCount',Inf,'DelayTime',0.01)
    else
        imwrite(A,map,'.\Scripts\2D.gif','WriteMode','append','DelayTime',0.01)
    end
end
pause(1.0)
close all