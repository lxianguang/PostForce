clc
clear
run GMeshForPlate.m
close all
%% Mesh File Of Flexible Plate For LBM Calculation
fileread = fopen('.\Scripts\Plate.msh');
while ~feof(fileread)
   line = fgetl(fileread);
   if strncmp(line, '$Entities',9)
        line1 = fgetl(fileread);
   end
   if strncmp(line, '$Nodes',   6)
        line2 = fgetl(fileread);
   end
   if strncmp(line, '$Elements',9)
        line3 = fgetl(fileread);
   break
   end
end
num1 = str2num(line1);
num2 = str2num(line2);
num3 = str2num(line3);
num  = [num1(2) num2(2) num3(2)-num1(2)];
% get coordinate of nodes
points   = zeros(num(2), 4);
frewind(fileread)
while ~feof(fileread)
    line = fgetl(fileread);
    if strncmp(line, '$Entities',    9)
        line = fgetl(fileread);
        for i=1:num(1)
            line = fgetl(fileread);
            coor1 = str2num(line);
            points(i,:) = coor1(1:4);
        end
    end
    if strncmp(line, num2str(num(2)),ceil(log10(num(2))))
        for i=num(1)+1:num(2)
            line = fgetl(fileread);
            coor1 = str2num(line);
            points(i,1)     = i;
            points(i,2:end) = coor1;
        end
        break
    end
end
% get elements number
elements = zeros(num(3), 6); 
frewind(fileread)
while ~feof(fileread)
    line = fgetl(fileread);
    if strncmp(line, '$Elements',9)
        fgetl(fileread);
    break
    end
end

while ~feof(fileread)
    line = fgetl(fileread);
    if strncmp(line, num2str(num(1)+1),ceil(log10(num(1))))
        for i=1:num(3)
            coor1 = str2num(line);
            elements(i,1)     = i;
            elements(i,2:4)   = coor1(2:4);
            elements(i,5)     = 3;
            elements(i,6)     = 1;
            line = fgetl(fileread);
        end
        break
    end
end
fclose(fileread);
% leading edge points
edges = zeros(npointy,4);
edges(1:floor(npointy/2)+1  ,1)   = 1:1:floor(npointy/2)+1;
edges(floor(npointy/2)+2:end,1)   = npoints-floor(npointy/2)+1:1:npoints;
edges(1:floor(npointy/2)+1  ,2:4) = coor(1:floor(npointy/2)+1      ,:);
edges(floor(npointy/2)+2:end,2:4) = coor(end-floor(npointy/2)+1:end,:);
% write mesh file
filename = '.\Scripts\Plate.dat';
file=fopen(filename,'w');
fprintf(file,'    FLAG\n');
fprintf(file,'    %d    %d    %d\n',num(2),num(3),1);
fprintf(file,'    END\n');
fprintf(file,'    %d      X           Y          Z\n',num(2));
for i=1:num(2)
    fprintf(file,'    %d    %10f    %10f    %10f\n',points(i,1),points(i,2),points(i,3),points(i,4));
end
fprintf(file,'    END\n');
fprintf(file,'    %d    I    J    K    TYPE    MAT\n',num(3));
for i=1:num(3)
    fprintf(file,'    %d    %d    %d    %d    %d    %d\n',elements(i,1),elements(i,2),elements(i,3),elements(i,4),elements(i,5),elements(i,6));
end
fprintf(file,'    END\n');
fprintf(file,'    %d  XTRA  YTRA  ZTRA  XROT  YROT  ZROT\n',npointy);
for i=1:npointy
    fprintf(file,'    %d    %d    %d    %d    %d    %d    %d\n',edges(i,1),1,2,3,4,5,6);
end
fprintf(file,'    END\n');
fprintf(file,'    %d        E            G            h           RHO        GAMMA          Ix         ALPHA         BETA\n',1);
fprintf(file,'    1    0.100D+01    0.100D+01    0.100D+01    0.100D+01    0.100D+01    0.100D+01    0.150D+01    0.500D+00\n');
fprintf(file,'    END\n');
fclose(file);
% plot points
figure(2)
plot(points(:,2),points(:,3),'*')
hold on
plot(coor(:,1)  ,coor(:,2),'r')
plot(edges(:,2),edges(:,3),'ko','MarkerFaceColor','k')
axis equal