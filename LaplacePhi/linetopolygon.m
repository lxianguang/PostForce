function [index,nx,ny,coor] = linetopolygon(data, halfheight)
%   From point data get the figure outline
len   = size(data,1) ;
dL    = sqrt((data(1,1)-data(2,1))^2+(data(1,2)-data(2,2))^2);
np    = floor(2*halfheight/dL)+1;
dh    = 2*halfheight/np;
coor  = zeros(2*(len-1)+2*np,2);
nx    = len - 1;
ny    = np;

verts = data(:,1) + data(:,2) * 1i;
dnorm = normalvector(verts);

vertdown  = verts(1:1:(len-1)) + halfheight*dnorm(1:1:(len-1));
vertright = verts(len)         + (halfheight:-dh:(-halfheight+dh))'*dnorm(end);
vertupper = verts(len:-1:2)    - halfheight*dnorm(len:-1:2);
vertleft  = verts(1)           - (halfheight:-dh:-halfheight+dh)'*dnorm(1);

tolverts  = [vertdown; vertright; vertupper; vertleft];
index     = [1:1:nx (nx+1)*ones(1,ny) (nx+1):-1:2 ones(1,ny)];

coor(:,1) = real(tolverts);
coor(:,2) = imag(tolverts);
end

