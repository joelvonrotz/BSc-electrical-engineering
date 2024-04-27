import robodk.robolink as rl
import robodk.robomath as rm

BASE_Z_OFFSET = 478.000

LETTER_HEIGHT = 70 # [mm]
LETTER_WIDTH = 40 # [mm]
LETTER_RATIO = LETTER_HEIGHT / LETTER_WIDTH
LETTER_SPACING = 10 # [mm]
# Letters 
dictLetters = {
    "H": {
        "width": LETTER_WIDTH,
        "liftoff": True, # lift off is only used between the lines, entry and exit liftoff are always done
                        #   X   Y
        "coordinates": [[[0.0,0.0],[0.0,1.0]], # |
                        [[0.0,0.5],[1.0,0.5]], # |-
                        [[1.0,1.0],[1.0,0.0]]] # H         relative coordinates [WIDTH, HEIGHT]
    },
    "E": {
        "width": LETTER_WIDTH,
        "liftoff": True,
        "coordinates": [[[0.0,0.0],[0.0,1.0]], # |
                        [[0.0,1.0],[1.0,1.0]], # |-
                        [[0.0,0.5],[1.0,0.5]], # |=
                        [[0.0,0.0],[1.0,0.0]]] # E
    },
    "L": {
        "width": LETTER_WIDTH,
        "liftoff": True,
        "coordinates": [[[0.0,0.0],[0.0,1.0]], # |
                        [[0.0,0.0],[1.0,0.0]]] # L
    },
    "O": {
        "width": LETTER_WIDTH,
        "liftoff": False,
        "coordinates": [[[0.0,0.3],[0.0,0.7]], # |
                        [[0.0,0.7],[0.5,1.0],[1.0,0.7]], # draw the top using circular movement
                        [[1.0,0.7],[1.0,0.3]], # 
                        [[1.0,0.3],[0.5,0.0],[0.0,0.3]]] 
    },
    "J": {
        "width": LETTER_WIDTH,
        "liftoff": False,
        "coordinates": [[[9.0,0.3],[0.5,0.0],[1.0,0.3]], # |
                        [[1.0,0.3],[1.0,1.0]]]
    },
    " ": {
        "width": 0,
        "liftoff": True,
        "coordinates": [[[0.0,0.0],[0.0,0.0]]]
    },
}

class LetterEngine:
    """Handles all movements functions to service positions
    """
    robot : rl.Item = None
    rdk = None

    def __init__(self, robot : rl.Item, rdk):
        """Initalization requires a reference to the robot
        @param robot Reference to robot.
        """
        self.rdk = rdk
        self.robot = robot
    
    # draws
    def DrawText(self, text, start_pose):
        text = text.upper()
        for idx, letter in enumerate(text):
            objLetter = dictLetters[letter]
            coordLetter = objLetter["coordinates"]

            letter_height = LETTER_HEIGHT
            letter_width = objLetter["width"]
            # 
            for idx2, line in enumerate(coordLetter):
                # determine movement type
                if len(line) == 2: # MoveL
                    x1 = -line[0][0] * letter_width
                    y1 = -line[0][1] * letter_height
                    x2 = -line[1][0] * letter_width
                    y2 = -line[1][1] * letter_height
                    pRelativeStart = rm.xyzrpw_2_pose([y1,x1,0.0,0.0,0.0,0.0])
                    pRelativeEnd = rm.xyzrpw_2_pose([y2,x2,0.0,0.0,0.0,0.0])
                    pStart = start_pose * pRelativeStart
                    pEnd = start_pose * pRelativeEnd
                    if (objLetter["liftoff"] == True) or (idx2 == 0):
                        self.rdk.Command("Trace","On")
                        self.robot.MoveL(pStart * rm.transl(0.0,0.0,-10.0)) # move over starting point
                    self.robot.MoveL(pStart)
                    self.robot.MoveL(pEnd)
                    if (objLetter["liftoff"] == True) or (idx2 == (len(coordLetter))-1):
                        self.robot.MoveL(pEnd * rm.transl(0.0,0.0,-10.0)) # move over starting point
                        self.rdk.Command("Trace","Off")
                elif len(line) == 3: # MoveC
                    x1 = -line[0][0] * letter_width
                    y1 = -line[0][1] * letter_height
                    x2 = -line[1][0] * letter_width
                    y2 = -line[1][1] * letter_height
                    x3 = -line[2][0] * letter_width
                    y3 = -line[2][1] * letter_height

                    pRelativeStart = rm.xyzrpw_2_pose([y1,x1,0.0,0.0,0.0,0.0])
                    pRelativeMidPoint = rm.xyzrpw_2_pose([y2,x2,0.0,0.0,0.0,0.0])
                    pRelativeEnd = rm.xyzrpw_2_pose([y3,x3,0.0,0.0,0.0,0.0])
                    pStart = start_pose * pRelativeStart
                    pMidPoint = start_pose * pRelativeMidPoint
                    pEnd = start_pose * pRelativeEnd

                    if (objLetter["liftoff"] == True) or (idx2 == 0):
                        self.rdk.Command("Trace","On")
                        self.robot.MoveL(pStart * rm.transl(0.0,0.0,-10.0)) # move over starting point
                    
                    self.robot.MoveL(pStart)
                    self.robot.MoveC(pMidPoint,pEnd)

                    if (objLetter["liftoff"] == True) or (idx2 == (len(coordLetter))-1):
                        self.robot.MoveL(pEnd * rm.transl(0.0,0.0,-10.0)) # move over starting point
                        self.rdk.Command("Trace","Off")
                    pass
            start_pose = start_pose * rm.transl(0.0,-(LETTER_SPACING+letter_width)) # update the starting position
            # exit lift off
        pass
