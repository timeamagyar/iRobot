classdef Aim < Behavior
    
    properties(Constant)
        Name = 'Aim';
    end
    
    properties(Access= 'private')
        priority
    end
    
    methods(Access= 'public')
        % Constructor
        function obj = Aim(priority)
            if nargin == 1
                obj.priority = priority;
            end
        end
       
        function bid = takeControl(~,sensors)
            Camera = sensors.getAngleToBeacon;
            % Bid if beacon detected 
            bid = any(Camera) && sensors.getDistToBeacon > 0.07;
          
        end
        
        function action(~,serPort,sensors)
            % Aim at beacon if detected
            States.setgetVar(States.Aim);
            Environment.setgetVar(Environment.Outdoor);
            if any(sensors.getAngleToBeacon) && abs(sensors.getAngleToBeacon) > 0.07
                turnAngle(serPort, .2, (sensors.getAngleToBeacon * 6));
            end
            
            SetDriveWheelsCreate(serPort, .5, .5);
            pause (.1);
        end
    end
    
    methods
        function Priority = getPriority(obj)
            Priority = obj.priority;
        end
    end
end

