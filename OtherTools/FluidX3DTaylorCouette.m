clc
clear
%% parameters
u  = 0.1;
R1 = 64.;
R2 = 128;
r1 = (0:1:R2-R1);
r2 = (R2-R1+1:1:R2+R1-1);
r3 = (R2+R1:1:2*R2);
%% calcaute
u1 = (-u*(R2-r1)./R1+4*u*R1./(R2-r1))/3;
u2 = zeros(size(r2));
u3 = (-u*(r3-R2)./R1+4*u*R1./(r3-R2))/3;
%% plot
r  = [r1 r2 r3]-R2;
u  = [u1 u2 u3];
plot(r,u,'k','LineWidth',2.0,'LineStyle','-');
%% Write Data
filename = '.\Scripts\FuildX3dTaylorCouette.dat';
file=fopen(filename,'w');
fprintf(file,'VARIABLES="r","u"\n');
for i=1:length(r)
    fprintf(file,'%10f    %10f\n',r(i),u(i));
end
fclose all;