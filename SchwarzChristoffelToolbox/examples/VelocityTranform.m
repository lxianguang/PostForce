close all
clear
clc

% p平面复速度势
syms z;
U = 1.0;
V = 0.0;
w_p = (U-1i*V) * z;
dw_p = diff(w_p,z);

% sc变换
p = polygon([inf,1i,0],[-1,1.5,0.5]);
f = hplmap(p);
s = prevertex(f);
figure(1)
plot(f)

% 求在zeta平面内速度
[X,Y]=meshgrid((-4:0.4:4),(0.2:0.4:4));
dp=subs(dw_p,z,X+1i*Y);
up=real(double(dp));
vp=-imag(double(dp));

figure(2)
plot(polygon([-4,4]))
hold on
xlim([-4 4])
ylim([-1 5])
quiver(X,Y,up,vp)

% 求在z平面内速度
[X,Y]=meshgrid((-4:0.2:0),(1.2:0.2:4));
pp = evalinv(f,X+1i*Y);
dp=subs(dw_p,z,pp);
dz=double(dp./evaldiff(f,pp));
uz=real(dz);
vz=-imag(dz);

figure(3)
plot(polygon([-4+1i,1i,0,4,0,1i]))
hold on
xlim([-4 4])
ylim([-1 5])
quiver(X,Y,uz,vz)

[X,Y]=meshgrid((0.2:0.2:4),(0.2:0.2:4));
pp = evalinv(f,X+1i*Y);
dp=subs(dw_p,z,pp);
dz=double(dp./evaldiff(f,pp));
uz=real(dz);
vz=-imag(dz);
quiver(X,Y,uz,vz)
