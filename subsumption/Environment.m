classdef Environment
    enumeration
        Indoor
        Outdoor
    end
    
    methods (Static)
        function out = setgetVar(data)
            persistent Var;
            if nargin
                Var = data;
            end
            out = Var;
        end
    end
end

