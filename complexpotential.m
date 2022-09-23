function [phi]= complexpotential(zeta,z, C, U0)
%  Thansform Phi from Cylinder to Physic plane
%   Detailed explanation goes here
U = U0*conj(C);
phi = real((conj(U)*zeta+U./zeta)-conj(U0)*z);
maxcorrect = (max(max(phi))+min(min(phi)))/2;
phi = phi - maxcorrect;
end
