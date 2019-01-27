classdef Triangle
     
    methods(Static)
        function OppositeSide = computeVertex(AdjacentSide,Hypothenuse,Angle)
            OppositeSide = sqrt(power(AdjacentSide,2) - 2*AdjacentSide*Hypothenuse*cosd(Angle) + power(Hypothenuse,2));
        end
        
        function alpha = computeAlpha(a,b,c)
            input = (-0.5*power(a,2) + 0.5*power(b,2) + 0.5*power(c,2))/(b*c);
            alpha = acosd(input);
        end
        
        function beta = computeBeta(a,b,c)
            input = (0.5*power(a,2) - 0.5*power(b,2) + 0.5*power(c,2))/(a*c);
            beta = acosd(input);
        end
        
        function distance = computeDistance(beta,gamma,c)
            distance = c*sind(beta)/sind(gamma);
        end
        
        function angle = computeAngle(angle_1, angle_2)
            angle = 180 - angle_1 - angle_2;
        end
    end
end

