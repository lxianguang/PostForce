run DefineFilePath.m
%% Combine Forces
ForceLen = outStep2 + 1;
for filenum=1:ListLen
    nFile  = [MkdirPath par FileList(filenum,:) 'Continue'];
    %% Parameters Calculate
    freq   = StList(filenum)*Uinf/Thickness;
    Period = 1/freq;
    Start  = NT * Period;
    Deltat = Period/outStep2;
    Dtheta = 2*pi/outStep2;
    time   = (Start:Deltat:Start+Period)';
    theta  = asin(ADList(filenum)*Thickness*0.50)*sin(0:Dtheta:2*pi)';
    %% Resultant Force Interpolation
    TrueForceFile = [nFile par 'dragLift.fce'];
    TrueForce = importdata(TrueForceFile,' ',6).data;
    RelForceX = interp1(TrueForce(:,1),TrueForce(:,4),time,'spline');
    RelForceY = interp1(TrueForce(:,1),TrueForce(:,7),time,'spline');
    %% Extracting Vortex Force
    VortexFile= [nFile par 'vortexforce.txt'];
    VortexForceT = zeros(ForceLen,2);
    file = fopen(VortexFile,'r+');
    line = 0;
    while ~feof(file)
        line = line + 1;
        tline = fgetl(file);
        txt1{line}= tline;
    end
    fclose(file);
    VortexForce0 = str2num(cell2mat(txt1(101)));
    VortexForceT(1,:) = VortexForce0(2:3);
    for i=2:ForceLen
        Forceline = 101 + 102 * (i - 1);
        VortexForce0 = str2num(cell2mat(txt1(Forceline)));
        VortexForceT(i,:) = VortexForce0(2:3);
    end
    %% Extracting Vortex Friction Force, Vicous Pressure Focre, Acceleration Force
    OtherFile= [nFile par 'otherforces.txt'];
    FrictionT = zeros(ForceLen,2);
    VicpressT = zeros(ForceLen,2);
    AcceleraT = zeros(ForceLen,2);
    file = fopen(OtherFile,'r+');
    line = 0;
    while ~feof(file)
        line = line + 1;
        tline = fgetl(file);
        txt2{line}= tline;
    end
    fclose(file);
    for i=1:ForceLen
        % Friction Force
        Frictionline = 10 * (i - 1) + 6;
        Friction0    = str2num(cell2mat(txt2(Frictionline)));
        FrictionT(i,:)= Friction0(1:2);
        % Vicous Pressure Force
        Vicpressline = 10 * (i - 1) + 8;
        Vicpress0    = str2num(cell2mat(txt2(Vicpressline)));
        VicpressT(i,:)= Vicpress0(1:2);       
        % Acceleration Force
        Acceleraline = 10 * (i - 1) + 10;
        Accelera0    = str2num(cell2mat(txt2(Acceleraline)));
        AcceleraT(i,:)= Accelera0(1:2);  
    end    
    % Coordinate system transformation
    VortexForce = zeros(ForceLen,2);
    Friction = zeros(ForceLen,2);
    Accelera = zeros(ForceLen,2);
    Vicpress = zeros(ForceLen,2);
    for i=1:ForceLen
        VortexForce(i,1) = VortexForceT(i,1)*cos(theta(i))-VortexForceT(i,2)*sin(theta(i));
        VortexForce(i,2) = VortexForceT(i,1)*sin(theta(i))+VortexForceT(i,2)*cos(theta(i));
        Friction(i,1) = FrictionT(i,1)*cos(theta(i))-FrictionT(i,2)*sin(theta(i));
        Friction(i,2) = FrictionT(i,1)*sin(theta(i))+FrictionT(i,2)*cos(theta(i));
        Accelera(i,1) = AcceleraT(i,1)*cos(theta(i))-AcceleraT(i,2)*sin(theta(i));
        Accelera(i,2) = AcceleraT(i,1)*sin(theta(i))+AcceleraT(i,2)*cos(theta(i));
        Vicpress(i,1) = VicpressT(i,1)*cos(theta(i))-VicpressT(i,2)*sin(theta(i));
        Vicpress(i,2) = VicpressT(i,1)*sin(theta(i))+VicpressT(i,2)*cos(theta(i));
    end
    % Resultant force calculated by WPS theory
    Resultant = zeros(ForceLen,2);
    Resultant(:,1) = VortexForce(:,1)+Friction(:,1)+Accelera(:,1)+Vicpress(:,1);
    Resultant(:,2) = VortexForce(:,2)+Friction(:,2)+Accelera(:,2)+Vicpress(:,2);
    %% Write Force Data
    % Force in x-direction
    writeforce = [nFile par 'ForceX.dat'];
    file=fopen(writeforce,'w');
    fprintf(file,'VARIABLES=\"T\",\"Vortex\",\"Friction\",\"Acceleration\",\"Vicpress\",\"WPS\",\"Nektar\"\n');
    for i=1:ForceLen
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',time(i),VortexForce(i,1),Friction(i,1),Accelera(i,1),Vicpress(i,1),Resultant(i,1),RelForceX(i));
    end
    fclose(file);
    % Force in y-direction
    writeforce = [nFile par 'ForceY.dat'];
    file=fopen(writeforce,'w');
    fprintf(file,'VARIABLES=\"T\",\"Vortex\",\"Friction\",\"Acceleration\",\"Vicpress\",\"WPS\",\"Nektar\"\n');
    for i=1:ForceLen
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',time(i),VortexForce(i,2),Friction(i,2),Accelera(i,2),Vicpress(i,2),Resultant(i,2),RelForceY(i));
    end
    fclose(file);
    copyfile(['.' par 'Scripts' par 'ForcePlot.lay'],[nFile par 'ForcePlot.lay']);
    fprintf('%s Force Combination Ready =========================================\n',FileList(filenum,:));
end
fclose all;