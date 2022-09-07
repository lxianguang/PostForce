clc;
close all;
clear;
%% Parameters
halfheight = 5E-5;
%% Read File
path = 'G:\Data\ShearPlate\Force\Re100A0.50Rho1.00S0.00K3.50_1';
subdir=dir([path '\DatBody']);
if size(subdir,1)<2
   error('There is no files in the folder')
end
subdir(1:2) = [];
time = zeros(1,length(subdir));
addmassforce = zeros(2,length(subdir));
addmass = zeros(2, 2, length(subdir));
for num=1:length(subdir)
%% Exterior circle mapping
    filename = subdir(num).name;
    time(num) = str2double(strrep(strrep(filename,'_001.dat',''),'Body',''));
    readfile = [path '\DatBody\' filename];
    data0 = importdata(readfile).data;
    data = [data0(:,1) data0(:,2) data0(:,5) data0(:,6)]; % x, y, ax, ay
    curvetype = 1; %1 line segments, 0 closed curve
    [data,centerx,centery] = positioncorrect(data, curvetype);
    [vertices, dataindex] = linetopolygon(data, curvetype, halfheight); % in counter clockwise
    p = polygon(vertices);
    f = extermap(p);
    C = f.constant;
    %% Caculate Phi And Normal Vector
    xi = f.prevertex;
    zeta = xi2zeta(xi);
    z = eval(f,xi);
    phix = complexpotential(zeta, z, C, 1);
    phiy = complexpotential(zeta, z, C, 1i);
    phi = [phix phiy];
    [dz, ~, ~] = normalvector(z);
    dnorm = -1i*dz;
    len = length(dnorm);
    %% Caculate Add Mass
    for k=1:1:2
        mtmp = 0.5 * (phi(1, k) + phi(len, k)) * dnorm(len);
        for i=1:1:len-1
            mtmp = mtmp + 0.5 * (phi(i, k) + phi(i+1, k)) * dnorm(i);
        end
        addmass(1, k, num) = real(mtmp);
        addmass(2, k, num) = imag(mtmp);
    end
    %% Caculate Add Mass Force
    for k=1:1:2
        accphi = phi(:,k) .* (data(dataindex, 3) - 1i*data(dataindex, 4));
        mtmp = 0.5 * (accphi(1) + accphi(len)) * dnorm(len);
        for i=1:1:len-1
            mtmp = mtmp + 0.5 * (accphi(i) + accphi(i+1)) * dnorm(i);
        end
        addmassforce(k,num) = real(mtmp);
    end
    fprintf('第%d次计算结束!\n',num);
end
%% Write Add Mass Force 
writeforce = [path '\Result\Combination\AddMassForce.dat'];
file=fopen(writeforce,'w');
fprintf(file,'VARIABLES=\"Time\",\"ForceX\",\"ForceY\"\n');
for k=1:length(subdir)
    fprintf(file,'%.6f    %.6f    %.6f\n',time(k),addmassforce(1,k),addmassforce(2,k));
end
fclose all;