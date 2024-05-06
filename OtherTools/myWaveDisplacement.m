clear;clc;close all
%% Parameters
x =(0:0.01:3.25);
t =(0:0.02:1.00);
y = zeros(length(x),length(t));
A = 0.10;     % amplitude
k = 3.25;     % wave number
w = 2*pi;     % omega
%% Deformation
for nt=1:length(t)
    for nx=1:length(x)
        a    = 0.0 + 0.4*x(nx);
        %y(nx,nt) = A*sin(w*t(nt)-k*x(nx));   %waveDisplacement
        y(nx,nt) = A*a*sin(w*t(nt)-k*x(nx)); %myWaveDisplacement
    end
end
%% Plot
% for k=1:length(t)
%     a=plot(x,y(:,k),'k','LineWidth',1.2,'color',rand(1,3));
%     axis([0 3.25 -0.1 0.1])
%     box on
%     ax = gca;
%     ax.BoxStyle = 'full';
%     set(gca,'xtick',[],'xticklabel',[])
%     set(gca,'ytick',[],'yticklabel',[])
%     set(gca,'ztick',[],'zticklabel',[])
%     axis equal
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
    axis([-0.25 3.50 -0.1 0.1])
    axis equal
    [A, map] = rgb2ind(frame2im(getframe),256);
    if k==1
        imwrite(A,map,'.\Scripts\myWaveDisplacement.gif','LoopCount',Inf,'DelayTime',0.02)
    else
        imwrite(A,map,'.\Scripts\myWaveDisplacement.gif','WriteMode','append','DelayTime',0.02)
    end
end