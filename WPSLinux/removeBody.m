function [] = removeBody(path, par, file)
% Delete excess body data
for k=1:size(file,1)
    FilePath    = [path par file(k,:)];
    subdir      = dir([FilePath par 'DatBody']);
    subdir(1:2) =[];
    for i=1:size(subdir,1)
        name   = subdir(i).name;
        number = str2double(name(14:15));
        if mod(number,2)==1
            delete([FilePath par 'DatBody' par name])
        end
    end
end
end

