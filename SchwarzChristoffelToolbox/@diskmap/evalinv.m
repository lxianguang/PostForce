function [zp,flag] = evalinv(M,wp,tol,z0)
%EVALINV Invert Schwarz-Christoffel disk map at points.
%   EVALINV(M,WP) evaluates the inverse of the Schwarz--Christoffel map M
%   at the points WP in the polygon. The default tolerance of M is used.
%   
%   EVALINV(M,WP,TOL) attempts to give an answer accurate to TOL. If TOL
%   is smaller than the accuracy of M, this is unlikely to be met.
%   
%   EVALINV(M,WP,TOL,Z0) uses given starting points. Z0 must be either
%   the same size as WP or a complex scalar (to be expanded to that
%   size). It is used for the starting approximation to the inverse
%   image of WP. The starting guess need not be close to the correct
%   answer; however, the straight line segment between WP(K) and the
%   forward image of Z0(K) must lie entirely inside the polygon, for
%   each K.
%   
%   [ZP,FLAG] = EVALINV(...) also returns a vector of indices where the
%   method was unable to produce a sufficiently small residual. A warning
%   is issued when this occurs.
%
%   See also DISKMAP, EVAL.

%   Copyright 1998 by Toby Driscoll.
%   $Id: evalinv.m 185 2002-09-05 20:06:41Z driscoll $

% Assign empties to missing input args
if nargin < 4
  z0 = [];
  if nargin < 3
    tol = [];
  end
end

% Check inputs/supply defaults
if ~isempty(tol)
  % Either a scalar tolerance or a qdata matrix was passed
  qdata = tol;
  if length(tol) > 1
    tol = 10^(-size(qdata,1));
  end
else
  qdata = M.qdata;
  tol = M.accuracy;
end

if ~isempty(z0)
  if length(z0) == 1
    z0 = repmat(z0,size(wp));
  elseif any(size(z0) ~= size(wp))
    msg = 'Argument %s must be a complex scalar or the same size as %s.';
    error(sprintf(msg,inputname(z0),inputname(1)));
  end
end  
    
p = polygon(M);
[zp,flag] = dinvmap(wp,vertex(p),angle(p)-1,M.prevertex,M.constant,...
    qdata,z0,[0 tol]);
