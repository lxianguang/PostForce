%% Velocity Curve Fitting
clear;clc;
% =============================================  flapping plate near flaps
% syms t;
% D1 = [0.0000; 0.2500; 0.5000; 0.7500; 1.0000];
% Y1 = [0.2145; 0.1526; 0.1219; 0.0932; 0.0626];
% D2 = [0.0000; 0.2500; 0.5000; 0.7500; 1.0000; 99999.];
% Y2 = [0.2145; 0.1526; 0.1219; 0.0932; 0.0626; 0.0000];
% 
% f  = fittype('a*exp(k*t)','independent','t','coefficients',{'a','k'}); 
% 
% P  = fit(D2,Y2,f,'Lower',[-100,-100],'Upper',[100,100],'StartPoint',[1, -1]);
% D  = 0:0.1:1;
% Y  = P(D);
% plot(D1,Y1,'o')
% hold on
% plot(D,Y,'-')
% ====================================  velocity profile behind a cylinder

filePath = 'G:\OpenFOAM-v2306\oversetMesh\wingMotion\cylinder\VTK\velocityProfile\ProfileX1.00.txt';
fileData = importdata(filePath);
y = fileData(:,1);
u = fileData(:,2);
fprintf('==============================================================\n')
fprintf('{')
for i = 1:size(y,1)-1
    fprintf('%f,',y(i))
    if mod(i,10)==0
        fprintf('\\\n')
    end
end
fprintf('%f',y(end))
fprintf('}\n')
fprintf('==============================================================\n')
fprintf('{')
for i = 1:size(y,1)-1
    fprintf('%f,',u(i))
    if mod(i,10)==0
        fprintf('\\\n')
    end
end
fprintf('%f',u(end))
fprintf('}\n')
fprintf('==============================================================\n')
yt = (-2.90:0.01:2.90);
for i = 1:length(yt)
    for j = 1:size(y,1)-1
        if y(j)<=yt(i)&&y(j+1)>=yt(i)
            ut(i) = u(j)+(u(j+1)-u(j))*(yt(i)-y(j))/(y(j+1)-y(j));
        end
    end
end
plot(y,u,'r',yt,ut,'b*')