classdef Goal < handle
    
    methods(Abstract)
        % Indicates if goal is fulfilled
        isReached(obj,sensors)      
    end
    
end

