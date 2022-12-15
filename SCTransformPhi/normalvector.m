function [dz,dvert,dnorm] = normalvector(z)
% Caculate Normal And Tangent Vector
% Detailed explanation goes here
lenx = size(z,1);
dz = [z(2:1:lenx) - z(1:1:lenx-1); z(lenx)-z(lenx-1)];
dvert = dz./abs(dz);
dnorm = -1i*dvert;
end
