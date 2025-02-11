classdef qpar  < matlab.mixin.CustomDisplay
%QPAR class defines a single uncertain parameter in qpenQsyn. 
%
%   par = QPAR(name, nom, lbnd, ubnd, cases, space)   
%   defines a qpar object with specified 
%   name, nominal value, lower bound, upper bound, number of cases and
%   generation space {linear ('lin') or logarithmic ('log')}.
%
%   #TODO: Generate the linear or logarithmic space.
%
%For a list QPAR methods type: methods qpar
%For help on a specific methods type: help qpar/<method>

    properties
        name        % parameter name
        nominal     % nominal value
        lower       % lower bound
        upper       % upper bound
        cases       % number of cases
        space       % generation space
        discrete    % discrete values
        description % user can insert here whatever he likes.
    end
    
    methods
        function par = qpar(name, nom, lbnd, ubnd, cases, space)
            %QPAR Construct an instance of this class
            %   
            %   Usage: 
            %
            %   par = qpar(name, nom)   
            %   defines a qpar object with
            %   specified name, nominal value without bounds,
            %   the bounds equals to the nominal value,
            %   and the number of cases equals to 1.
            %
            %   par = qpar(name, nom, lbnd, ubnd) 
            %   defines a qpar object with
            %   specifiey name, nominal value, lower bound and upper bound
            %   and the number of cases equals to 3.
            %
            %   par = qpar(name, nom, lbnd, ubnd, cases) 
            %   defines a qpar object with
            %   specifiey name, nominal value, lower bound, upper bound and
            %   the number of cases. By default, the space is linear.  

            %   par = qpar(name, nom, lbnd, ubnd, cases, space) 
            %   defines a qpar object with
            %   specifiey name, nominal value, lower bound, upper bound,
            %   the number of cases and space.

            if nargin < 2 || nargin == 3 || nargin > 7
                error('unexceptable number of argumetns to qpar')
            end
            if (nargin > 2 && nargin < 5) 
                cases = 3;
            end
            if nargin < 6, space = 'lin'; end
  
            % check input types and validation of values
            if ~ischar(name), error('qpar name must be a charecter array'); end
            if ~isnumeric(nom), error('nominal value must be a numeric scalar'); end

            if nargin == 2, cases = 1; lbnd = nom; ubnd = nom; end

            if ~isnumeric(lbnd), error('lower bound must be a numeric scalar'); end
            if ~isnumeric(ubnd), error('upper bound must be a numeric scalar'); end
            if ~isnumeric(cases), error('number of cases must be an integer'); end
            if ~ischar(space), error('space must be a charecter array'); end

            if any(size(ubnd)~=1), error('upper bound must be a numeric scalar'); end
            if any(size(lbnd)~=1), error('lower bound must be a numeric scalar'); end
            if any(size(nom)~=1), error('nominal value must be a numeric scalar'); end
            if any(size(cases)~=1), error('number of cases must be a numeric scalar'); end

            if lbnd > ubnd, error('upper bound must be greater than or equal to lower bound'); end
            if (lbnd > nom || ubnd < nom), error('nominal value is not between bounds'); end
            if (strcmp(space,'lin') == 0 && strcmp(space,'log') == 0), error('space is not equal to linear or logarithmic space'); end
                       
            % assign properties    
            par.name = name;
            par.nominal = double(nom);
            par.lower = double(lbnd);
            par.upper = double(ubnd);
            par.cases = int32(cases);
            par.space = space;
        end
        function obj = plus(A,B)
            %PLUS adds qpar elements 
            if isnumeric(B) || isa(B,'qpar') ||  isa(B,'qexpression')
                obj = qexpression(A,B,'+');
            else
                error('undefined method');
            end
        end
        function obj = uplus(A)
            %UPLUS unary plus
            obj = qexpression([],A,'+');
        end
        function obj = minus(A,B)
            %MINUS substruct qpar elements 
            if isnumeric(B) || isa(B,'qpar') ||  isa(B,'qexpression') 
                obj = qexpression(A,B,'-');
            else
                error('undefined method');
            end
        end
        function obj = uminus(A)
            %UMINUS unary minus
            obj = qexpression([],A,'-');
        end
        function obj = mtimes(A,B)
            %MTIMES multiply qpar elements
            if isnumeric(B) || isa(B,'qpar') ||  isa(B,'qexpression')
                obj = qexpression(A,B,'*');
            else
                error('undefined method');
            end
        end
        function obj = mrdivide(A,B)
            %MRDIVIDE divides qpar elements
            if isnumeric(B) || isa(B,'qpar') ||  isa(B,'qexpression')
                obj = qexpression(A,B,'/');
            else
                error('undefined method');
            end
        end
        function obj = unique(par)
            %Unique values in array
            names = {par.name};
            [~,ia] = unique(names);
            obj = par(ia);
        end      
        function obj = horzcat(varargin)
            %HORZCAT concatenate arrays horizontally
            obj = qpoly(varargin{:});
        end
        function val = nom(obj)
            %NOM returns nominal value
           val = [obj.nominal].';
        end
        function pspace = linspace(obj,n)
            %LINSPACE parameter space
            if nargin<2, n = obj.cases; end
            pspace = linspace(obj.lower,obj.upper,n);           
        end
        function p = grid(obj,cases,rnd)
            %GRID computes a grid of N parameters
            % 
            %   p = grid(obj,rnd,cases)
            %   
            %   Inputs 
            %
            %   cases   intiger specifing the number of cases 
            % 
            %   rnd     boolian scalar to specify if grid is random. default
            %           option is 0 (not random). 
            %
            %%% Adapted from NDGRID
            [N,M] = size(obj);
            if M~=1, error('par.gird only accepts a column vector'); end    
            if nargin<3, rnd=0; end
            if nargin<2, cases = []; end
            if isempty(cases), cases=[obj.cases]; end
            if length(cases)==1 && N>1, cases=repmat(cases,1,N); end
            p = zeros(N,prod(cases));
            for k=1:N
                if ~isempty(obj(k).discrete)
                    a = obj(k).discrete;
                elseif rnd==0
                    a = linspace(obj(k),cases(k));
                else %rnd==1
                    a = obj(k).lower + (obj(k).upper-obj(k).lower)*rand(1,cases(k));
                end
                x = full(a);
                if N > 1 
                    s = ones(1,N);
                    s(k) = numel(x);
                    x = reshape(x,s);
                    s = cases;
                    s(k) = 1;
                    pk = repmat(x,s);
                    p(k,:) = reshape(pk,1,[]);
                else
                    p = x;
                end
            end
                        
        end
        function p = sample(obj,N)
            %SAMPLE generates N random samples of the parameter cases
            %   default N = 100.
            if ~exist('N','var'), N=[]; end
            if isempty(N), N=100; end
            
            [n,m] = size(obj);
            if m~=1, error('par.sample only accepts a column vector'); end
            
            p = zeros(n,N);
            
            for k=1:n
                p(k,:) = obj(k).lower + (obj(k).upper-obj(k).lower)*rand(1,N);
            end
                        
        end
        function I = ismember(A,B)
            %ISMEMBER true for set member.
            %
            %  ISMEMBER(A,B)    returns a vector of logical indices positive 
            %  forevery element of parameter set A that is a member of 
            %  parameter set B.
            Anames = {A(:).name};
            Bnames = {B(:).name};
            I = ismember(Anames,Bnames);
        end
    end
    
    methods(Access = protected)
        function propgrp = getPropertyGroups(obj)
            propgrp = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            if ~isempty([obj.discrete])
                S =  propgrp.PropertyList;
                S = rmfield(S,'lower');
                S = rmfield(S,'upper');
                S = rmfield(S,'nominal');
                propgrp = matlab.mixin.util.PropertyGroup(S);
            end
        end    
    end

end


