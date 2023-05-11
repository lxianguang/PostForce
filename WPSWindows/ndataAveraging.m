function [ndata] = ndataAveraging(data,n)
if n
    for i=1:n
        data = dataaverage(data);
    end
end
ndata = data;
end

