function [index,npoints,coor] = linetopolygon(data, halfheight, type)
%   From point data get the figure outline
np = 3;
dh = halfheight/np;
dL = sqrt((data(1,1)-data(2,1))^2+(data(1,2)-data(2,2))^2);
if type==0
    %% closed body
    len   = size(data,1)-1;
    data  = data(1:len,:);
    
    verts = data(:,1) + data(:,2)*1i;
    dnorm = normalvector(verts);
    
    coor(:,1) = real(verts + dnorm * halfheight);
    coor(:,2) = imag(verts + dnorm * halfheight);
    
    index     = (1:1:len);
    npoints   = size(coor,1);
elseif type==1
    %% single plate for rectangle boudary 
    len   = size(data,1) ;
    verts = data(:,1) + data(:,2) * 1i;
    dnorm = normalvector(verts);

    % line 1
    vert1     = verts(1:1:len) + halfheight*dnorm(1:1:len);
    indexline1= (1:1:len);
    % line 2
    vert2     = verts(len)     + (dh*(np-1):-dh:-dh*(np-1))'*dnorm(end);
    indexline2= len*ones(1,2*np-1);
    % line 3
    vert3     = verts(len:-1:1)- halfheight*dnorm(len:-1:1);
    indexline3= (len:-1:1);
    % line 4
    vert4     = verts(1)       + (-dh*(np-1):dh:dh*(np-1))'*dnorm(1);
    indexline4= 1*ones(1,2*np-1);
    % combination
    vert    = [vert1; vert2; vert3; vert4];
    npoints = length(vert); 
    coor(:,1) = real(vert);
    coor(:,2) = imag(vert);
    % get point index
    index     = [indexline1 indexline2 indexline3 indexline4]';
elseif type==2
    %% two plates clamp for circle boundary
    len   = size(data,1) ;
    mid   = (len - 1) / 2 + 1;  
    verts = data(:,1) + data(:,2) * 1i; 
    dnorm = normalvector(verts);
    % line 1
    vert1 = verts(1:mid-1) + halfheight*dnorm(1:mid-1);
    indexline1 = (1:1:mid-1);
    % arc  0
    alpha = atan((data(1,2)-data(mid,2))/(data(1,1)-data(mid,1)));     
    [~,nhalf0,dalpha0] = arcPoints(pi - 2*alpha, halfheight, dL);
    the0  = pi + (-(nhalf0+1)*dalpha0:dalpha0:(nhalf0+1)*dalpha0)';
    arc0  = verts(mid) + halfheight*(cos(the0)+sin(the0)*1i);
    indexarc0 = mid*ones(1,length(arc0));
    % line 2
    vert2 = verts(mid+1:end) + halfheight*dnorm(mid+1:end);
    indexline2= (mid+1:1:len);
    % arc  1
    arc1      = verts(len)  + (dh*(np-1):-dh:-dh*(np-1))'*dnorm(end);
    indexarc1 = len*ones(1,length(arc1));
    % line 3 
    halfvert1 = verts(end:-1:(mid+1)) - halfheight*dnorm(end:-1:(mid+1));
    halfvert1(imag(halfvert1)>=0)=[];
    halfvert2 = verts((mid-1):-1:1  ) - halfheight*dnorm((mid-1):-1:1  );
    halfvert2(imag(halfvert2)<=0)=[];
    vert3     = [halfvert1;halfvert2]; 
    indexline3= [len:-1:len-size(halfvert1)+1 size(halfvert2):-1:1];
    % arc  2
    arc2      = verts(1)       + (-dh*(np-1):dh:dh*(np-1))'*dnorm(1);
    indexarc2= 1*ones(1,length(arc2));
    % combination
    vert  = [vert1;arc0;vert2;arc1;vert3;arc2];
    npoints   = length(vert);
    coor(:,1) = real(vert);
    coor(:,2) = imag(vert);
    % get point index
    index = [indexline1 indexarc0 indexline2 indexarc1 indexline3 indexarc2]';
elseif type==3
    %% single plate for circle boundary
    len   = size(data,1) ;
    verts = data(:,1) + data(:,2) * 1i; 
    dnorm = normalvector(verts);
    % line 1
    vert1  = verts(1:1:len) + halfheight*dnorm(1:1:len);
    indexline1 = (1:1:len);
    % arc  1
    norm  = verts(end) - verts(end - 1);
    [the1,narc1,~] = endArcPoints(norm,halfheight,dL);
    arc1  = verts(end) + halfheight*(cos(the1)+sin(the1)*1i);
    indexarc1  = len*ones(1,narc1);
    % line 2
    vert2 = verts(len:-1:1) - halfheight*dnorm(len:-1:1);
    indexline2 = (len:-1:1);
    % arc  2
    norm  = verts(1) - verts(2);
    [the2,narc2,~] = endArcPoints(norm,halfheight,dL);
    arc2  = verts(1) + halfheight*(cos(the2)+sin(the2)*1i);
    indexarc2  = 1*ones(1,narc2);
    % combination
    vert  = [vert1;arc1;vert2;arc2];
    npoints   = length(vert);
    coor(:,1) = real(vert);
    coor(:,2) = imag(vert);
    % get point index
    index = [indexline1 indexarc1 indexline2 indexarc2]';
elseif type==4
    %% two plates clamp for circle boundary
    len   = size(data,1) ;
    mid   = (len - 1) / 2 + 1;  
    verts = data(:,1) + data(:,2) * 1i; 
    dnorm = normalvector(verts);
    % line 1
    vert1 = verts(1:mid-1) + halfheight*dnorm(1:mid-1);
    indexline1 = (1:1:mid-1);
    % arc  0
    alpha = atan((data(1,2)-data(mid,2))/(data(1,1)-data(mid,1)));     
    [~,nhalf0,dalpha0] = arcPoints(pi - 2*alpha, halfheight, dL);
    the0  = pi + (-(nhalf0+1)*dalpha0:dalpha0:(nhalf0+1)*dalpha0)';
    arc0  = verts(mid) + halfheight*(cos(the0)+sin(the0)*1i);
    indexarc0  = mid*ones(1,length(arc0));
    % line 2
    vert2 = verts(mid+1:end) + halfheight*dnorm(mid+1:end);
    indexline2 = (mid+1:1:len);
    % arc  1
    norm  = verts(end) - verts(end - 1);
    [the1,~,~] = endArcPoints(norm,halfheight,dL);
    arc1  = verts(end) + halfheight*(cos(the1)+sin(the1)*1i);
    indexarc1  = len*ones(1,length(arc1));
    % line 3 
    halfvert1 = verts(end:-1:(mid+1)) - halfheight*dnorm(end:-1:(mid+1));
    halfvert1(imag(halfvert1)>=0)=[];
    halfvert2 = verts((mid-1):-1:1   ) - halfheight*dnorm((mid-1):-1:1  );
    halfvert2(imag(halfvert2)<=0)=[];
    vert3 = [halfvert1;halfvert2]; 
    indexline3 = [len:-1:len-size(halfvert1)+1 size(halfvert2):-1:1];
    % arc  2
    norm  = verts(1) - verts(2);
    [the2,~,~] = endArcPoints(norm,halfheight,dL);
    arc2  = verts(1) + halfheight*(cos(the2)+sin(the2)*1i);
    indexarc2  = 1*ones(1,length(arc2));
    % combination
    vert  = [vert1;arc0;vert2;arc1;vert3;arc2];
    npoints   = length(vert);
    coor(:,1) = real(vert);
    coor(:,2) = imag(vert);
    % get point index
    index = [indexline1 indexarc0 indexline2 indexarc1 indexline3 indexarc2]';
else
    error('No such body type!!!')
end
end