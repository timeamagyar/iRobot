classdef Aperture 
    methods(Static)
        function val = lowerIdx(newval)
            persistent currentval;
            if nargin >= 1
                currentval = newval;
            end
            val = currentval;
        end
        
        function val = upperIdx(newval)
            persistent currentval;
            if nargin >= 1
                currentval = newval;
            end
            val = currentval;
        end
        
        function val = vertexA(newval)
            persistent currentval;
            if nargin >= 1
                currentval = newval;
            end
            val = currentval;
        end
        
        function val = vertexB(newval)
            persistent currentval;
            if nargin >= 1
                currentval = newval;
            end
            val = currentval;
        end
        
        function val = vertexC(newval)
            persistent currentval;
            if nargin >= 1
                currentval = newval;
            end
            val = currentval;
        end
        
        function val = orientation(newval)
            persistent currentval;
            if nargin >= 1
                currentval = newval;
            end
            val = currentval;
        end
        
        function val = alpha(newval)
            persistent currentval;
            if nargin >= 1
                currentval = newval;
            end
            val = currentval;
        end
        
        function val = beta(newval)
            persistent currentval;
            if nargin >= 1
                currentval = newval;
            end
            val = currentval;
        end
        
        function val = gamma(newval)
            persistent currentval;
            if nargin >= 1
                currentval = newval;
            end
            val = currentval;
        end
        
        function findAperture(LidarRes)
            clear Aperture;
            [lowerIdx,upperIdx,a,b,c,alpha,beta,right] = Aperture.findApertureInternal(LidarRes);
            Aperture.lowerIdx(lowerIdx);
            Aperture.upperIdx(upperIdx);
            Aperture.vertexA(a);
            Aperture.vertexB(b);
            Aperture.vertexC(c);
            Aperture.orientation(right);
            Aperture.beta(beta);
            Aperture.alpha(alpha);
            gamma = 180-alpha-beta;
            Aperture.gamma(gamma);
        end
        
        function [lowerIdx, upperIdx, a, b, c,alpha,beta,right] = findApertureInternal(LidarRes)
            % First order derivative of Lidar distance vector on the
            % front-left
            distanceVD = diff(LidarRes);
            % Second order derivative of Lidar distance vector on the
            % front-left
            distanceVD = diff(distanceVD);
            % Focus on big discontinuities indicating an aperture, by applying a
            % threshold
            idx = abs(distanceVD)>1;
            % Apply mask
            distanceVD(~idx) = 0;
            % Compute changes in signs
            distanceVD=diff(sign(distanceVD),1,2);
            % -2 if went from positive to negative AND 2 if went from
            % negative to positive indicating the entrance/exit of the
            % room
            distinctivePoints = [find(distanceVD==-2) find(distanceVD==2)];
            distinctivePoints = sort(distinctivePoints);
            if(length(distinctivePoints)>=2)
                for n=1:(length(distinctivePoints)-1)
                    lowerIdx = distinctivePoints(n);
                    if (distanceVD(lowerIdx) == -2)
                        upperIdx = distinctivePoints(n+1);
                        if((distanceVD(lowerIdx) == -2) && (upperIdx > lowerIdx))
                            lowerIdx = lowerIdx + 1;
                            upperIdx = upperIdx + 2;
                            dUIdx = LidarRes(upperIdx);
                            dLIdx = LidarRes(lowerIdx);
                            right = dUIdx-dLIdx <0;
                            if(right) % Orientation right
                                a = LidarRes(upperIdx);
                                c = LidarRes(lowerIdx);
                                
                            else % Orientation left
                                a = LidarRes(lowerIdx);
                                c = LidarRes(upperIdx);
                            end
                            beta = 240/681*(upperIdx-lowerIdx);
                            b = Triangle.computeVertex(a,c,beta);
                            alpha = Triangle.computeAlpha(a,b,c);
                            if(isnan(alpha))
                                alpha = 0;
                            end
                         
                            % Aperture found
                            break;
                        end
                    end
                    % Reset if no match
                    lowerIdx = 0;
                    upperIdx = 0;
                    a = 0;
                    b = 0;
                    c = 0;
                    beta = 0;
                    right = 0;
                    alpha = 0;
                end
            else
                % Initialize if no match
                lowerIdx = 0;
                upperIdx = 0;
                a = 0;
                b = 0;
                c = 0;
                beta = 0;
                right = 0;
                alpha = 0;
            end
            
        end
        
    end
end

