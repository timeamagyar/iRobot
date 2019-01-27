classdef Recover < Behavior
    
    properties(Access= 'private')
        priority
    end
    
    properties(Constant)
        Name = 'Recover';
    end
    
    methods(Access= 'public')
        % Constructor
        function obj = Recover(priority)
            obj.priority = priority;
        end
         % Reactive
        function bid = takeControl(~,sensors)
            % Crash detected
            bid = sensors.getBumpFront || sensors.getBumpLeft || sensors.getBumpRight;
        end
        
        function action(obj,serPort,sensors)
            States.setgetVar(States.Recover);
            if sensors.getBumpFront
                % Stop
                SetDriveWheelsCreate(serPort, 0, 0);
                % Drive backward
                travelDist(serPort,.3,-1);
                % Randomize to prevent oscillations
                randomAngle = obj.randomize(80, 100);
                % Turn right
                turnAngle (serPort, .2, -randomAngle);
            elseif sensors.getBumpRight
                % Stop
                SetDriveWheelsCreate(serPort, 0, 0);
                % Drive backward
                travelDist(serPort,.3,-1);
                % Randomize to prevent oscillations
                randomAngle = obj.randomize(65, 75);
                % Turn left
                turnAngle (serPort, .2, randomAngle);
            elseif sensors.getBumpLeft
                % Stop
                SetDriveWheelsCreate(serPort, 0, 0);
                % Drive backward
                travelDist(serPort,.3,-1);
                % Randomize to prevent oscillations
                % Turn right by random angle between -65 and -75 to prevent
                randomAngle = obj.randomize(-65, -75);
                % oscillations
                turnAngle (serPort, .2, randomAngle);
            end
        end
        
        function randomAngle = randomize(~,lowerBoundary,upperBoundary)
            rng(0,'twister');
            randomAngle = (upperBoundary-lowerBoundary).*rand() + lowerBoundary;
        end
    end
    
    methods 
        function Priority = getPriority(obj)
            Priority = obj.priority;
        end
    end
end

