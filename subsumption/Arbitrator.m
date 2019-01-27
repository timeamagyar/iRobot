classdef Arbitrator < handle
    
    properties
        serPort
        goals
        sensors
        behaviors
        default
    end
    
    methods(Access= 'public')
        function obj = Arbitrator(serPort,sensors,behaviors,default,goals)
            obj.serPort = serPort;
            obj.sensors = sensors;
            obj.behaviors = behaviors;
            obj.default = default;
            obj.goals = goals;
        end
        
        function start(obj)
            while true
                
                pause (.1);
                % Read all sensor data
                obj.sensors.readBumps();
                obj.sensors.readCamera();
                obj.sensors.readSonar();
                obj.sensors.readLidar();   
                
                LidarRes = obj.sensors.getLidarRes;
                % Dynamically extract local reference systems, will be
                % reset and recomputed in every control cycle
                Cartographer.extractLandmarks(LidarRes);
                
                disp("number of goals  " + obj.goals.size());
             
                % Return the first element of the queue
                activeGoal = obj.goals.front();
             
                reached = isReached(activeGoal,obj.sensors);
                if(reached)
                    disp("goal " + class(activeGoal) + " reached " + reached);
                    % Goal reached, remove it from plan
                    obj.goals.pop();
                end
                
                if(obj.goals.isempty())
                    break;
                end
               
              
                % Not finished yet, fetch next goal 
                activeGoal = obj.goals.front();
                disp("ActiveGoal " + activeGoal.Name);
                disp("Number of goals left " + obj.goals.size());
                disp("Current state ");
                disp(States.setgetVar);
                disp("Current environment ");
                disp(Environment.setgetVar);

                % Start auction
                activeBehavior = obj.default;
                activeDependencies = activeGoal.getDependencies();
                
                for i=1:length(activeDependencies)
                    dependency = activeDependencies{i};
                    behaviorSet = values(obj.behaviors,{dependency});
                    b = behaviorSet{1};
                    win = b.takeControl(obj.sensors) && (b.getPriority > activeBehavior.getPriority-1);
                    disp("Behaviour " + class(b) + " wins "+ win);
                    if(win)
                        activeBehavior = b;
                    end
                end
                
                % Invoke behavior with highest priority
                activeBehavior.action(obj.serPort,obj.sensors);
            end
        end
    end
      
end

