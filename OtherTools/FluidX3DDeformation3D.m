clear;clc;close all
%% parameters
l = 300;         % length
h = 0.06*l;      % height kind 1
%h = 0.10*l;
x = (-l/2:1:l/2);
f = 1e-2;        % frequency
t = (0:1:1/f);   % time
e = 2.00;        % eccentricity kind 1
%e = 1.20;
%% initialization
[X, Y, Z]  = meshgrid(x, x, x);
[lx,ly,lz] = size(X);
flagn = zeros(lx,ly,lz,length(t));
speed = zeros(1,lx);
%% calcaute
for nt=1:length(t)
    for i=1:lx
        for j=1:ly
            xlabel = X(i,j,1)/l+0.50;
            ap     = h*(0.200-0.800*xlabel+1.600*xlabel^2)*cos(2*pi*(xlabel-f*t(nt))); 
            y0     = h*(2.969 * sqrt(xlabel) - 1.260 * xlabel - 3.516 * xlabel^2 + 2.843 * xlabel^3 - 1.036 * xlabel^4);
            y1     = ap-y0;
            y2     = ap+y0;
            if(xlabel<=0.6)
                ne = e - 1.0*(xlabel/0.60)^2;
            else
                ne = e - 1.0 + 3.0*((xlabel-0.6)/0.2)^2;
            end
            for k=1:lz
                flag = (Y(i,j,k)-ap)^2+Z(i,j,k)^2/ne/ne; %kind 1
                %flag = (Y(i,j,k)-ap)^2+Z(i,j,k)^2/e/e;
                if(flag<=y0^2 && xlabel<=0.80) %kind 1
                %if(flag<=y0^2 && y0>=0.50)
                    flagn(i,j,k,nt) = 1.0;
                end
            end
        end
        speed(i) = h*(0.200-0.825*xlabel+1.625*xlabel*xlabel)*sin(2*pi*(xlabel-f*t(nt)))*2*pi*f;
    end
end
%% plot
for nt=1:length(t)
    isosurface(X,Y,Z,flagn(:,:,:,nt),0);
    axis equal
    axis([-l/2 l/2 -2*h 2*h -1.5*e*h 1.5*e*h])
    box on
    ax = gca;
    ax.BoxStyle = 'full';
    set(gca,'xtick',[],'xticklabel',[])
    set(gca,'ytick',[],'yticklabel',[])
    set(gca,'ztick',[],'zticklabel',[])
    colormap gray
    [A, map] = rgb2ind(frame2im(getframe),256);
    if nt==1
        imwrite(A,map,'.\Scripts\ActiveDeformation3D.gif','LoopCount',Inf,'DelayTime',0.02)
    else
        imwrite(A,map,'.\Scripts\ActiveDeformation3D.gif','WriteMode','append','DelayTime',0.02)
    end
    fprintf("picture number: %d\n", nt);
    clf
end
pause(1.0)
close all