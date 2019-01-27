classdef Sensors < handle
    
    properties(Access = 'private')
        serPort        % Robot serial port
        angleToBeacon  % Angle to beacon
        distToBeacon   % Distance to beacon
        colourOfBeacon % Colour of beacon
        bumpFront      % Front Bump Sensor
        bumpLeft       % Left Bump Sensor
        bumpRight      % Right Bump Sensor
        leftSonar      % Left Sonar
        frontSonar     % Front Sonar
        lidarRes       % Lidar
    end
    
    methods(Access = 'public')
        % Constructor
        function obj = Sensors(serPort)
            if nargin == 1
                obj.serPort = serPort;
                % Bumper readings
                obj.bumpFront = false;
                obj.bumpLeft = false;
                obj.bumpRight = false;
                % Camera readings
                obj.angleToBeacon = 0;
                obj.distToBeacon = 100;
                obj.colourOfBeacon = [];
                % Sonar readings
                obj.leftSonar = 100;
                obj.frontSonar = 100;
                % Lidar readings
                obj.lidarRes = LidarSensorCreate(serPort);
            end
        end
        
        function readBumps(obj)
            [BumpRight,BumpLeft,~,~,~,BumpFront] = BumpsWheelDropsSensorsRoomba(obj.serPort);
            obj.bumpFront = BumpFront;
            obj.bumpLeft = BumpLeft;
            obj.bumpRight = BumpRight;
        end
        
        function readCamera(obj)
            % Read the camera sensor
            [Angle, Distance, Colour] = CameraSensorCreate(obj.serPort);
            % Take the first beacon detected
            if(~isempty(Angle))
                obj.angleToBeacon = Angle(1);
            else
                obj.angleToBeacon = 0;
            end
            if(~isempty(Distance))
                obj.distToBeacon = Distance(1);
            else
                obj.distToBeacon = 100;
            end
            if(~isempty(Colour))
                obj.colourOfBeacon = Colour(1,:);
            else
                obj.colourOfBeacon = [];
            end
        end
        
        function readSonar(obj)
            SonRead = ReadSonar(obj.serPort, 3);
            % Left Sonar
            if ~any(SonRead)
                obj.leftSonar = 100;
            else
                obj.leftSonar = SonRead;
            end
            SonRead = ReadSonar(obj.serPort, 2);
            % Front Sonar
            if ~any(SonRead)
                obj.frontSonar = 100;
            else
                obj.frontSonar = SonRead;
            end
        end
        
        function readLidar(obj)
            obj.lidarRes = LidarSensorCreate(obj.serPort);
        end
        
        
        function Colour = getColourOfBeacon(obj)
            Colour = obj.colourOfBeacon;
        end
        
        function Distance = getDistToBeacon(obj)
            Distance = obj.distToBeacon;
        end
        
        function Camera = getAngleToBeacon(obj)
            Camera = obj.angleToBeacon;
        end
        
        function LidarRes = getLidarRes(obj)
            LidarRes = obj.lidarRes;
        end
        
        function LeftSonar = getLeftSonar(obj)
            LeftSonar = obj.leftSonar;
        end
        
        function FrontSonar = geFrontSonar(obj)
            FrontSonar = obj.frontSonar;
        end
        
        function BumpFront = getBumpFront(obj)
            BumpFront = obj.bumpFront;
        end
        
        function BumpLeft = getBumpLeft(obj)
            BumpLeft = obj.bumpLeft;
        end
        
        function BumpRight = getBumpRight(obj)
            BumpRight = obj.bumpRight;
        end
    end
end

