classdef (Abstract) Align < Behavior
    
    methods(Access=protected)
        function align(~,lowerIdx,upperIdx,orientation,alpha,diagonal,offset,serPort)
            right = orientation;
            nose = 341;
            if(right) % Orientation right
                % Case 1: orientation right, landmark on the right
                if(nose > lowerIdx)
                    delta = 240/681*abs(nose-lowerIdx);
                    angle = -(alpha + delta);
                % Case 2: orientation right, landmark on the left
                elseif(nose <= lowerIdx)
                    delta = 240/681*abs(nose-lowerIdx);
                    angle = -(alpha - delta);
                end
            else % Orientation left 
                % Case 3: orientation left, landmark on the left
                if(nose <= upperIdx)
                    delta = 240/681*abs(nose-upperIdx);
                    angle = alpha + delta;
                % Case 4: orientation left, landmark on the right
                elseif(nose > upperIdx)
                    delta = 240/681*abs(nose-upperIdx);
                    angle = alpha - delta;
                end
            end
            % Compute distance
            turnAngle(serPort,.2,angle);
            betaRectangle = alpha;
            alphaRectangle = 90-betaRectangle;
            distance = Rectangle.calculateDistance(diagonal,alphaRectangle) - offset;
            travelDist(serPort,.2,distance);
            
            if(right) % landmark to the right side so turn left
                turnAngle(serPort,.2,90);
            else % landmark to the left side so turn right
                turnAngle(serPort,.2,-90);
            end
        end
    end
end

