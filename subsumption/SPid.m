classdef SPid < handle
    properties
        dState      % last position input
        iState      % integrator state
        epsilon     % minimum allowable integrator state
        iGain       % integral gain
        pGain       % proportional gain
        dGain       % derivative gain 
        terms       % container for proportional, integral and derivative gains
    end
    
    methods(Access= 'public')
        % Constructor
        function obj = SPid(pGain,iGain,dGain,epsilon)
            obj.pGain = pGain;
            obj.iGain = iGain;
            obj.dGain = dGain;
            obj.dState = 0;
            obj.iState = 0;
            obj.epsilon = epsilon;
            obj.terms = {};
        end
        % Controller Ouput
        function kOut = updatePid(obj,error,position,errorV)
            % Calculate proportional term
            pTerm = obj.pGain * error;
            % Calculate integral state
            obj.iState = sum(errorV);
            if(abs(obj.iState) < obj.epsilon)
                % Settled down - stop 
                obj.iState = 0;
            end
            % Calculate integral term
            iTerm = obj.iGain * obj.iState;
            % calculate derivative term
            dTerm = 0;
            if(any(obj.dState))
                dTerm = obj.dGain*(obj.dState-position);
            else 
                disp("dState bug")
            end
            % Calculate derivative state
            obj.dState = position;
            kOut = pTerm + iTerm + dTerm;
            disp("obj.iState " + obj.iState);
            obj.terms = [obj.terms; {pTerm,iTerm,dTerm,kOut,abs(obj.iState)};];
        end
    end
    methods(Static, Access= 'public')
        % Output Travel
        function kOutTravel = calculateOutputTravel(kOutL)
            kOutTravel = 0;
            for i=1:(length(kOutL)-1)
                kOutTravel = kOutTravel + abs(kOutL(i+1)-kOutL(i));
            end
        end
        % Output Reversals
        function kOutReversals = calculateOutputReversals(kOutL)
            kOutReversals = 0;
            for i=1:(length(kOutL)-2)
                sample = (kOutL(i+1)-kOutL(i))*(kOutL(i+2)-kOutL(i+1));
                if(sample < 0)
                   kOutReversals = kOutReversals + 1;
                end 
            end
        end
        % Absolute Average Error
        function aae = calculateAae(errorL)
            aae = mae(errorL);
        end
    end
  
end