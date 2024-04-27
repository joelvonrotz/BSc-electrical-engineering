import robodk.robolink as rl
import robodk.robomath as rm
import LetterEngine

class WritingManager:
  LE : LetterEngine.LetterEngine = None

  def __init__(self, robot : rl.Item, rdk):
    self.LE = LetterEngine.LetterEngine(robot, rdk)
    pass
    
  def WriteText(self, text, start_pose):
    self.LE.DrawText(text, start_pose)
  def WriteHello(self, start_pose):
    self.LE.DrawText("Hello", start_pose)