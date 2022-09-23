clc
clear
%% Caculate Average Velocity
path = 'G:\DataFile\ShearPlate\Velocity\Re100Ap5S0.50';
dataname = ['G:\DataFile\ShearPlate\Velocity\ResultData\' path(end-4:end) '.dat'];
subdir=dir(path);
if size(subdir,1)<2
   error('There is no files in the folder')
end
subdir(1:2) = [];
umean = zeros(length(subdir),1);
kname = zeros(length(subdir),1);
umax = zeros(length(subdir),1);
Amp = zeros(length(subdir),1);
for i=1:length(subdir)
    name = subdir(i).name;
    filename = fullfile(path, name);
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
%% Output Data
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