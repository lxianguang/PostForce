%% Define Parameters
format long
run A_ParamtersDefine.m
run FileAndFolderSet.m
run SmoothAcceleration.m
% domian size
halfheight = 0.02;
walldx     = 0.01;
wallY      = 0.00;
sidelen    = [3.00, 12.0, 3.00, 3.00]; % Range based on the head point(left,right,down,upper length)
% outer grid space
boundarydx = [0.02, 0.10, 0.10, 0.10]; % down, right, upper, left boundary(outer)
louter     = [0.02, 0.10, 0.10, 0.10]; % down, right, upper, left boundary(outer)
% inner mesh size
linner     = 0.10 ; 
for kk=1:size(FileList,1)
    FilePath = [MkdirPath par FileList(kk,:)];
    subdir=dir([FilePath par 'DatBodyS']);
    subdir(1:2) = [];
    %% Change Laplace Solve Parameters
    copyfile(['.' par 'Scripts' par 'Universal' par 'LaplaceSolve.sh'] ,[FilePath par 'DatGeo' par 'LaplaceSolve.sh']);
    rewritefile([FilePath par 'DatGeo' par 'LaplaceSolve.sh'],1 ,num2str(size(subdir,1)));
    for num=1:size(subdir,1)
       %% Load Plate Data
        filename = subdir(num).name;
        readfile = [FilePath par 'DatBodyS' par filename];
        data     = importdata(readfile).data;
        coor     = [data(:,1) data(:,2) data(:,5) data(:,6)]; % x, y, ax, ay
        % get the figure outline of flapping plate
        [index,ninner,innerpoints] = linetopolygon(coor,halfheight,bodyType); % 0 closed body, 1 line
        % define domain
        sidepoints  = [sum(sidelen(1:2)),sum(sidelen(3:4)),sum(sidelen(1:2)),sum(sidelen(3:4))]./boundarydx;
        npoints     = sum(sidepoints);
        outerpoints = zeros(npoints,2);
        midnum = floor(size(coor,1)/2)+1;
        xmin   = coor(midnum,1) - sidelen(1);
        xmax   = coor(midnum,1) + sidelen(2);
        if isNearWall==1
            ymin = wallY + halfheight;
            ymax = ymin  + sum(sidelen(3:4));
        else
            if bodyType==2
                ymin   = coor(midnum,2) - sidelen(3);
                ymax   = coor(midnum,2) + sidelen(4);
            else
                ymin   = coor(1,2) - sidelen(3);
                ymax   = coor(1,2) + sidelen(4);
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
        meshname = filenameget(num,'Mesh','Mesh','.geo');
        writedata1 = [FilePath par 'DatGeo' par meshname];
        file = fopen(writedata1,'w');
        fprintf(file,'// gmesh file for two combination flapping plates\n\n');
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
%        %% Renew Script
%         [bashname,~] = filenameget(num,'','','');
%         npointx = sum(sidelen(1:2))/halfheight*2 + 1;
%         npointy = sum(sidelen(3:4))/halfheight*2 + 1;
%         scope   = [num2str(npointx) ',' num2str(npointy) ',1,' num2str(xmin) ',' num2str(xmax) ',' num2str(ymin) ',' num2str(ymax) ',0,0'];
%         content = ['mpirun -np 36 FieldConvert -m interppoints:box=' scope ':fromxml=Mesh&.xml,LaplaceSet.xml:fromfld=Mesh&.fld PhiVortexI&.plt -f >> log.txt'];
%         file = fopen([FilePath par 'DatGeo' par 'LaplaceSolve.sh'],'a+');
%         fprintf(file,strrep(content,'&',bashname));
%         fprintf(file,'\n');
%         fclose(file);
        %% Write Bounday Normal Vector
        verts = innerpoints(:,1) + innerpoints(:,2)*1i;
        dnorm = normalvector(verts);
        % write data
        boundaryname = filenameget(num,'Boundary','Boundary','.plt');
        writedata2 = [FilePath par 'DatPhi' par boundaryname];
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
            lenx = sum(sidelen(1:2))/walldx;
            wallpoints      = zeros(lenx,2);
            wallpoints(:,1) = (xmin:walldx:(xmax - walldx));
            wallpoints(:,2) = ymin;
            [wallname,~] = filenameget(num,'Wall','Wall','.plt');
            writedata3 = [FilePath par 'DatPhi' par wallname];
            file=fopen(writedata3,'w');
            fprintf(file,'VARIABLES=\"X\",\"Y\",\"nx\",\"ny\",\"ax\",\"ay\"\n');
            fprintf(file,'ZONE    F=POINT\n');
            fprintf(file,'I=%d,   J=%d\n',lenx,1);
            for i=1:lenx
                fprintf(file,'%6f    %6f    %6f    %6f    %6f    %6f\n', wallpoints(i,1), wallpoints(i,2),0,1,0,0);
            end
        end
%         %% write interplot points
%         [pointname,~] = filenameget(num,'points','points','.pts');
%         writedata4 = [FilePath par 'DatGeo' par pointname];
%         file=fopen(writedata4,'w');
%         fprintf(file,'<?xml version=''1.0'' encoding=''utf-8''?>\n');
%         fprintf(file,'<NEKTAR>\n');
%         fprintf(file,'  <POINTS DIM=''3'' FIELDS=''''>\n');
%         for i=1:length(verts)
%             fprintf(file,'      %6f   %6f   %6f\n',innerpoints(i,1),innerpoints(i,2),0.0);
%         end
%         fprintf(file,'  </POINTS>\n');
%         fprintf(file,'</NEKTAR>\n');
        fclose all;
    end
    copyfile('B_GMeshForLaplace.m',[FilePath par 'DatGeo' par 'B_GMeshForLaplace.m']);
    fprintf('%s Mesh Ready   ============================================\n',FileList(kk,:));
end
fprintf('*******************************************************************\n');