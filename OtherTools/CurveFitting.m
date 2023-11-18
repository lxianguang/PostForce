%% Velocity Curve Fitting
clear;clc;
syms t;
D1 = [0.0000; 0.2500; 0.5000; 0.7500; 1.0000];
Y1 = [0.2145; 0.1526; 0.1219; 0.0932; 0.0626];
D2 = [0.0000; 0.2500; 0.5000; 0.7500; 1.0000; 99999.];
Y2 = [0.2145; 0.1526; 0.1219; 0.0932; 0.0626; 0.0000];

f  = fittype('a*exp(k*t)','independent','t','coefficients',{'a','k'}); 

P  = fit(D2,Y2,f,'Lower',[-100,-100],'Upper',[100,100],'StartPoint',[1, -1]);
D  = 0:0.1:1;
Y  = P(D);
plot(D1,Y1,'o')
hold on
plot(D,Y,'-')