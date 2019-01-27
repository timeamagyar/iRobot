classdef FollowLidar < Behavior
    
    properties(Constant)
        KP = 250;
        KD = 25;
        KI = 0;
        Eps = 0.001;
        Name = 'FollowLidar';
    end
    
    properties(Access= 'private')
        priority
        pidController
    end
    
    
    methods(Access= 'public')
        % Constructor
        function obj = FollowLidar(priority)
            obj.priority = priority;
            obj.pidController = SPid(FollowLidar.KP,FollowLidar.KI,FollowLidar.KD,FollowLidar.Eps);
        end
        % Reactive
        function bid = takeControl(~,~)
            bid = true;
        end
        
        function action(obj,serPort,sensors)
            States.setgetVar(States.Follow);
            if(Environment.setgetVar == Environment.Indoor)
                distanceToWall = 0.8;
            else
                distanceToWall = 3;
            end
           
            % Read Left side of Lidar
            LidarRes = sensors.getLidarRes;
            [LidarM, ~] = min(LidarRes(341:681));
            % Calculate error
            DError = LidarM - distanceToWall;
            % Set to moving average of errors to zero since integral control is turned off
            ErrorV = 0;
            % Calculate controller output
            KOut = updatePid(obj.pidController,DError,LidarM,ErrorV);
            % We also need to limit the action, in this case max correction to
            % 50 degrees (or -50 but that one is automatically limmited by reading 0)
            if (KOut > 50)
                KOut = 50;
            end
            turnAngle(serPort, .2, KOut);
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

