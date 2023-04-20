function [] = rewritefileline(path,changeline,replacecontent)
line = getFileLines(path);
file = fopen(path,'r+');
for i=1:line
    tline = fgetl(file); 
    txt{i}= tline;
end
fclose(file);
if replacecontent
    txt{changeline} = replacecontent;
else
    txt(changeline) = [];
    line = line - 1;
end
%% write file
file = fopen(path,'w+');
for i=1:line
    fprintf(file,'%s\n',txt{i});
end
fclose(file);
end

