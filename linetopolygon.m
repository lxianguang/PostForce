function [vertices, index] = linetopolygon(data, curvetype, halfheight)
%   From point data get the figure outline
%   Detailed explanation goes here
verts = data(:,1) + 1i*data(:,2);
len = length(verts);
dvert = [verts((2:1:len))-verts((1:1:len-1));verts(len)-verts(len-1)];
dnorm = -1i*dvert./abs(dvert);
if curvetype==1
    index = [1:1:len len:-1:1]';
    vertices = [verts(1:1:len) + halfheight*dnorm;verts(len:-1:1) - halfheight*dnorm(len:-1:1)];
else
    index = (1:1:len)';
    vertices = verts(index);
end
end

