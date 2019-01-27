function iRobotController(serPort)

disp ('==================')
disp ('Program Starting  ')
disp ('------------------')

% Initialize sensors
sensors = Sensors(serPort);

% Init queue
goals = Queue();

% Define goal dependencies 
exitDependencies = {FollowLidar.Name,AlignAperture.Name,Pass.Name,Recover.Name};
homeDependencies = {FollowLidar.Name,Aim.Name,Recover.Name};
% Define goals and add to queue
% First Task - Exit Room
exit = Exit(exitDependencies);
goals.push(exit);
% Second Task - Find Beacon and Dock
home = Home(homeDependencies);
goals.push(home);

% Define behaviors and their priorities
default = FollowLidar(25);
pass = Pass(50);
alignAperture = AlignAperture(75);
aim = Aim(100);
recover = Recover(125);

valueSetBehaviors={default,alignAperture,pass,aim,recover};
keySetBehaviors={FollowLidar.Name,AlignAperture.Name,Pass.Name,Aim.Name,Recover.Name};
% Create behavior vector
behaviors = containers.Map(keySetBehaviors,valueSetBehaviors);

% Create arbitrator
arbitrator = Arbitrator(serPort,sensors,behaviors,default,goals);
States.setgetVar(States.Init);
Environment.setgetVar(Environment.Indoor);
% Start arbitration
start(arbitrator);

% Stop motors
SetDriveWheelsCreate(serPort, 0, 0);
disp ('==================')
disp ('Program Done      ')
disp ('------------------')
