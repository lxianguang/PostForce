function [par] = JudgeSystem()
% Select separator based on system
if ispc
    par = '\';
else
    par = '/';
end
end