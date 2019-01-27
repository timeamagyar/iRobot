classdef Behavior < handle
 
    methods(Abstract)
        % Indicates if this behavior should gain control
        takeControl(obj,sensors)
        % Repesents the actions the robot performs when the behavior is
        % active. If the action(s) complete the method return.
        % It also returns if the suppress() method is called by the
        % arbitrator. In either case, the robot must be in a safe state for
        % another behavior to execute, when it becomes active.
        action(obj,serPort,sensors)
    end
 
    
end

