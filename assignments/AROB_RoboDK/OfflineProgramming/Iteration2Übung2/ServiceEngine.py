import robodk.robolink as rl
import robodk.robomath as rm


class ServiceEngine:
    """Handles all movements functions to service positions
    """

    robot : rl.Item = None

    pHome = rm.xyzrpw_2_pose([400.0,600.0,400.0,0.0,180.0,0.0])
    pStart = rm.xyzrpw_2_pose([400.0,350.0,200.0,0.0,180.0,0.0])


    def __init__(self, robot : rl.Item):
        """Initalization requires a reference to the robot
        @param robot Reference to robot.
        """
        self.robot = robot
    
    def MoveToHome(self):
        self.robot.MoveJ(self.pHome)
        pass
  
    def MoveToStart(self):
        self.robot.MoveJ(self.pStart)
        pass