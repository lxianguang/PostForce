function [file1,file2] = filenameget(num,name1,name2,suffix)
if num<10
    file1 = [name1 '00' num2str(num)  suffix];
    file2 = [name2 '00' num2str(num)  suffix];
elseif num<100
    file1 = [name1 '0'  num2str(num)  suffix];
    file2 = [name2 '0'  num2str(num)  suffix];
else
    file1 = [name1      num2str(num)  suffix];
    file2 = [name2      num2str(num)  suffix];
end
end

