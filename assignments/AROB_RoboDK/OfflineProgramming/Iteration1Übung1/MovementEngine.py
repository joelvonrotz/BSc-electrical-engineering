import robodk.robolink as rl
import robodk.robomath as rm

BASE_Z_OFFSET = 478.000

class MovementEngine:
    """Handles all movements functions to service positions
    """
    robot : rl.Item = None

    def __init__(self, robot : rl.Item):
        """Initalization requires a reference to the robot
        @param robot Reference to robot.
        """
        self.robot = robot
    
    def MoveTableCorners(self):
        pCornerFrontLeft = rm.xyzrpw_2_pose([ 520.0,   330.0,   467 - BASE_Z_OFFSET, 0.0, 180.0, 0.0])
        pCornerFrontRight = rm.xyzrpw_2_pose([   520.0,  -330.0,   467 - BASE_Z_OFFSET, 0.0, 180.0, 0.0])
        pCornerBackRight = rm.xyzrpw_2_pose([  1180.0,  -330.0,   467 - BASE_Z_OFFSET, 0.0, 180.0, 0.0])
        pCornerBackLeft = rm.xyzrpw_2_pose([  1180.0,   330.0,   467 - BASE_Z_OFFSET, 0.0, 180.0, 0.0])
        
        self.robot.MoveL(pCornerFrontLeft)
        self.robot.MoveJ(pCornerFrontRight)
        self.robot.MoveL(pCornerBackRight)
        self.robot.MoveL(pCornerBackLeft)
        self.robot.MoveL(pCornerFrontLeft)
        pass
  