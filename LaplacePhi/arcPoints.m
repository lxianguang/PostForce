function [npoints, halfnpoints, dtheata] = arcPoints(theata,radius,dL)
% calculate points number in arc length
halfnpoints = floor(0.5 * theata * radius * 2 * pi / dL / 2 /pi );
if halfnpoints < 1 
   halfnpoints = 1;
end
dtheata = 0.5 * theata / (halfnpoints + 1);
npoints = 2 * halfnpoints + 1;
end

