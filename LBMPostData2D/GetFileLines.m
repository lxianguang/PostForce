function [lines] = GetFileLines(path)
lines = 0;
file = fopen(path,'r+');
while ~feof(file)
    tline = fgetl(file);
    lines = lines+1;
end
fclose(file);
end

