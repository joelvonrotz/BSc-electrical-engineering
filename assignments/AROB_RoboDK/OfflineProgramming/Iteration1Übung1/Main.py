import robodk.robolink as rl
import robodk.robomath as rm
from WritingManager import *
from ServiceEngine import *


RDK = rl.Robolink()


robot = RDK.Item("Staubli TX2-90L", rl.ITEM_TYPE_ROBOT)
robot.setAccelerationJoints(10)
robot.setSpeedJoints(30)

start_pose = rm.xyzrpw_2_pose([   700.0,   200.0,   -5.5, 0.0, 180.0, 0.0 ])

RDK.Command("Trace","Reset")
RDK.Command("Trace","Off")
# rev up the engines
WM = WritingManager(robot,RDK)
SE = ServiceEngine(robot)

RDK.Command("Trace","Off")

SE.MoveToHome()
SE.MoveToStart()

#WM.WriteHello(start_pose)
WM.WriteText("Hello Joel", start_pose)
SE.MoveToStart()
SE.MoveToHome()


