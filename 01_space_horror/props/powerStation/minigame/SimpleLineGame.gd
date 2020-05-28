extends BaseMinigame

enum MarkerMoveStyle {Bounce, WrapLeft, WrapRight}

export var minSecondsPerBounce = 0.5
export var maxSecondsPerBounce = 2.0
export var markerSpeedIncreasePerDifficultyLevel = 0.2
export var successWidth = 60
export var successDifficultyPenalty = 15
export var successLineMaxPercentOffsetFromCenter = 100
export(Color) var markerInZoneColor = Color(0, 1.0, 1.0, 1.0)
export(Color) var markerOutOfZoneColor = Color(1.0, 0, 0, 1.0)

var markerPixelsPerSec
var successLineStart
var successLineEnd
var markerX
var markerResetStyleBounce
var markerDirection
var markerMoveStyle


export(NodePath) var dangerLinePath
export(NodePath) var successLinePath
export(NodePath) var markerPath
var dangerLine:Line2D
var successLine:Line2D
var marker:Line2D
	
func setupGame():
	.setupGame()
	dangerLine = get_node(dangerLinePath)
	successLine = get_node(successLinePath)
	marker = get_node(markerPath)
	match randi()%4:
		0,1: markerMoveStyle = MarkerMoveStyle.Bounce
		2: markerMoveStyle = MarkerMoveStyle.WrapLeft
		3: markerMoveStyle = MarkerMoveStyle.WrapRight
		
	moveMarkerTo(rand_range(dangerLine.points[0].x, dangerLine.points[-1].x))

	var successLineWidth = successWidth - successDifficultyPenalty*difficultyLevel
	var maxSuccessLinePosition = (successLineMaxPercentOffsetFromCenter/100.0 * (dangerLine.points[-1].x - successLineWidth))
	var successLineOffset = rand_range(-maxSuccessLinePosition, maxSuccessLinePosition)
	successLine.points[1].x = successLineOffset
	successLine.points[0].x = successLineOffset-successLineWidth
	successLine.points[2].x = successLineOffset+successLineWidth
	var secondsPerBounce = rand_range(minSecondsPerBounce, maxSecondsPerBounce) -  (markerSpeedIncreasePerDifficultyLevel * difficultyLevel)
	markerPixelsPerSec = (dangerLine.points[-1].x - dangerLine.points[0].x)/secondsPerBounce
	markerDirection = randi() % 2
	if markerDirection == 0: markerDirection = -1
	
func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		if markerInsideSuccessZone():
			controlPanel.powerUp()
		else: 
			controlPanel.powerDown()
		setupGame()
		get_tree().set_input_as_handled()

func markerInsideSuccessZone():
	var markerX = marker.points[0].x	
	return (markerX >= successLine.points[0].x) and (markerX <= successLine.points[-1].x)
	
func moveMarkerTo(xCoord):
	marker.points[0].x = xCoord
	marker.points[1].x = xCoord
	setMarkerColor()

func setMarkerColor():
	if markerInsideSuccessZone(): 
		marker.default_color = markerInZoneColor
	else: 
		marker.default_color = markerOutOfZoneColor

func _process(delta):
	if !isSetup: return
	match markerMoveStyle:
		MarkerMoveStyle.Bounce: processBounceMove(delta)
		MarkerMoveStyle.WrapLeft: processWrapLeftMove(delta)
		MarkerMoveStyle.WrapRight: processWrapRightMove(delta)
	
func processBounceMove(delta):
	var newMarkerX = marker.points[0].x + (markerDirection * markerPixelsPerSec * delta)
	newMarkerX = max(dangerLine.points[0].x, newMarkerX)
	newMarkerX = min(dangerLine.points[-1].x, newMarkerX)
	moveMarkerTo(newMarkerX)
	if newMarkerX == dangerLine.points[0].x: markerDirection = 1
	if newMarkerX == dangerLine.points[1].x: markerDirection = -1
	
func processWrapLeftMove(delta):
	var newMarkerX = marker.points[0].x - (markerPixelsPerSec * delta)
	newMarkerX = max(dangerLine.points[0].x, newMarkerX)
	moveMarkerTo(newMarkerX)
	if newMarkerX == dangerLine.points[0].x: moveMarkerTo(dangerLine.points[-1].x)
	
func processWrapRightMove(delta):
	var newMarkerX = marker.points[0].x + (markerPixelsPerSec * delta)
	newMarkerX = min(dangerLine.points[-1].x, newMarkerX)
	moveMarkerTo(newMarkerX)
	if newMarkerX == dangerLine.points[-1].x: moveMarkerTo(dangerLine.points[0].x)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
