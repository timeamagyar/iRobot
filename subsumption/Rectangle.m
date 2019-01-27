classdef Rectangle
    
   methods(Static)
       function b = calculateDistance(diagonal,alpha)
           a = diagonal*cosd(alpha);
           b = sqrt(power(diagonal,2)-power(a,2)); 
       end
    end
end

