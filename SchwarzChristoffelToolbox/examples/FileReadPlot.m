close all
clear
clc

% 读取数据
contain = importdata('Body.dat');
data = contain.data;
x = data(:,1);
y = data(:,2);

% 给出拍动板各个节点
z1 = x + 1i*y;
% 间隔取点
for i=2:2:length(z1)
   z1(i)=0; 
end
z1(z1==0)=[];
z2 = zeros(length(z1)-1,1);
for i=1:length(z1)-1
   z2(i)=z1(end-i); 
end
z = [z1;z2];

% SC变换
p = polygon(z);
f = extermap(p);
s = prevertex(f);

% 绘图
figure(1)
plot(f)
figure(2)
plot(p)
hold on, axis equal
[theta,rho, X, Y]=ellipse(100,8,1.4,1.4,4.4);
plot(eval(f,1./(X+1i*Y)),'k')
plot(eval(f,1./(Y+1i*X)),'k')
% figure(3)
% [X,Y] = meshgrid((-0.5:0.1:1.5),(-0.5:0.1:1.5));
% plot(1./evalinv(f,X+1i*Y),'k')
% hold on, axis equal
% plot(1./evalinv(f,Y+1i*X),'k')
% plot(exp(1i*linspace(0,2*pi)),'m','LineWidth',1);
% plot(complex(z),'ro','LineWidth',1)
