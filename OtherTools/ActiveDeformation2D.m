clear
clc
close all
%% Parameters
x  = (0:0.01:1);
t  = (0:0.01:1);
h  = 0.10;            %NACA00XX  half height
y0 = zeros(size(x));
dy = zeros(size(x));
y1 = zeros(length(t),length(x));
y2 = zeros(length(t),length(x));
len= length(x);
%% Deformation
for j=1:length(t)
    for i=1:length(x)
        nx = (x(i)-x(1))/(x(end)-x(1));
        y0(i)  = h*(2.969 * sqrt(nx) - 1.260 * nx - 3.516 * nx^2 + 2.843 * nx^3 - 1.036 * nx^4);
        dy(i)  = h*(0.20-0.80*nx+1.60*nx^2)*cos(2*pi*(x(i)-t(j)));
        y1(j,i) = dy(i) + y0(i);
        y2(j,i) = dy(i) - y0(i);
    end
end
x1 = [x(1:1:len) x(len-1:-1:1)];
y = [y1(:,1:1:len) y2(:,len-1:-1:1)];
% y = [y0(:,1:1:len) -y0(:,len-1:-1:1)];
%% Plot
% theta = 15;
% a=plot(x1,y,'k','LineWidth',2.0,'LineStyle','-');
% axis equal
% axis([-0.5 1.5 -1 1])
% box on
% ax = gca;
% ax.BoxStyle = 'full';
% set(gca,'xtick',[],'xticklabel',[])
% set(gca,'ytick',[],'yticklabel',[])
% set(gca,'ztick',[],'zticklabel',[])
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
    box on
    ax = gca;
    ax.BoxStyle = 'full';
    set(gca,'xtick',[],'xticklabel',[])
    set(gca,'ytick',[],'yticklabel',[])
    set(gca,'ztick',[],'zticklabel',[])
    axis([-0.5 1.5 -1 1])
    [A, map] = rgb2ind(frame2im(getframe),256);
    if k==1
        imwrite(A,map,'.\Scripts\ActiveDeformation2D.gif','LoopCount',Inf,'DelayTime',0.02)
    else
        imwrite(A,map,'.\Scripts\ActiveDeformation2D.gif','WriteMode','append','DelayTime',0.02)
    end
end
pause(1.0)
close all