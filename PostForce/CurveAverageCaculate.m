clc
clear
%% caculate average velocity
maindir = 'G:\Data\ShearPlate\Velocity\Re100_Ap10_R2.00';
dataname = fullfile('G:\Data\ShearPlate\Velocity\resultData\Re100_Ap10_R2.00', [maindir(end-4:end) '.dat']);
subdir=dir(maindir);
subdir(1:2) = [];
umean = zeros(length(subdir),1);
kname = zeros(length(subdir),1);
umax = zeros(length(subdir),1);
Amp = zeros(length(subdir),1);
for i=1:length(subdir)
    name = subdir(i).name;
    filename = fullfile(maindir, name);
    contain = importdata(filename);
    data = contain.data;
    u = data(:,4);
    u(1:1024)=[];
    kname(i) = str2double(strrep(name,'.plt',''));
    umean(i) = abs(sum(u)/length(u));
    umax(i) = max(abs(u));
    Amp(i) = max(abs(u)) - min(abs(u));
    fprintf('%.6f    %.6f\n',kname(i),umean(i));
end
%% output data
[kname, index] = sort(kname);
umean = umean(index);
umax = umax(index);
Amp = Amp(index);
caculatedata = [kname umean umax Amp];
file=fopen(dataname,'w');
fprintf(file,'VARIABLES=\"K\",\"umean\",\"umax\",\"Amp\"\n');
for i=1:length(umean)
    fprintf(file,'%.6f    %.6f    %.6f    %.6f\n',kname(i),umean(i),umax(i),Amp(i));
end
fclose(file);