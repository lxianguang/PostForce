function [dnorm] = normalvector(z)
% Caculate Normal And Tangent Vector
len = size(z,1);
dz = [z(2:1:len) - z(1:1:len-1); z(len)-z(len-1)];
dvert = dz./abs(dz);
dnorm = -1i*dvert;
end
