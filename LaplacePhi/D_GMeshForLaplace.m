clc
clear
close all
run A_DefineFilePath.m
format long
%% Define Parameters
% domian size
halfheight = 0.02;
sidelen    = [2.00, 8.00, 2.50, 2.50]; % Range based on head point(left,right,down,upper length)
% grid space
boundarydx = [0.05, 0.20, 0.20, 0.20]; % down, right, upper, left boundary(outer)
% mesh size
louter     = [0.10, 0.20, 0.20, 0.20]; % down, right, upper, left boundary(outer)
linner     = [0.10, 0.10, 0.10, 0.10]; % down, right, upper, left boundary(inner)
for kk=1:size(FileList,1)
    fprintf('%s\n',FileList(kk,:));
    FilePath = [MkdirPath '\' FileList(kk,:)];
    subdir=dir([FilePath '\DatBodyN']);
    subdir(1:2) = [];
    for num=1:size(subdir,1)
        %% Load Plate Data
        filename = subdir(num).name;
        readfile = [FilePath '\DatBodyN\' filename];
        data     = importdata(readfile).data;
        coor     = [data(:,1) data(:,2) data(:,5) data(:,6)]; % x, y, ax, ay
        % define domain
        sidepoints  = [sum(sidelen(1:2)),sum(sidelen(3:4)),sum(sidelen(1:2)),sum(sidelen(3:4))]./boundarydx;
        npoints     = sum(sidepoints);
        outerpoints = zeros(npoints,2);
        % coor(:,1) = coor(:,1) - coor(1,1);
        % coor(:,2) = coor(:,2) - coor(1,2);
        xmin = coor(1,1) - sidelen(1);
        xmax = coor(1,1) + sidelen(2);
%         ymin = coor(1,2) - sidelen(3);
%         ymax = coor(1,2) + sidelen(4);
        ymin = 0;
        ymax = 5;
        % get outer boundary points' coordinates
        outerpoints( 1                      :sidepoints(1)        ,1) = (xmin: boundarydx(1):(xmax-boundarydx(1)));
        outerpoints((sidepoints(1)+1)       :sum(sidepoints(1:2)) ,1) =  xmax;
        outerpoints((sum(sidepoints(1:2))+1):sum(sidepoints(1:3)) ,1) = (xmax:-boundarydx(3):(xmin+boundarydx(3)));
        outerpoints((sum(sidepoints(1:3))+1):sum(sidepoints)      ,1) =  xmin;
        outerpoints( 1                      :sidepoints(1)        ,2) =  ymin;
        outerpoints((sidepoints(1)+1)       :sum(sidepoints(1:2)) ,2) = (ymin: boundarydx(2):(ymax-boundarydx(2)));
        outerpoints((sum(sidepoints(1:2))+1):sum(sidepoints(1:3)) ,2) =  ymax;
        outerpoints((sum(sidepoints(1:3))+1):sum(sidepoints)      ,2) = (ymax:-boundarydx(4):(ymin+boundarydx(4)));
        % get the figure outline of flapping plate
        [index,nx,ny,innerpoints] = linetopolygon(coor,halfheight);
        %% Write Gmesh *.geo File
        if num<10
            outfile = ['00' num2str(num)];
        elseif num<100
            outfile = ['0'  num2str(num)];
        else
            outfile =       num2str(num) ;  
        end
        writedata1 = [FilePath '\DatGeo\Mesh' outfile '.geo'];
        file = fopen(writedata1,'w');
        len  = size(innerpoints,1);
        fprintf(file,'// gmesh file for flapping plate\n\n');
        % write points  =====================================================================================
        for i=1:sidepoints(1)
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',i,outerpoints(i,1),outerpoints(i,2),louter(1)); 
        end
        for i=(sidepoints(1)+1):sum(sidepoints(1:2))
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',i,outerpoints(i,1),outerpoints(i,2),louter(2)); 
        end
        for i=(sum(sidepoints(1:2))+1):sum(sidepoints(1:3))
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',i,outerpoints(i,1),outerpoints(i,2),louter(3)); 
        end
        for i=(sum(sidepoints(1:3))+1):sum(sidepoints)
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',i,outerpoints(i,1),outerpoints(i,2),louter(4)); 
        end
        fprintf(file,'\n');
        for i=1:nx
            k = i + npoints;
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints(i,1),innerpoints(i,2),linner(1)); 
        end
        for i=(nx+1):(nx+ny)
            k = i + npoints;
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints(i,1),innerpoints(i,2),linner(2)); 
        end
        for i=(nx+ny+1):(2*nx+ny)
            k = i + npoints;
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints(i,1),innerpoints(i,2),linner(3)); 
        end
        for i=(2*nx+ny+1):(2*nx+2*ny)
            k = i + npoints;
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints(i,1),innerpoints(i,2),linner(4)); 
        end
        fprintf(file,'\n');
        % write lines   =====================================================================================
        for i=1:(npoints-1)
            fprintf(file,'Line(%d) = {%d,%d};\n',i,i,i+1); 
        end
        fprintf(file,'Line(%d) = {%d,%d};\n\n',npoints,npoints,1);
        for i=1:(len-1)
            k = i + npoints;
            fprintf(file,'Line(%d) = {%d,%d};\n',k,k,k+1); 
        end
        fprintf(file,'Line(%d) = {%d,%d};\n\n',npoints+len,npoints+len,npoints+1);
        % write line loops   ================================================================================
        fprintf(file,'Line Loop(1) = {');
        for i=1:(npoints-1)
            fprintf(file,'%d,',i); 
        end
        fprintf(file,'%d};\n',npoints);
        fprintf(file,'Line Loop(2) = {');
        for i=1:(len-1)
            k = i + npoints;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n\n',npoints+len);
        % write physical lines and surfaces   ===============================================================
        % out left
        fprintf(file,'Physical Line(1)= {');
        for i=(sum(sidepoints(1:3))+1):(sum(sidepoints(1:4))-1)
            fprintf(file,'%d,',i); 
        end
        fprintf(file,'%d};\n',sum(sidepoints(1:4)));
        % out right
        fprintf(file,'Physical Line(2)= {');
        for i=(sidepoints(1)+1):(sum(sidepoints(1:2))-1)
            fprintf(file,'%d,',i); 
        end
        fprintf(file,'%d};\n',sum(sidepoints(1:2)));
        % out down
        fprintf(file,'Physical Line(3)= {');
        for i=1:(sidepoints(1)-1)
            fprintf(file,'%d,',i); 
        end
        fprintf(file,'%d};\n',sidepoints(1));
        % out upper
        fprintf(file,'Physical Line(4)= {');
        for i=(sum(sidepoints(1:2))+1):(sum(sidepoints(1:3))-1)
            fprintf(file,'%d,',i); 
        end
        fprintf(file,'%d};\n',sum(sidepoints(1:3)));
        % ===================================================================================================
        % inner left
        fprintf(file,'Physical Line(5)= {');
        for i=(2*nx+ny+1):(2*nx+2*ny-1)
            k = i + npoints;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n',2*nx+2*ny+npoints);
        % inner right
        fprintf(file,'Physical Line(6)= {');
        for i=(nx+1):(nx+ny-1)
            k = i + npoints;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n',nx+ny+npoints);
        % inner down
        fprintf(file,'Physical Line(7)= {');
        for i=1:(nx-1)
            k = i + npoints;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n',nx+npoints);
        % inner upper
        fprintf(file,'Physical Line(8)= {');
        for i=(nx+ny+1):(2*nx+ny-1)
            k = i + npoints;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n\n',2*nx+ny+npoints);
        % plane surface =====================================================================================
        fprintf(file,'Plane Surface(9) = {1,2};\n');
        fprintf(file,'Physical Surface(9) = {9};\n');
        % fprintf(file,'\nRecombine Surface {644};\nMesh.RecombinationAlgorithm = 1;\n');
       %% Write Bounday Normal Vector
        vert = innerpoints(:,1) + innerpoints(:,2)*1i;
        lenv = length(vert);
        dz   = [vert(2:1:lenv) - vert(1:1:lenv-1); vert(1)-vert(lenv)];
        norm = -1i*dz./abs(dz);
        % write data
        writedata2 = [FilePath '\DatPhi\Boundary' outfile '.plt'];
        file=fopen(writedata2,'w');
        fprintf(file,'VARIABLES=\"X\",\"Y\",\"nx\",\"ny\",\"ax\",\"ay\"\n');
        fprintf(file,'ZONE    F=POINT\n');
        fprintf(file,'I=%d,   J=%d\n',lenv,1);
        for i=1:lenv
            fprintf(file,'%6f    %6f    %6f    %6f    %6f    %6f\n',innerpoints(i,1),innerpoints(i,2),real(norm(i)),imag(norm(i)),coor(index(i),3),coor(index(i),4));
        end
        fclose all;
    end
end
