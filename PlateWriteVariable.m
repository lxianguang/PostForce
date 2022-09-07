clc;
close all;
clear;
%% Parameters
r0 = 1.000;
r1 = 51.00;
halfheight = 0.020;
startnum = 44;
%% Read File
path = 'G:\Data\ShearPlate\Force\Re100A0.50Rho1.00S0.00K3.50_1';
subdir=dir([path '\DatBody']);
if size(subdir,1)<2
   error('There is no files in the folder')
end
subdir(1:2) = [];
%% Write PhiZ And Write Integral Boundary
for num=startnum:length(subdir)
    %% Exterior circle mapping ======================================================
    filename = subdir(num).name;
    readfile = [path '\DatBody\' filename];
%     data = [[-0.0001 0 1 1 0]' [0 -0.02 -0.02 0.02 0.02]', ones(5,1), ones(5,1)];
%     data = [[-0.0202 -0.02 0.02 0.02 -0.02]' [0 -0.5 -0.5 0.5 0.5]', ones(5,1), ones(5,1)];
    data0 = importdata(readfile).data;
    data = [data0(:,1) data0(:,2) data0(:,5) data0(:,6)]; % x, y, ax, ay
    curvetype = 1; %1 line segments, 0 closed curve
    [data,centerx,centery] = positioncorrect(data, curvetype);
    [vertices, dataindex] = linetopolygon(data, curvetype, halfheight); % in counter clockwise
    p = polygon(vertices);
    f = extermap(p);
    C = f.constant;
    %% Data Named
    if num<10
        outfile1 = ['DatVortexPhi00' num2str(num) '.dat'];
        outfile2 = ['DatBoundary00' num2str(num) '.dat'];
    elseif num<100
        outfile1 = ['DatVortexPhi0' num2str(num) '.dat'];
        outfile2 = ['DatBoundary0' num2str(num) '.dat'];
    else
        outfile1 = ['DaVortextPhi' num2str(num) '.dat'];
        outfile2 = ['DatBoundary' num2str(num) '.dat'];
    end
    writedata1 = [path '\DatPhi\' outfile1];
    writedata2 = [path '\DatPhi\' outfile2];
    %% Write Integral Vortex Phi
    % Coordinate Transformation And Caculate 
    [~,~,~,~,X,Y] = ellipsemesh(360,625,r0,r0,r1);  % Crea circle grid mesh in mapping domain
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
    file=fopen(writedata1,'w');
    fprintf(file,'VARIABLES=\"X\",\"Y\",\"Phix\",\"Phiy\",\"phi\"\n');
    fprintf(file,'ZONE    F=POINT\n');
    fprintf(file,'I=%d,   J=%d\n',lenx,leny);
    for j=1:leny
        for i=1:lenx
            fprintf(file,'%6f    %6f    %6f    %6f    %6f\n',real(z1(i,j))+centerx,imag(z1(i,j))+centery,phix(i,j),phiy(i,j),phi(i,j));
        end
    end
    fclose(file);
    %% Write Integral Boundary
    [~,~,~,~,X,Y] = ellipsemesh(1800,0,r0,r0,r0);
    zeta2 = X+1i*Y;
    [lenx,leny] = size(zeta2);
    xi2 = xi2zeta(zeta2);
    z2 = eval(f,xi2);
    % Caculate Normal And Tangent Vector And Phi
    [~, ~, dnorm] = normalvector(z2); 
    phix = complexpotential(zeta2, z2, C, 1);
    phiy = complexpotential(zeta2, z2, C, 1i);
    % Write Data
    file=fopen(writedata2,'w');
    fprintf(file,'VARIABLES=\"X\",\"Y\",\"nx\",\"ny\",\"Phix\",\"Phiy\"\n');
    fprintf(file,'ZONE    F=POINT\n');
    fprintf(file,'I=%d,   J=%d\n',lenx,leny);
    for j=1:leny
        for i=1:lenx
            fprintf(file,'%6f    %6f    %6f    %6f    %6f    %6f\n',real(z2(i,j))+centerx,imag(z2(i,j))+centery,real(dnorm(i,j)),imag(dnorm(i,j)),phix(i,j),phiy(i,j));
        end
    end
    fclose all;
    fprintf('第%d次计算结束!\n',num);
end