clc;
close all;
clear;
r0 = 1.00;
r1 = 4.00;
halfheight = 0.02;
centerx = 0.00;
centery = 0.50;
path = 'G:\WorkingFile\MyPapers\Picture11';
%% Write Integral Boundary
% [~,~,~,~,X,Y] = ellipsemesh(1800,0,r0,r0,r0); 
% [lenx, leny] = size((X+1i*Y));
% file=fopen([path '\DatBoundary.dat'],'w');
% fprintf(file,'VARIABLES=\"X\",\"Y\",\"nx\",\"ny\",\"Phix\",\"Phiy\"\n');
% fprintf(file,'ZONE    F=POINT\n');
% fprintf(file,'I=%d,   J=%d\n',lenx,leny);
% for j=1:leny
%     for i=1:lenx
%         phix = X(i,j)/(X(i,j)^2+Y(i,j)^2)*r0*r0;
%         phiy = Y(i,j)/(X(i,j)^2+Y(i,j)^2)*r0*r0;
%         fprintf(file,'%6f    %6f    %6f    %6f    %6f    %6f\n',X(i,j)+centerx,Y(i,j)+centery,2*X(i,j),2*Y(i,j),phix,phiy);
%     end
% end
% fclose(file);
% Write Volume Mesh


readfile = 'G:\WorkingFile\MyPapers\Picture11\Body0023.56190_001.dat';
data0 = importdata(readfile).data;
data = [data0(:,1) data0(:,2) data0(:,5) data0(:,6)]; % x, y, ax, ay
curvetype = 1; %1 line segments, 0 closed curve
[vertices, dataindex] = linetopolygon(data, curvetype, halfheight); % in counter clockwise
p = polygon(vertices);
f = extermap(p);
C = f.constant;

%% Write Integral Vortex Phi
% Coordinate Transformation And Caculate 
[~,~,~,~,X,Y] = ellipsemesh(120,20,r0,r0,r1);  % Crea circle grid mesh in mapping domain
zeta1 = X+1i*Y;
[lenx,leny]=size(zeta1);
xi1 = xi2zeta(zeta1);
z1 = zeros(lenx, leny);
% z = eval(f,xi)  It will disturb the order
for k = 1:leny
    z1(:,k) = eval(f,xi1(:,k));
end
phix = complexpotential(zeta1, z1, C, 1);
phiy = complexpotential(zeta1, z1, C, 1i);
phi = abs(phix+1i*phiy);
% Writing Data
file=fopen([path '\DatVortexPhi_Plate.dat'],'w');
fprintf(file,'VARIABLES=\"X\",\"Y\",\"Phix\",\"Phiy\",\"phi\"\n');
fprintf(file,'ZONE    F=POINT\n');
fprintf(file,'I=%d,   J=%d\n',lenx,leny);
for j=1:leny
    for i=1:lenx
        fprintf(file,'%6f    %6f    %6f    %6f    %6f\n',real(z1(i,j)),imag(z1(i,j)),phix(i,j),phiy(i,j),phi(i,j));
    end
end
fclose(file);



% [~,~,~,~,X,Y] = ellipsemesh(120,20,r0,r0,r1); 
% [lenx, leny] = size((X+1i*Y));
% file=fopen([path '\DatVortexPhi.dat'],'w');
% fprintf(file,'VARIABLES=\"X\",\"Y\",\"Phix\",\"Phiy\",\"Phi\"\n');
% fprintf(file,'ZONE    F=POINT\n');
% fprintf(file,'I=%d,   J=%d\n',lenx,leny);
% for j=1:leny
%     for i=1:lenx
%         phix = X(i,j)/(X(i,j)^2+Y(i,j)^2)*r0*r0;
%         phiy = Y(i,j)/(X(i,j)^2+Y(i,j)^2)*r0*r0;
%         fprintf(file,'%6f    %6f    %6f    %6f    %6f\n',X(i,j)+centerx,Y(i,j)+centery,phix,phiy,abs(phix+1i*phiy));
%     end
% end
% fclose all;