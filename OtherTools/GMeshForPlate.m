%% Mesh for flexible plate
format long
%% Define Parameters
% size parameters
lengthx = 1.00;
lengthy = 1.00;
npointx = 21;
npointy = 21;
% mesh size
gmesh   = [1.00, 1.00, 1.00, 1.00]; % left, down, right, upper
dx      = lengthx / (npointx - 1);
dy      = lengthy / (npointy - 1);
npoints = (npointx + npointy - 2) * 2;
coor    = zeros(npoints,3);
pointsB = [1,(npointy+1)/2+1,(npointy+1)/2+npointx,(npointy+1)/2+npointx+npointy-1,(npointy+1)/2+2*npointx+npointy-2];
pointsE = [(npointy+1)/2,(npointy+1)/2+npointx-1,(npointy+1)/2+npointx+npointy-2,(npointy+1)/2+2*npointx+npointy-3,npoints];
% calculate coordinates
coor(pointsB(1):pointsE(1), 1) = 0;
coor(pointsB(2):pointsE(2), 1) = (dx:dx:lengthx);
coor(pointsB(3):pointsE(3), 1) = lengthx;
coor(pointsB(4):pointsE(4), 1) = (lengthx-dx:-dx:0);
coor(pointsB(5):pointsE(5), 1) = 0;

coor(pointsB(1):pointsE(1), 2) = (0:dy:lengthy/2);
coor(pointsB(2):pointsE(2), 2) = lengthy/2;
coor(pointsB(3):pointsE(3), 2) = (lengthy/2-dy:-dy:-lengthy/2);
coor(pointsB(4):pointsE(4), 2) = -lengthy/2;
coor(pointsB(5):pointsE(5), 2) = (-lengthy/2+dy:dy:-dy);
% write points  =====================================================================================
writedata = 'G:\WorkingFile\DataTools\PostForce\OtherTools\Plate.geo';
file = fopen(writedata,'w');
fprintf(file,'// gmesh file for flapping plate\n\n');
for i=pointsB(1):pointsE(1)
    fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f,%.6f};\n',i,coor(i,1),coor(i,2),coor(i,3),gmesh(1)); 
end
for i=pointsB(2):pointsE(2)
    fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f,%.6f};\n',i,coor(i,1),coor(i,2),coor(i,3),gmesh(2)); 
end
for i=pointsB(3):pointsE(3)
    fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f,%.6f};\n',i,coor(i,1),coor(i,2),coor(i,3),gmesh(3)); 
end
for i=pointsB(4):pointsE(4)
    fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f,%.6f};\n',i,coor(i,1),coor(i,2),coor(i,3),gmesh(4)); 
end
for i=pointsB(5):pointsE(5)
    fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f,%.6f};\n',i,coor(i,1),coor(i,2),coor(i,3),gmesh(1)); 
end
% write lines   =====================================================================================
for i=1:(npoints-1)
    fprintf(file,'Line(%d) = {%d,%d};\n',i,i,i+1); 
end
fprintf(file,'Line(%d) = {%d,%d};\n\n',npoints,npoints,1);
% write line loops   ================================================================================
fprintf(file,'Line Loop(1) = {');
for i=1:(npoints-1)
    fprintf(file,'%d,',i); 
end
fprintf(file,'%d};\n\n',npoints);
% write physical lines and surfaces   ===============================================================
% left
fprintf(file,'Physical Line(1)= {');
for i=pointsB(5)-1:pointsE(5)
    fprintf(file,'%d,',i); 
end
for i=pointsB(1):pointsE(1)-2
    fprintf(file,'%d,',i); 
end
fprintf(file,'%d};\n',pointsE(1)-1);
% down
fprintf(file,'Physical Line(2)= {');
for i=pointsB(2)-1:pointsE(2)-2
    fprintf(file,'%d,',i); 
end
fprintf(file,'%d};\n',pointsE(2)-1);
% right
fprintf(file,'Physical Line(3)= {');
for i=pointsB(3)-1:pointsE(3)-2
    fprintf(file,'%d,',i); 
end
fprintf(file,'%d};\n',pointsE(3)-1);
% top
fprintf(file,'Physical Line(4)= {');
for i=pointsB(4)-1:pointsE(4)-2
    fprintf(file,'%d,',i); 
end
fprintf(file,'%d};\n',pointsE(4)-1);
fprintf(file,'\nPlane Surface(5) = {1};\n');
fprintf(file,'\nPhysical Surface(6) = {5};\n');
fprintf(file,'\nPrint.JpegSmoothing = 1;\n');
fclose all;
