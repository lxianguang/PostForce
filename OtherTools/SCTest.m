clear
clc
close all

p = polygon([-1,1,Inf],[1,1,-1]);
f = diskmap(p);
% rectangle
a0 = (-1:0.01:1)+0.5i;
a1 = 1+(0.51:0.01:1.0)*1i;
a2 = (0.99:-0.01:-1)+1i;
a3 = -1+(0.99:-0.01:0.51)*1i;
a  = [a0 a1 a2 a3];
% map
b = evalinv(f,a);
c = exp(1i*linspace(0,2*pi,180));
% z
figure(1)
plot(polygon(p))
hold on 
plot(polygon(a))
axis([-3 3 -1 3])
% zeta
figure(2)
plot(polygon(b))
hold on 
plot(polygon(c))
axis equal
axis([-2 2 -2 2])

% for i=1:50
%    d(i)=b(i*10); 
% end
% ff = annulusmap(polygon(exp(1i*linspace(0,2*pi,10))),polygon(d));
% for i=1:180
%     dd(i) = eval(ff,c(i));
% end
% figure(3)
% plot(polygon(exp(1i*linspace(0,2*pi,10))))
% hold on 
% plot(polygon(dd))
% axis equal
% axis([-2 2 -2 2])

d = 0.5*exp(1i*linspace(0,2*pi,180));
figure(3)
plot(polygon(c))
hold on 
plot(polygon(d))
axis equal
axis([-2 2 -2 2])

figure(4)
plot(polygon(0.5*c+1i))
hold on 
plot(polygon(p))
axis equal
axis([-3 3 -1 4])