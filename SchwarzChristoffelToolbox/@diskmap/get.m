function varargout = get(map,varargin)
%GET    Get map parameters.
%   [VAL1,VAL2,...] = GET(F,'PROP1','PROP2',...) returns the values of the
%   map F corresponding to the requested properties. Valid properties
%   are: 
%   
%       polygon, options, prevertex, constant, center

% Copyright 1999-2003 by Toby Driscoll.
% $Id: get.m 237 2003-01-15 15:29:15Z driscoll $

for j = 1:length(varargin)
  switch lower(varargin{j}(1:min(3,length(varargin{j}))))
   case 'pol'
    varargout{j} = map.scmap.polygon;
   case 'opt'
    varargout{j} = map.scmap.options;
   case 'pre'
    varargout{j} = map.prevertex;
   case 'con'
    varargout{j} = map.constant;
   case 'cen'
    varargout{j} = center(map);
   otherwise
    warning(sprintf('Property ''%s'' not recognized.\n',varargin{j}))
    varargout{j} = [];
  end
end
