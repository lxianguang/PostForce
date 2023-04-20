function [error] = maxerror(data0,data1)
    [m, n] = size(data0);
    err    = data0-data1;
    error  = sqrt(sum(sum(err.*err))/m/n);
end

