import robodk.robolink as rl
import robodk.robomath as rm
from MovementEngine import *
from ServiceEngine import *


RDK = rl.Robolink()

robot = RDK.Item("Staubli TX2-90L", rl.ITEM_TYPE_ROBOT)
robot.setAccelerationJoints(10)
robot.setSpeedJoints(30)

# rev up the engines
ME = MovementEngine(robot)
SE = ServiceEngine(robot)

SE.MoveToHome()
SE.MoveToStart()
ME.MoveTableCorners()
SE.MoveToStart()
SE.MoveToHome()


