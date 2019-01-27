classdef States
    enumeration
        Init
        Follow
        Align
        Pass
        Aim
        Recover
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
