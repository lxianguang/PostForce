clear
clc
close all
%% Parameters
x =(0:0.01:1);
t =(0:0.01:1);
y = zeros(length(t),length(x));
Amp = 0.02-0.0825*x+0.1625*x.*x;
%% Deformation
for j=1:length(t)
    for i=1:length(x)
        xlabel = (x(i)-x(1))/max(x);
        y(j,i) = Amp(i)*cos(2*pi*(x(i)-t(j)));
    end
end
%% Plot
% a=plot(x,y(5,:),'k','LineWidth',1.4);
% axis equal
% axis([-0.5 1.5 -1 1])
% [A, map] = rgb2ind(frame2im(getframe),256);
% imwrite(A,map,'1.gif','LoopCount',65535,'DelayTime',0.1)

for k=1:length(t)
    a=plot(x,y(k,:),'k','LineWidth',1.4);
    axis equal
    axis([-0.5 1.5 -1 1])
    [A, map] = rgb2ind(frame2im(getframe),256);
    if k==1
        imwrite(A,map,'.\Scripts\1D.gif','LoopCount',Inf,'DelayTime',0.01)
    else
        imwrite(A,map,'.\Scripts\1D.gif','WriteMode','append','DelayTime',0.01)
    end
end
pause(1.0)
close all