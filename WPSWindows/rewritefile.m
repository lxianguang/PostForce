function [] = rewritefile(path,changeline,replacecontent)
line = getFileLines(path);
file = fopen(path,'r+');
for i=1:line
    tline = fgetl(file); 
    txt{i}= tline;
end
fclose(file);
txt{changeline} = strrep(txt{changeline},'&',replacecontent);
%% write file
file = fopen(path,'w+');
for i=1:line
    fprintf(file,'%s\n',txt{i});
end
fclose(file);
end

