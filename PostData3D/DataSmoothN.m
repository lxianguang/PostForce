function [ndata] = DataSmoothN(data,n)
%Smooth data for n times
if n
    for i=1:n
        data = DataSmooth(data);
    end
end
ndata = data;
end