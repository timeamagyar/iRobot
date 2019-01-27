classdef Exit < Goal
    
    properties(Constant)
        Name = 'Exit';
    end
    
    properties(Access = 'private')
        dependencies;
    end
    
    methods
        % Constructor
        function obj = Exit(dependencies)
            obj.dependencies = dependencies;
        end
        
        function reached = isReached(~,~)
            % Robot went outdoor
            reached = Environment.setgetVar == Environment.Outdoor;
        end
        
    end
    
    methods
        function Dependencies = getDependencies(obj)
            Dependencies = obj.dependencies;
        end
    end
end

