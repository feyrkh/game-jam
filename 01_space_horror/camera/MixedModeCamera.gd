extends Camera2D

class_name MixedModeCamera

var target:Node2D
export var targetPath:NodePath
export var following:bool = false
export(float) var shakeIntensity = 30
export(float) var shakeDurationSeconds = 1.5
var remainingShakeDurationSeconds = 0
var originalPosition

var fixedX:bool = false
var fixedY:bool = false
var lastX:float
var lastY:float

var shake:float = 0

var lastEnteredRegion

func _ready():
	target = get_node(targetPath)
	visible = true
	pause_mode = PAUSE_MODE_PROCESS
	
func _physics_process(_delta):
	if following:
		position = target.global_position
		if fixedX: position.x = lastX
		if fixedY: position.y = lastY
		
	if remainingShakeDurationSeconds > 0:
		position = originalPosition + Vector2(rand_range(-shakeIntensity, shakeIntensity), rand_range(-shakeIntensity, shakeIntensity))
		remainingShakeDurationSeconds -= _delta
		if remainingShakeDurationSeconds <= 0:
			position = originalPosition

func on_fixed_mode_entered(fixedArea:Position2D, fx:bool, fy:bool, shouldTransition:bool):
	if !fixedX and !fixedY: # if we were in a Center area previously, basically
		shouldTransition = true
	lastEnteredRegion = fixedArea
	following = false
	position = fixedArea.position
	self.fixedX = fx
	self.fixedY = fy
	self.lastX = position.x
	self.lastY = position.y
	

func on_fixed_mode_exited(fixedArea:Position2D, shouldTransition:bool):
	if lastEnteredRegion == fixedArea:
		following = true


func damage():
	remainingShakeDurationSeconds = shakeDurationSeconds
	originalPosition = position
