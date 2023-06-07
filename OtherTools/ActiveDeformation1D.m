clear
clc
close all
%% Parameters
x =(0:0.01:1);
t =(0:0.0625:1);
y = zeros(length(x),length(t));
l = 1*max(x);
Amp = zeros(length(x),1);
%% Deformation
for nt=1:length(t)
    for i=1:length(x)
        nx     = (x(i)-x(1))/(x(end)-x(1));
        % Amp(i)    = 0.02 - 0.12*nx + 0.20*nx^2;  % C
        Amp(i)    = 0.02 - 0.08*nx + 0.16*nx^2;  % S
        y(i,nt)= Amp(i)*sin(2*pi*(nx/l-t(nt)));
    end
end
%% Plot
% for k=1:length(t)
%     a=plot(x,y(:,k),'k','LineWidth',1.2,'color',rand(1,3));
%     axis([0 1 -0.15 0.15])
%     box on
%     ax = gca;
%     ax.BoxStyle = 'full';
%     set(gca,'xtick',[],'xticklabel',[])
%     set(gca,'ytick',[],'yticklabel',[])
%     set(gca,'ztick',[],'zticklabel',[])
%     hold on
% end
%% Get gif
for k=1:length(t)
    a=plot(x,y(:,k),'k','LineWidth',1.4);
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
        imwrite(A,map,'.\Scripts\ActiveDeformation1D.gif','LoopCount',Inf,'DelayTime',0.02)
    else
        imwrite(A,map,'.\Scripts\ActiveDeformation1D.gif','WriteMode','append','DelayTime',0.02)
    end
end
pause(1.0)
close all