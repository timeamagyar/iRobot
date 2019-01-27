classdef Cartographer < handle
    methods(Static, Access='public')
        % Dynamically extracts landmarks at runtime derived from sensor
        % data and forwards it to the arbitrator
        function extractLandmarks(LidarRes)
            % Detects aperture
            Aperture.findAperture(LidarRes);
        end
    end
end

