clc;
close all;
clear;
r0 = 0.500;
r1 = 3.000;
path = 'G:\Data\ShearPlate\Force\FixedPlate';
%% Write Integral Boundary
[~,~,~,~,X,Y] = ellipsemesh(1800,0,r0,r0,r0); 
[lenx, leny] = size((X+1i*Y));
file=fopen([path '\DatBoundary.dat'],'w');
fprintf(file,'VARIABLES=\"X\",\"Y\",\"nx\",\"ny\",\"Phix\",\"Phiy\"\n');
fprintf(file,'ZONE    F=POINT\n');
fprintf(file,'I=%d,   J=%d\n',lenx,leny);
for j=1:leny
    for i=1:lenx
        phix = X(i,j)/(X(i,j)^2+Y(i,j)^2)*r0*r0;
        phiy = Y(i,j)/(X(i,j)^2+Y(i,j)^2)*r0*r0;
        fprintf(file,'%6f    %6f    %6f    %6f    %6f    %6f\n',X(i,j),Y(i,j),2*X(i,j),2*Y(i,j),phix,phiy);
    end
end
fclose(file);
% Write Volume Mesh
[~,~,~,~,X,Y] = ellipsemesh(360,300,r0,r0,r1); 
[lenx, leny] = size((X+1i*Y));
file=fopen([path '\DatVortexPhi.dat'],'w');
fprintf(file,'VARIABLES=\"X\",\"Y\",\"Phix\",\"Phiy\",\"Phi\"\n');
fprintf(file,'ZONE    F=POINT\n');
fprintf(file,'I=%d,   J=%d\n',lenx,leny);
for j=1:leny
    for i=1:lenx
        phix = X(i,j)/(X(i,j)^2+Y(i,j)^2)*r0*r0;
        phiy = Y(i,j)/(X(i,j)^2+Y(i,j)^2)*r0*r0;
        fprintf(file,'%6f    %6f    %6f    %6f    %6f\n',X(i,j),Y(i,j),phix,phiy,abs(phix+1i*phiy));
    end
end
fclose all;