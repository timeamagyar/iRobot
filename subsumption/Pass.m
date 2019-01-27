classdef Pass < Behavior
    
    properties(Constant)
        Name = 'Pass';
    end
    
    properties(Access= 'private')
        priority;
    end
    
    methods(Access= 'public')
        % Constructor
        function obj = Pass(priority)
            obj.priority = priority;
        end
        
        % Planning
        function bid = takeControl(~,~)
            align = States.setgetVar == States.Align;
            pass = States.setgetVar == States.Pass;
            apertureSeen = Aperture.lowerIdx~=0 && Aperture.upperIdx~=0;
            indoor = Environment.setgetVar == Environment.Indoor;
            bid = (align && apertureSeen)  || (pass && indoor);
        end
        
        function action(~,serPort,~)
            States.setgetVar(States.Pass);
            apertureSeen = Aperture.lowerIdx~=0 && Aperture.upperIdx~=0;
            if(apertureSeen)
                isMiddle =  (Aperture.lowerIdx + Aperture.upperIdx)/2;
                % Follow narrow path situated between the left and right sides of the aperture, avoid
                % bumping to sides of the room
                angleToTurn = (isMiddle-341)*(240/681);
               
                % If angleToTurn negative turn right, else turn left
                turnAngle(serPort, .2, angleToTurn);
                SetDriveWheelsCreate(serPort, 0.2, 0.2);
                pause (0.1);
            else 
                % Aperture lost, mark transition from indoor to outdoor
                if(Environment.setgetVar == Environment.Indoor)
                    Environment.setgetVar(Environment.Outdoor);
                    travelDist(serPort,.5, 2);
                else
                    Environment.setgetVar(Environment.Indoor);
                end
            end
        end
    end
    
    methods
        function Priority = getPriority(obj)
            Priority = obj.priority;
        end
    end
end

