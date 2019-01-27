classdef AlignAperture < Align
    
    properties(Constant)
        Name = 'AlignAperture';
    end
    
    properties(Access= 'private')
        priority;
    end
    
    methods(Access= 'public')
        % Constructor
        function obj = AlignAperture(priority)
            if (nargin == 1)
                obj.priority = priority;
            end
        end
        
        % Planning
        function bid = takeControl(~,~)
            apertureSeen = Aperture.lowerIdx~=0 && Aperture.upperIdx ~= 0;
            disp("apertureSeen " + apertureSeen);
            bid = apertureSeen && ((States.setgetVar == States.Follow) || (States.setgetVar == States.Init) || (States.setgetVar == States.Recover));
        end
        
        function action(obj,serPort,sensors)
            States.setgetVar(States.Align);
            alignAperture(obj,serPort,sensors);
        end
        
        function alignAperture(obj,serPort,~)
            States.setgetVar(States.Align);
            A = Aperture.lowerIdx;
            B = Aperture.upperIdx;
            orientation = Aperture.orientation;
            alpha = Aperture.alpha;
            diagonal = Aperture.vertexC;
            offset = Aperture.vertexB/2;
            
            obj.align(A,B,orientation,alpha,diagonal,offset,serPort);
        end
        
    end
    
    methods
        function Priority = getPriority(obj)
            Priority = obj.priority;
        end
    end
end
