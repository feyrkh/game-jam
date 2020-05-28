extends Node2D

var markerPixelsPerSec
var successLineStart
var successLineEnd
var markerX
var markerResetStyleBounce
var markerDirection

onready var dangerLine:Line2D = $DangerLine
onready var successLine:Line2D = $DangerLine/SuccessLine
onready var marker:Line2D = $DangerLine/Marker

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	setupGame(0)
	
func _process(delta):
	var newMarkerX = marker.points[0].x + (markerDirection * markerPixelsPerSec * delta)
	newMarkerX = max(dangerLine.points[0].x, newMarkerX)
	newMarkerX = min(dangerLine.points[-1].x, newMarkerX)
	print_debug("newMarkerX: ", newMarkerX)
	marker.points[0].x = newMarkerX
	marker.points[1].x = newMarkerX
	if newMarkerX == dangerLine.points[0].x: markerDirection = 1
	if newMarkerX == dangerLine.points[1].x: markerDirection = -1
	
func setupGame(powerLevel:int):
	marker.position.x = rand_range(dangerLine.points[0].x, dangerLine.points[-1].x)
	var successLineWidth = 60 - 15*powerLevel
	var maxSuccessLinePosition = dangerLine.points[-1].x - successLineWidth
	var successLineOffset = rand_range(-maxSuccessLinePosition, maxSuccessLinePosition)
	successLine.points[1].x = successLineOffset
	successLine.points[0].x = successLineOffset-successLineWidth
	successLine.points[2].x = successLineOffset+successLineWidth
	markerPixelsPerSec = rand_range(200, 400) + 30 * powerLevel
	markerDirection = randi() % 2
	if markerDirection == 0: markerDirection = -1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
