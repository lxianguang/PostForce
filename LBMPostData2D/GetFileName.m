function [filename] = GetFileName(file,n)
% get file name
if n<10
    filename = [file '_000' num2str(n) '.plt'];
elseif n<100
    filename = [file '_00'  num2str(n) '.plt'];
elseif n<1000
    filename = [file '_0'   num2str(n) '.plt'];
else
    filename = [file '_'    num2str(n) '.plt'];
end
end