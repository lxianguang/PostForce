run A_ParamtersDefine.m
%% Define Parameters
% domian size
halfheight = 0.02;  % two mesh length
walldx     = 0.01;  % the grid space of the wall (if isNearWall = 1) 
wallY      = 0.00;  % the y position of the wall (if isNearWall = 1) 
sideLen    = [2.00, 8.00, 2.50, 2.50]; % Calculation domain range based on the head point of the solid(left,right,down,upper length)
% outer grid space
boundarydx = [0.20, 0.20, 0.20, 0.20]; % the grid space of the outer boundaries in gmesh files  (down, right, upper, left)
louter     = [0.06, 0.10, 0.06, 0.06]; % the grid refinement parameters of the outer boundaries (down, right, upper, left)
% inner mesh size
linner     = 0.10 ;                    % the grid space of the solid boundaries
% =============================================================================
%% Creat folders
fileAndFolderSet(casePath, par, isNearWall)
subdir      = dir([casePath par 'DatBody']);
subdir(1:2) = [];
%% Change Laplace Solve Parameters
copyfile(['.' par 'Scripts' par 'Universal' par 'LaplaceSolve.sh'] ,[casePath par 'DatGeo' par 'LaplaceSolve.sh']);
rewritefile([casePath par 'DatGeo' par 'LaplaceSolve.sh'],5 ,num2str(size(subdir,1)));
for num=1:size(subdir,1)
   %% Load Plate Data
    filename = subdir(num).name;
    readfile = [casePath par 'DatBody' par filename];
    data     = importdata(readfile).data;
    coor     = [data(:,1) data(:,2) data(:,5) data(:,6)]; % x, y, ax, ay
    % get the figure outline of flapping plate
    [index,ninner,innerpoints] = linetopolygon(coor,halfheight,bodyType); % 0 closed body, 1 line
    % define domain
    sidepoints  = [sum(sideLen(1:2)),sum(sideLen(3:4)),sum(sideLen(1:2)),sum(sideLen(3:4))]./boundarydx;
    npoints     = sum(sidepoints);
    outerpoints = zeros(npoints,2);
    midnum      = floor(size(coor,1)/2)+1;
    xmin        = coor(midnum,1) - sideLen(1);
    xmax        = coor(midnum,1) + sideLen(2);
    if isNearWall==1
        ymin = wallY + halfheight;
        ymax = ymin  + sum(sideLen(3:4));
    else
        if bodyType==2
            ymin = coor(midnum,2) - sideLen(3);
            ymax = coor(midnum,2) + sideLen(4);
        else
            ymin = coor(1,2) - sideLen(3);
            ymax = coor(1,2) + sideLen(4);
        end
    end
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
    meshname   = fileNumberGet(num,'Mesh','Mesh','.geo');
    writedata1 = [casePath par 'DatGeo' par meshname];
    file       = fopen(writedata1,'w');
    fprintf(file,'// gmesh file for solid body file\n\n');
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
    for i=1:ninner
        k = i + npoints;
        fprintf(file,'Point(%d) = {%.6f,%.6f,0.0,%.6f};\n',k,innerpoints(i,1),innerpoints(i,2),linner   ); 
    end
    fprintf(file,'\n');
    % write lines   =====================================================================================
    for i=1:(npoints-1)
        fprintf(file,'Line(%d) = {%d,%d};\n',i,i,i+1); 
    end
    fprintf(file,'Line(%d) = {%d,%d};\n\n',npoints,npoints,1);
    for i=1:(ninner-1)
        k = i + npoints;
        fprintf(file,'Line(%d) = {%d,%d};\n',k,k,k+1); 
    end
    fprintf(file,'Line(%d) = {%d,%d};\n\n',npoints+ninner,npoints+ninner,npoints+1);
    % write line loops   ================================================================================
    fprintf(file,'Line Loop(1) = {');
    for i=1:(npoints-1)
        fprintf(file,'%d,',i); 
    end
    fprintf(file,'%d};\n',npoints);
    fprintf(file,'Line Loop(2) = {');
    for i=1:(ninner-1)
        k = i + npoints;
        fprintf(file,'%d,',k); 
    end
    fprintf(file,'%d};\n\n',npoints+ninner);
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
    fprintf(file,'%d};\n\n',sum(sidepoints(1:3)));
    % ===================================================================================================
    % inner line
    fprintf(file,'Physical Line(5)= {');
    for i=1:(ninner-1)
        k = i + npoints;
        fprintf(file,'%d,',k); 
    end
    fprintf(file,'%d};\n\n',ninner+npoints);
    % plane surface =====================================================================================
    fprintf(file,'Plane Surface(6) = {1,2};\n');
    fprintf(file,'Physical Surface(6) = {6};\n');
    %fprintf(file,'\nRecombine Surface {6};\nMesh.RecombinationAlgorithm = 1;\n');
    fprintf(file,'\nPrint.JpegSmoothing = 1;\n');
    fclose all;
    %% Renew Script
    [bashname,~] = fileNumberGet(num,'','','');
    npointx = sum(sideLen(1:2))/halfheight*2 + 1;
    npointy = sum(sideLen(3:4))/halfheight*2 + 1;
    scope   = [num2str(npointx) ',' num2str(npointy) ',' num2str(xmin) ',' num2str(ymin) ',0' ',' num2str(xmax) ',' num2str(ymax) ',0'];
    content = ['mpirun -np 64 FieldConvert -m interppoints:plane=' scope ':fromxml=Mesh&.xml,LaplaceSet.xml:fromfld=Mesh&.fld PhiVortex&.plt -f >> log.txt'];
    file    = fopen([casePath par 'DatGeo' par 'LaplaceSolve.sh'],'a+');
    fprintf(file,strrep(content,'&',bashname));
    fprintf(file,'\n');
    fclose(file);
    %% Write Bounday Normal Vector
    verts = innerpoints(:,1) + innerpoints(:,2)*1i;
    dnorm = normalvector(verts);
    % write data
    boundaryname = fileNumberGet(num,'Boundary','Boundary','.plt');
    writedata2 = [casePath par 'DatPhi' par boundaryname];
    file=fopen(writedata2,'w');
    fprintf(file,'VARIABLES=\"X\",\"Y\",\"nx\",\"ny\",\"ax\",\"ay\"\n');
    fprintf(file,'ZONE    F=POINT\n');
    fprintf(file,'I=%d,   J=%d\n',length(verts),1);
    for i=1:length(verts)
        fprintf(file,'%6f    %6f    %6f    %6f    %6f    %6f\n',innerpoints(i,1),innerpoints(i,2),real(dnorm(i)),imag(dnorm(i)),coor(index(i),3),coor(index(i),4));
    end
    fclose(file);
   %% write wall mesh data
    if isNearWall==1
        lenx = sum(sideLen(1:2))/walldx;
        wallpoints      = zeros(lenx,2);
        wallpoints(:,1) = (xmin:walldx:(xmax - walldx));
        wallpoints(:,2) = ymin;
        [wallname,~] = filenameget(num,'Wall','Wall','.plt');
        writedata3 = [casePath par 'DatPhi' par wallname];
        file=fopen(writedata3,'w');
        fprintf(file,'VARIABLES=\"X\",\"Y\",\"nx\",\"ny\",\"ax\",\"ay\"\n');
        fprintf(file,'ZONE    F=POINT\n');
        fprintf(file,'I=%d,   J=%d\n',lenx,1);
        for i=1:lenx
            fprintf(file,'%6f    %6f    %6f    %6f    %6f    %6f\n', wallpoints(i,1), wallpoints(i,2),0,1,0,0);
        end
    end
    %% write interplot points
    [pointname,~] = fileNumberGet(num,'points','points','.pts');
    writedata4 = [casePath par 'DatGeo' par pointname];
    file=fopen(writedata4,'w');
    fprintf(file,'<?xml version=''1.0'' encoding=''utf-8''?>\n');
    fprintf(file,'<NEKTAR>\n');
    fprintf(file,'  <POINTS DIM=''3'' FIELDS=''''>\n');
    for i=1:length(verts)
        fprintf(file,'      %6f   %6f   %6f\n',innerpoints(i,1),innerpoints(i,2),0.0);
    end
    fprintf(file,'  </POINTS>\n');
    fprintf(file,'</NEKTAR>\n');
    fclose all;
end
copyfile('B_GMeshForLaplace.m',[casePath par 'DatGeo' par 'B_GMeshForLaplace.m']);
fprintf ('Case Pre-postprocessing Ready: %s\n',casePath);
fprintf ('*******************************************************************\n');