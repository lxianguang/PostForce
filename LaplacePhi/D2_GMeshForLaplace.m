%% Mesh for two bodies
format long
run C_DataAveraging.m
%% Define Parameters
% domian size
halfheight = 0.02;
sideninnerpoint1    = [10.0, 20.0, 6.00, 6.00]; % Range based on head point(left,right,down,upper length)
% outer grid space and size
boundarydx = [1.00, 0.50, 0.20, 0.50]; % down, right, upper, left boundary(outer)
louter     = [1.00, 0.50, 0.20, 0.50]; % down, right, upper, left boundary(outer)
% inner mesh size 1
linner1    = [0.10, 0.10, 0.10, 0.10]; % down, right, upper, left boundary(inner)
% inner mesh size 2
linner2    = [0.10, 0.10, 0.10, 0.10]; % down, right, upper, left boundary(inner)
for kk=1:size(FileList,1)
    fprintf('%s\n',FileList(kk,:));
    FilePath = [MkdirPath par FileList(kk,:)];
    subdir=dir([FilePath par 'DatBodyS']);
    subdir(1:2) = [];
    for num=1:size(subdir,1)/2
        %% Load Plate Data
        fininnerpoint1ame1 = subdir(2*num-1).name;
        fininnerpoint1ame2 = subdir(2*num  ).name;
        readfile1 = [FilePath par 'DatBodyS' par fininnerpoint1ame1];
        readfile2 = [FilePath par 'DatBodyS' par fininnerpoint1ame2];
        data1     = importdata(readfile1).data;
        data2     = importdata(readfile2).data;
        coor1     = [data1(:,1) data1(:,2) data1(:,5) data1(:,6)]; % x, y, ax, ay
        coor2     = [data2(:,1) data2(:,2) data2(:,5) data2(:,6)];
        % get the figure outline of flapping plate
        [index1,nx1,ny1,innerpoints1] = linetopolygon(coor1,halfheight,0); % 0 closed body, 1 line
        [index2,nx2,ny2,innerpoints2] = linetopolygon(coor2,halfheight,1);
        ninnerpoint1  = size(innerpoints1,1);
        ninnerpoint2  = size(innerpoints2,1);
        % define domain
        sidepoints  = [sum(sideninnerpoint1(1:2)),sum(sideninnerpoint1(3:4)),sum(sideninnerpoint1(1:2)),sum(sideninnerpoint1(3:4))]./boundarydx;
        nouterpoint = sum(sidepoints);
        outerpoints = zeros(nouterpoint,2);
        % coor(:,1) = coor(:,1) - coor(1,1);
        % coor(:,2) = coor(:,2) - coor(1,2);
        xmin = coor1(1,1) - sideninnerpoint1(1);
        xmax = coor1(1,1) + sideninnerpoint1(2);
        ymin = coor1(1,2) - sideninnerpoint1(3);
        ymax = coor1(1,2) + sideninnerpoint1(4);
        % get outer boundary points' coordinates
        outerpoints( 1                      :sidepoints(1)        ,1) = (xmin: boundarydx(1):(xmax-boundarydx(1)));
        outerpoints((sidepoints(1)+1)       :sum(sidepoints(1:2)) ,1) =  xmax;
        outerpoints((sum(sidepoints(1:2))+1):sum(sidepoints(1:3)) ,1) = (xmax:-boundarydx(3):(xmin+boundarydx(3)));
        outerpoints((sum(sidepoints(1:3))+1):sum(sidepoints)      ,1) =  xmin;
        outerpoints( 1                      :sidepoints(1)        ,2) =  ymin;
        outerpoints((sidepoints(1)+1)       :sum(sidepoints(1:2)) ,2) = (ymin: boundarydx(2):(ymax-boundarydx(2)));
        outerpoints((sum(sidepoints(1:2))+1):sum(sidepoints(1:3)) ,2) =  ymax;
        outerpoints((sum(sidepoints(1:3))+1):sum(sidepoints)      ,2) = (ymax:-boundarydx(4):(ymin+boundarydx(4)));
        %% Write Gmesh *.geo File
        if num<10
            outfile = ['00' num2str(num)];
        elseif num<100
            outfile = ['0'  num2str(num)];
        else
            outfile =       num2str(num) ;  
        end
        writedata = [FilePath par 'DatGeo' par 'Mesh' outfile '.geo'];
        file = fopen(writedata,'w');
        fprintf(file,'// gmesh file for flapping plate\n\n');
        % write points  =====================================================================================
        % outerpoints
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
        % innerpoints1
        for i=1:nx1
            k = i + nouterpoint;
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints1(i,1),innerpoints1(i,2),linner1(1)); 
        end
        for i=(nx1+1):(nx1+ny1)
            k = i + nouterpoint;
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints1(i,1),innerpoints1(i,2),linner1(2)); 
        end
        for i=(nx1+ny1+1):(2*nx1+ny1)
            k = i + nouterpoint;
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints1(i,1),innerpoints1(i,2),linner1(3)); 
        end
        for i=(2*nx1+ny1+1):(2*nx1+2*ny1)
            k = i + nouterpoint;
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints1(i,1),innerpoints1(i,2),linner1(4)); 
        end
        fprintf(file,'\n');
        % innerpoints2
        for i=1:nx2
            k = i + nouterpoint + ninnerpoint1;
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints2(i,1),innerpoints2(i,2),linner2(1)); 
        end
        for i=(nx2+1):(nx2+ny2)
            k = i + nouterpoint + ninnerpoint1;
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints2(i,1),innerpoints2(i,2),linner2(2)); 
        end
        for i=(nx2+ny2+1):(2*nx2+ny2)
            k = i + nouterpoint + ninnerpoint1;
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints2(i,1),innerpoints2(i,2),linner2(3)); 
        end
        for i=(2*nx2+ny2+1):(2*nx2+2*ny2)
            k = i + nouterpoint + ninnerpoint1;
            fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints2(i,1),innerpoints2(i,2),linner2(4)); 
        end
        fprintf(file,'\n');
        % write lines   =====================================================================================
        % outerline
        for i=1:(nouterpoint-1)
            fprintf(file,'Line(%d) = {%d,%d};\n',i,i,i+1); 
        end
        fprintf(file,'Line(%d) = {%d,%d};\n\n',nouterpoint,nouterpoint,1);
        % innerline1
        for i=1:(ninnerpoint1-1)
            k = i + nouterpoint;
            fprintf(file,'Line(%d) = {%d,%d};\n',k,k,k+1); 
        end
        fprintf(file,'Line(%d) = {%d,%d};\n\n',nouterpoint+ninnerpoint1,nouterpoint+ninnerpoint1,nouterpoint+1);
        % innerline2
        for i=1:(ninnerpoint2-1)
            k = i + nouterpoint + ninnerpoint1;
            fprintf(file,'Line(%d) = {%d,%d};\n',k,k,k+1); 
        end
        fprintf(file,'Line(%d) = {%d,%d};\n\n',nouterpoint+ninnerpoint1+ninnerpoint2,nouterpoint+ninnerpoint1+ninnerpoint2,nouterpoint+ninnerpoint1+1);
        % write line loops   ================================================================================
        % outerloop
        fprintf(file,'Line Loop(1) = {');
        for i=1:(nouterpoint-1)
            fprintf(file,'%d,',i); 
        end
        fprintf(file,'%d};\n',nouterpoint);
        % innerloop1
        fprintf(file,'Line Loop(2) = {');
        for i=1:(ninnerpoint1-1)
            k = i + nouterpoint;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n',nouterpoint + ninnerpoint1);
        % innerloop2
        fprintf(file,'Line Loop(3) = {');
        for i=1:(ninnerpoint2-1)
            k = i + nouterpoint + ninnerpoint1;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n\n',nouterpoint + ninnerpoint1 + ninnerpoint2);
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
        % inner1 left
        fprintf(file,'Physical Line(5)= {');
        for i=(2*nx1+ny1+1):(2*nx1+2*ny1-1)
            k = i + nouterpoint;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n',2*nx1+2*ny1+nouterpoint);
        % inner1 right
        fprintf(file,'Physical Line(6)= {');
        for i=(nx1+1):(nx1+ny1-1)
            k = i + nouterpoint;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n',nx1+ny1+nouterpoint);
        % inner1 down
        fprintf(file,'Physical Line(7)= {');
        for i=1:(nx1-1)
            k = i + nouterpoint;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n',nx1+nouterpoint);
        % inner1 upper
        fprintf(file,'Physical Line(8)= {');
        for i=(nx1+ny1+1):(2*nx1+ny1-1)
            k = i + nouterpoint;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n',2*nx1+ny1+nouterpoint);
        % ===================================================================================================
        % inner2 left
        fprintf(file,'Physical Line(9)= {');
        for i=(2*nx2+ny2+1):(2*nx2+2*ny2-1)
            k = i + nouterpoint + ninnerpoint1;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n',2*nx2+2*ny2+nouterpoint+ninnerpoint1);
        % inner2 right
        fprintf(file,'Physical Line(10)= {');
        for i=(nx2+1):(nx2+ny2-1)
            k = i + nouterpoint + ninnerpoint1;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n',nx2+ny2+nouterpoint+ninnerpoint1);
        % inner2 down
        fprintf(file,'Physical Line(11)= {');
        for i=1:(nx2-1)
            k = i + nouterpoint + ninnerpoint1;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n',nx2+nouterpoint+ninnerpoint1);
        % inner2 upper
        fprintf(file,'Physical Line(12)= {');
        for i=(nx2+ny2+1):(2*nx2+ny2-1)
            k = i + nouterpoint + ninnerpoint1;
            fprintf(file,'%d,',k); 
        end
        fprintf(file,'%d};\n\n',2*nx2+ny2+nouterpoint+ninnerpoint1);
        % plane surface =====================================================================================
        fprintf(file,'Plane Surface(13) = {1,2,3};\n');
        fprintf(file,'Physical Surface(14) = {13};\n');
        %fprintf(file,'\nRecombine Surface {14};\nMesh.RecombinationAlgorithm = 1;\n');
        fprintf(file,'\nPrint.JpegSmoothing = 1;\n');
        fclose all;
       %% Write Bounday Normal Vector
        vert1 = innerpoints1(:,1) + innerpoints1(:,2)*1i;
        vert2 = innerpoints2(:,1) + innerpoints2(:,2)*1i;
        ninnerpoint1v1 = length(vert1);
        ninnerpoint1v2 = length(vert2);
        dz1   = [vert1(2:1:ninnerpoint1v1) - vert1(1:1:ninnerpoint1v1-1); vert1(1)-vert1(ninnerpoint1v1)];
        dz2   = [vert2(2:1:ninnerpoint1v2) - vert2(1:1:ninnerpoint1v2-1); vert2(1)-vert2(ninnerpoint1v2)];
        norm1 = -1i*dz1./abs(dz1);
        norm2 = -1i*dz2./abs(dz2);
        % write data1
        writedata1 = [FilePath par 'DatPhi' par 'Boundary' outfile '.plt'];
        file=fopen(writedata1,'w');
        fprintf(file,'VARIABLES=\"X\",\"Y\",\"nx\",\"ny\",\"ax\",\"ay\"\n');
        fprintf(file,'ZONE    F=POINT\n');
        fprintf(file,'I=%d,   J=%d\n',ninnerpoint1v1,1);
        for i=1:ninnerpoint1v1
            fprintf(file,'%6f    %6f    %6f    %6f    %6f    %6f\n',innerpoints1(i,1),innerpoints1(i,2),real(norm1(i)),imag(norm1(i)),coor1(index1(i),3),coor1(index1(i),4));
        end
        % write data2
        writedata2 = [FilePath par 'DatPhi' par 'Boundary' outfile '_2.plt'];
        file=fopen(writedata2,'w');
        fprintf(file,'VARIABLES=\"X\",\"Y\",\"nx\",\"ny\",\"ax\",\"ay\"\n');
        fprintf(file,'ZONE    F=POINT\n');
        fprintf(file,'I=%d,   J=%d\n',ninnerpoint1v2,1);
        for i=1:ninnerpoint1v2
            fprintf(file,'%6f    %6f    %6f    %6f    %6f    %6f\n',innerpoints2(i,1),innerpoints2(i,2),real(norm2(i)),imag(norm2(i)),coor2(index2(i),3),coor2(index2(i),4));
        end
        fclose all;
    end
    fprintf('%s Mesh Ready   ============================================\n',FileList(kk,:));
end
fprintf('*******************************************************************\n');