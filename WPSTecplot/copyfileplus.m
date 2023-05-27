function [] = copyfileplus(path1,path2)
if ~exist(path2,'file')
    copyfile(path1,path2);
end
end

