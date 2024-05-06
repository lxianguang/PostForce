%% Smooth data
run A_ParameterSet.m
for k=1:size(FileList,1)
    CreatFolder([CopyPath par FileList(k,:) par 'DatInfoS']);
    %% Averaging For Velocity
    VelocityPath0 = [CopyPath par FileList(k,:) par 'DatInfo'  par 'SampBodyMean_00' num '.plt'];
    VelocityPath1 = [CopyPath par FileList(k,:) par 'DatInfoS' par 'SampBodyMean_00' num '.plt'];
    Velocitydata  = importdata(VelocityPath0).data;
    NewVelocity0  = DataSmoothN(Velocitydata(:,4:end),n_aver(1));
    NewVelocity   = [Velocitydata(:,1:3) NewVelocity0];
    file=fopen(VelocityPath1,'w');
    fprintf(file,'variables= "t"  "x"  "y"  "u"  "v"  "ax"  "ay"\n');
    for i=1:size(Velocitydata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewVelocity(i,1),NewVelocity(i,2),NewVelocity(i,3),NewVelocity(i,4),NewVelocity(i,5),NewVelocity(i,6),NewVelocity(i,7));
    end
    VelocityError = MaxError(Velocitydata(:,4),NewVelocity(:,4));
    fprintf('Velocity     max error:%.6f percent\n',VelocityError*100);
    %% Averaging For Power
    PowerPath0    = [CopyPath par FileList(k,:) par 'DatInfo'  par 'Power_00' num '.plt' ];
    PowerPath1    = [CopyPath par FileList(k,:) par 'DatInfoS' par 'Power_00' num '.plt' ];
    Powerdata     = importdata(PowerPath0).data;
    NewPower0     = DataSmoothN(Powerdata(:,2:end),n_aver(2));
    NewPower      = [Powerdata(:,1) NewPower0];
    file=fopen(PowerPath1,'w');
    fprintf(file,' variables= "t" "Ptot" "Paero" "Piner" "Pax" "Pay"  "Pix" "Piy"\n');
    for i=1:size(Powerdata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewPower(i,1),NewPower(i,2),NewPower(i,3),NewPower(i,4),NewPower(i,5),NewPower(i,6),NewPower(i,7),NewPower(i,8));
    end
    PowerError = MaxError(Powerdata(:,3),NewPower(:,3));
    fprintf('Power        max error:%.6f percent\n',PowerError*100);
    %% Averaging For Force
    ForcePath0    = [CopyPath par FileList(k,:) par 'DatInfo'  par 'ForceDirect_00' num '.plt' ];
    ForcePath1    = [CopyPath par FileList(k,:) par 'DatInfoS' par 'ForceDirect_00' num '.plt' ];
    Forcedata     = importdata(ForcePath0).data;
    NewForce0     = DataSmoothN(Forcedata(:,2:end),n_aver(3));
    NewForce      = [Forcedata(:,1) NewForce0];
    file=fopen(ForcePath1,'w');
    fprintf(file,' variables= "t"  "Fx"  "Fy"\n');
    for i=1:size(Forcedata,1)
        fprintf(file,'%.6f    %.6f    %.6f\n',NewForce(i,1),NewForce(i,2),NewForce(i,3));
    end
    ForceError = MaxError(Forcedata(:,2),NewForce(:,2));
    fprintf('Force        max error:%.6f percent\n',ForceError*100);
    %% Averaging For Stress Energy
    EnergyPath0  = [CopyPath par FileList(k,:) par 'DatInfo'  par 'Energy_00' num '.plt' ];
    EnergyPath1  = [CopyPath par FileList(k,:) par 'DatInfoS' par 'Energy_00' num '.plt' ];
    Energydata   = importdata(EnergyPath0).data;
    NewEnergy0   = DataSmoothN(Energydata(:,2:end),n_aver(4));
    NewEnergy    = [Energydata(:,1) NewEnergy0];
    file=fopen(EnergyPath1,'w');
    fprintf(file,' variables= "t","Es","Eb","Ep","Ek","Ew","Et"\n');
    for i=1:size(Energydata,1)
        fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewEnergy(i,1),NewEnergy(i,2),NewEnergy(i,3),NewEnergy(i,4),NewEnergy(i,5),NewEnergy(i,6),NewEnergy(i,7));
    end
    EnergyError = MaxError(Energydata(:,7),NewEnergy(:,7));
    fprintf('Energy       max error:%.6f percent\n',EnergyError*100);
    fclose all;
    fprintf('%s Smooth Ready ============================================\n',FileList(k,:));
end
fprintf('*******************************************************************\n');
ContrastPlot(Velocitydata(:,1),Velocitydata(:,4),NewVelocity(:,1),NewVelocity(:,4),1,'Velocity')
ContrastPlot(Powerdata   (:,1),Powerdata   (:,3),NewPower   (:,1),NewPower   (:,3),2,'Power'   )
ContrastPlot(Forcedata   (:,1),Forcedata   (:,2),NewForce   (:,1),NewForce   (:,2),3,'Force'   )
ContrastPlot(Energydata  (:,1),Energydata  (:,4),NewEnergy  (:,1),NewEnergy  (:,4),4,'Energy'  )