function [dnorm] = normalvector(z)
% Caculate Normal And Tangent Vector
len = size(z,1);
z2  = [z(2:1:len);z(1)];
z1  = [z(end);z(1:1:len-1)];
dz  = z2-z1;
dvert = dz./abs(dz);
dnorm = -1i*dvert;
end
