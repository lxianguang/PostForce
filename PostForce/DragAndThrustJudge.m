clc
clear
%% Caculate Parameters
startperiod = 5;
periodnum = 5;
path = 'G:\DataFile\FlappingPlate\Re100K3.50Rho1.00S0.30';
%% Caculate Average Force
subdir=dir([path '\DatInfo']);
if size(subdir,1)<2
   error('There is no files in the folder')
end
subdir(1:2) = [];
forceA = zeros(length(subdir),1);
fprintf('Press Enter for next calculation...\n');
for i=1:length(subdir)
    % Calculate amplitude and period
    name = subdir(i).name;
    Amp = str2double(name(2:5));
    St = str2double(name(8:11));
    period = Amp / St;
    % Read data
    filename = [path '\DatInfo\' name];
    data = importdata(filename).data;
    % Extract n period to calculate average force
    starttime = 10.0;
%     starttime = startperiod * period;
    endtime = starttime + period * periodnum;
    if max(data(:,1))<starttime
        fprintf('number:%d    A:%.2f    St:%.2f    ForceAverage:None\n',i,Amp,St);
        continue 
    elseif max(data(:,1))<endtime
        while(max(data(:,1))<endtime)
            endtime = endtime - period;
        end 
    end
    index1 = find(data(:,1)<starttime);
    index2 = find(data(:,1)>endtime);
    startnum = index1(end) + 1;
    endnum = index2(1) - 1;
    periodData = data(startnum:endnum,:);
    forceA(i) = sum(periodData(:,2))/size(periodData,1);
    % plot and confirm if there is something wrong
    plot(periodData(:,1),periodData(:,2),'r','LineWidth',2.0);
    amp = max(periodData(:,2))-min(periodData(:,2));
    xlim([starttime endtime])
    ylim([forceA(i)-2*amp, forceA(i)+2*amp])
    hold on 
    plot(periodData(:,1),forceA(i)*ones(size(periodData(:,1))),'b--','LineWidth',2.0)
    % Print instructions
    fprintf('number:%d    A:%.2f    St:%.2f    ForceAverage:%.6f\n',i,Amp,St,forceA(i));
    pause
    close all
end
%% output data
% file=fopen([path '\AverageForce.txt'],'w');
% fprintf(file,'VARIABLES=\"name\",\"FxAverage\"\n');
% for i=1:length(Fmean)
%     fprintf(file,'%s    %.6f\n',strrep(subdir(i).name,'.plt',''),Fmean(i));
% end
% fclose all;