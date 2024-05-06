function [par] = judgesystem()
    if ispc
        par = '\';
    else
        par = '/';
    end
end

