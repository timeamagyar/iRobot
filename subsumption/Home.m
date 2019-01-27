classdef Home < Goal
    
    properties(Constant)
        Name = 'Home';
    end
    
    properties(Access = 'private')
        previousDistance;
        dependencies;
    end
    
    methods
        % Constructor
        function obj = Home(dependencies)
            obj.previousDistance = 100;
            obj.dependencies = dependencies;
        end
        
        function reached = isReached(obj,sensors)
            reached = (~any(sensors.getAngleToBeacon) && obj.previousDistance < 0.2);
            obj.previousDistance = sensors.getDistToBeacon;
        end
    end
    
     methods
        function Dependencies = getDependencies(obj)
            Dependencies = obj.dependencies;
        end
    end
end

