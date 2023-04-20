function [Fa] = ComputeAddedMass2D(Ua,DUa,theta,Omega,DOmega,massBody)
%% auxi vars
trans = [cos(theta) sin(theta); -sin(theta) cos(theta)];
Ub = trans * Ua;
DUb = trans * DUa;
Ur  = [ Ub(1)  Ub(2)  Omega];
DUr = [DUb(1) DUb(2) DOmega];
F1b = -DUr*massBody(:,1) + Omega*Ur*massBody(:,2);
F2b = -DUr*massBody(:,2) - Omega*Ur*massBody(:,1);
Fa = trans'*[F1b F2b]';
end