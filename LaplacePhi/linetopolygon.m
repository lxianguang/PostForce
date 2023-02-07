function [index,nx,ny,coor] = linetopolygon(data, halfheight, num)
%   From point data get the figure outline
if num==0
    % closed body
    len   = size(data,1)-1;
    nx    = len / 4;
    ny    = len / 4;
    index = (1:1:len);
    data1 = data(1:len,:);
    
    vert = data1(:,1) + data1(:,2)*1i;
    lenv = length(vert);
    dz   = [vert(2)-vert(lenv); vert(3:1:lenv) - vert(1:1:lenv-2); vert(1)-vert(lenv)]/2;
    norm = -1i*dz./abs(dz);
    
    coor(:,1) = real(vert + norm * halfheight);
    coor(:,2) = imag(vert + norm * halfheight);
else
    % line 
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
end