function [newdata,cx,cy] = positioncorrect(olddata, curvetype)
%   Place the center of the drawing at the coordinate origin
%   detail goes here
if curvetype==1
    lenx = size(olddata,1);
    cx = olddata(floor(lenx/2),1);
    cy = olddata(floor(lenx/2),2);
else
    % Maybe this is wrong,I don't have try!
    clenx = olddata(1,1);
    cleny = olddata(1,2);
    hlenx = olddata(1,1);
    hleny = olddata(1,2);
    for k=2:size(olddata,1)
        hlenx = hlenx + abs(olddata(k,1)-olddata(k-1,1));
        hleny = hleny + abs(olddata(k,2)-olddata(k-1,2));
        clenx = clenx + olddata(k,1)*(olddata(k,1)-olddata(k-1,1));
        cleny = cleny + olddata(k,2)*(olddata(k,2)-olddata(k-1,2));
    end
    cx = clenx/hlenx;
    cy = cleny/hleny;
end
newdata = [olddata(:,1)-cx olddata(:,2)-cy olddata(:,3) olddata(:,4)];
end

