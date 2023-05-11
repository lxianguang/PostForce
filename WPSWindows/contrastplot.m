function [] = contrastplot(data1,data2,data3,data4,n,ntitle)
figure(n)
plot(data1,data2)
hold on 
plot(data3,data4)
title(ntitle)
end

