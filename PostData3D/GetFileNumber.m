function [number] = GetFileNumber(filelist,worldlist)
% Get file number
m = size(filelist, 1);
n = size(worldlist,2);
number = 0;
for i=1:m
    if size(filelist(i).name,2) >= n
        if filelist(i).name(1:n) == worldlist
            number = number + 1;
        end
    end
end
end