clc
clear
close all
%% Parameters
f = 0.01;
Y = 0.00;
Amp = 0.25;
Phi = 0.00;
UpIntervalTime = 0.1;
DownIntervalTime = 0.3;
%% Caculate
Uref = 2*pi*f*Amp;
Tref = 1/Uref;
timetol = 2*(1+UpIntervalTime+DownIntervalTime)/f/Tref;
timeforall = (1+UpIntervalTime+DownIntervalTime);
time = (0:0.01:timetol * Tref);
y = zeros(size(time));
for i=1:length(time)
    JudgeTime = (time(i)*f/timeforall-floor(time(i)*f/timeforall))*timeforall;
    if JudgeTime<=UpIntervalTime
        y(i) = Amp;
    elseif JudgeTime<=UpIntervalTime+0.5
        y(i) = Y + Amp * cos(2*pi*(JudgeTime-UpIntervalTime)+Phi);
    elseif JudgeTime<=UpIntervalTime+DownIntervalTime+0.5
        y(i) = -Amp;
    else
        y(i) = Y + Amp * cos(2*pi*(JudgeTime-UpIntervalTime-DownIntervalTime)+Phi);
    end
end
%% Plot
plot(time/Tref,y,'r','LineWidth',2.0);
axis equal