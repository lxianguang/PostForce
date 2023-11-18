function [error] = MaxError(data0,data1)
%Calculate the max error after data smoothing
[m, n] = size(data0);
err    = data0-data1;
error  = sqrt(sum(sum(err.*err))/m/n);
end