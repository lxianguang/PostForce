%% Smooth data
run A_ParameterSet.m
for k=1:size(FileList,1)
    CreatFolder([CopyPath par FileList(k,:) par 'DatInfoS']);
    %% Averaging For Velocity
    VelocityPath0 = [CopyPath par FileList(k,:) par 'DatInfo'  par 'SampBodyCentM00' num '.plt'];
    VelocityPath1 = [CopyPath par FileList(k,:) par 'DatInfoS' par 'SampBodyCentM00' num '.plt'];
    Velocitydata  = importdata(VelocityPath0);
    Velocitydata  = str2num(cell2mat(Velocitydata(2:end)));
    NewVelocity0  = DataSmoothN(Velocitydata(:,5:end),n_aver(1));
    NewVelocity   = [Velocitydata(:,1:4) NewVelocity0];
    file=fopen(VelocityPath1,'w');
    fprintf(file,'variables= "t"  "x"  "y"  "z"  "u"  "v"  "w"  "ax"  "ay"  "az"\n');
    for i=1:size(Velocitydata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n', ...
                NewVelocity(i,1),NewVelocity(i,2),NewVelocity(i,3),NewVelocity(i,4),NewVelocity(i,5), ...
                NewVelocity(i,6),NewVelocity(i,7),NewVelocity(i,8),NewVelocity(i,9),NewVelocity(i,10));
    end
    VelocityError = MaxError(Velocitydata(:,5),NewVelocity(:,5));
    fprintf('Velocity     max error:%.6f percent\n',VelocityError*100);
    %% Averaging For Power
    PowerPath0    = [CopyPath par FileList(k,:) par 'DatInfo'  par 'Power00' num '.plt' ];
    PowerPath1    = [CopyPath par FileList(k,:) par 'DatInfoS' par 'Power00' num '.plt' ];
    Powerdata     = importdata(PowerPath0);
    Powerdata     = str2num(cell2mat(Powerdata(2:end)));
    NewPower0     = DataSmoothN(Powerdata(:,2:end),n_aver(2));
    NewPower      = [Powerdata(:,1) NewPower0];
    file=fopen(PowerPath1,'w');
    fprintf(file,' variables= "t" "Ptot" "Paero" "Piner" "Pax" "Pay" "Paz" "Pix" "Piy" "Piz"\n');
    for i=1:size(Powerdata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n', ...
            NewPower(i,1),NewPower(i,2),NewPower(i,3),NewPower(i,4),NewPower(i,5),NewPower(i,6), ...
            NewPower(i,7),NewPower(i,8),NewPower(i,9),NewPower(i,10));
    end
    PowerError = MaxError(Powerdata(:,2),NewPower(:,2));
    fprintf('Power        max error:%.6f percent\n',PowerError*100);
    %% Averaging For Force
    ForcePath0    = [CopyPath par FileList(k,:) par 'DatInfo'  par 'ForceDirect00' num '.plt' ];
    ForcePath1    = [CopyPath par FileList(k,:) par 'DatInfoS' par 'ForceDirect00' num '.plt' ];
    Forcedata     = importdata(ForcePath0);
    Forcedata     = str2num(cell2mat(Forcedata(2:end)));
    NewForce0     = DataSmoothN(Forcedata(:,2:end),n_aver(3));
    NewForce      = [Forcedata(:,1) NewForce0];
    file=fopen(ForcePath1,'w');
    fprintf(file,' variables= "t"  "Fx"  "Fy"  "Fz"\n');
    for i=1:size(Forcedata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f\n', ...
            NewForce(i,1),NewForce(i,2),NewForce(i,3),NewForce(i,4));
    end
    ForceError = MaxError(Forcedata(:,2),NewForce(:,2));
    fprintf('Force        max error:%.6f percent\n',ForceError*100);
    %% Averaging For Stress Energy
    EnergyPath0  = [CopyPath par FileList(k,:) par 'DatInfo'  par 'Energy00' num '.plt' ];
    EnergyPath1  = [CopyPath par FileList(k,:) par 'DatInfoS' par 'Energy00' num '.plt' ];
    Energydata   = importdata(EnergyPath0);
    Energydata   = str2num(cell2mat(Energydata(2:end)));
    NewEnergy0   = DataSmoothN(Energydata(:,2:end),n_aver(4));
    NewEnergy    = [Energydata(:,1) NewEnergy0];
    file=fopen(EnergyPath1,'w');
    fprintf(file,' variables= "t","Es","Eb","Ep","Ek","Ew","Et"\n');
    for i=1:size(Energydata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n', ...
            NewEnergy(i,1),NewEnergy(i,2),NewEnergy(i,3),NewEnergy(i,4),NewEnergy(i,5),NewEnergy(i,6),NewEnergy(i,7));
    end
    EnergyError = MaxError(Energydata(:,7),NewEnergy(:,7));
    fprintf('Energy       max error:%.6f percent\n',EnergyError*100);
    fclose all;
    fprintf('%s Smooth Ready ============================================\n',FileList(k,:));
end
fprintf('*******************************************************************\n');
ContrastPlot(Velocitydata(:,1),Velocitydata(:,5),NewVelocity(:,1),NewVelocity(:,5),1,'Velocity')
ContrastPlot(Powerdata   (:,1),Powerdata   (:,2),NewPower   (:,1),NewPower   (:,2),2,'Power'   )
ContrastPlot(Forcedata   (:,1),Forcedata   (:,2),NewForce   (:,1),NewForce   (:,2),3,'Force'   )
ContrastPlot(Energydata  (:,1),Energydata  (:,4),NewEnergy  (:,1),NewEnergy  (:,4),4,'Energy'  )