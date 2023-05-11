function [theata,npoints,halfpoints] = endArcPoints(norm,radius,dL)
% calculate points at end half circle of the line
[npoints,halfpoints,dtheata] = arcPoints(pi, radius, dL);
if real(norm)>=0 && imag(norm)<=0
    theata = atan(imag(norm)/real(norm)) + (-halfpoints*dtheata:dtheata:halfpoints*dtheata)';
elseif real(norm)<0 && imag(norm)<=0
    theata = -pi + atan(imag(norm)/real(norm)) + (-halfpoints*dtheata:dtheata:halfpoints*dtheata)';
elseif real(norm)<0 && imag(norm)>0
    theata =  pi + atan(imag(norm)/real(norm)) + (-halfpoints*dtheata:dtheata:halfpoints*dtheata)';
else
    theata = atan(imag(norm)/real(norm)) + (-halfpoints*dtheata:dtheata:halfpoints*dtheata)';    
end
end

