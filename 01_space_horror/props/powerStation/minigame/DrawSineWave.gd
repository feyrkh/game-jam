extends ColorRect
class_name DrawSineWave

const AMP_POSSIBILITIES=7
const MIN_AMP=10
const MAX_AMP=120
const AMP_STEP=(MAX_AMP-MIN_AMP)/AMP_POSSIBILITIES

const PERIOD_POSSIBILITIES=5
const MIN_PERIOD=0.03
const MAX_PERIOD=0.25
const PERIOD_STEP=(MAX_PERIOD-MIN_PERIOD)/PERIOD_POSSIBILITIES

const MOVE_SPEED_POSSIBILITIES=6
const MIN_MOVE_SPEED=1
const MAX_MOVE_SPEED=40
const MOVE_SPEED_STEP=(MAX_MOVE_SPEED-MIN_MOVE_SPEED)/MOVE_SPEED_POSSIBILITIES


var curTime=0
var curTimeIncreasing=true
var amp=10
var per=0.1
var moveSpeed=1.0
var offset


var playerAmp=100
var playerPer=0.1
var playerMoveSpeed=3
var redraw=0.2

func _ready():
	randomize()
	offset = (self.margin_bottom - self.margin_top)/2

func generateRandomSetup():
	var needsRegen = true
	while needsRegen:
		per = pickRandomValue(MIN_PERIOD, PERIOD_POSSIBILITIES, PERIOD_STEP)
		playerPer = pickRandomValue(MIN_PERIOD, PERIOD_POSSIBILITIES, PERIOD_STEP)
		amp = pickRandomValue(MIN_AMP, AMP_POSSIBILITIES, AMP_STEP)
		playerAmp = pickRandomValue(MIN_AMP, AMP_POSSIBILITIES, AMP_STEP)
		moveSpeed = pickRandomValue(MIN_MOVE_SPEED, MOVE_SPEED_POSSIBILITIES, MOVE_SPEED_STEP)
		playerMoveSpeed = pickRandomValue(MIN_MOVE_SPEED, MOVE_SPEED_POSSIBILITIES, MOVE_SPEED_STEP)
		needsRegen = checkSuccess() > 0
	update()
	
func pickRandomValue(minVal, possibilities, step):
	return minVal + step*(randi()%possibilities)
	
func _draw():
	var step = 1
	for t in range(0, ((self.margin_right - self.margin_left))*1, step):
		draw_line(Vector2(t, offset + amp*sin(per*t+curTime*moveSpeed)), Vector2((t+step), offset + amp*sin(per*(t+step)+curTime*moveSpeed)), ColorN("red"), 3)
	for t in range(0, ((self.margin_right - self.margin_left))*1, step):
		draw_line(Vector2(t, offset + playerAmp*sin(playerPer*t+curTime*playerMoveSpeed)), Vector2((t+step), offset + playerAmp*sin(playerPer*(t+step)+curTime*playerMoveSpeed)), ColorN("green"), 2)

func _process(delta):
	redraw -= delta
	if curTimeIncreasing: 
		curTime += delta
		if curTime > 30: curTimeIncreasing = false
	else:
		curTime -= delta
		if curTime < 0: curTimeIncreasing = true
	if redraw <= 0:
		update()

func incrementPeriod():
	playerPer = incrementValue(playerPer, MIN_PERIOD, MAX_PERIOD, PERIOD_STEP)
	
func incrementAmplitude():
	playerAmp = incrementValue(playerAmp, MIN_AMP, MAX_AMP, AMP_STEP)
	
func incrementMoveSpeed():
	playerMoveSpeed = incrementValue(playerMoveSpeed, MIN_MOVE_SPEED, MAX_MOVE_SPEED, MOVE_SPEED_STEP)

func incrementValue(curVal, minVal, maxVal, increment):
	var result = curVal + increment
	if result >= maxVal: result = minVal
	update()
	return result
	
func checkSuccess():
	var newPowerLevel = 0
	if abs(playerPer - per) < 0.0001: newPowerLevel+=1
	if abs(playerAmp - amp) < 0.0001: newPowerLevel+=1
	if abs(playerMoveSpeed - moveSpeed) < 0.0001: newPowerLevel+=1
	if get_parent().controlPanel: get_parent().controlPanel.setPowerLevel(newPowerLevel)
	$Label.text = "p: "+str(per)+" vs "+str(playerPer)+"\na: "+str(amp)+" vs "+str(playerAmp)+"\ns: "+str(moveSpeed)+" vs "+str(playerMoveSpeed)
	return newPowerLevel
