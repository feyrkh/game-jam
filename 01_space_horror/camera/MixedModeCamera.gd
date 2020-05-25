extends Camera2D

class_name MixedModeCamera

var target:Node2D
export var targetPath:NodePath
export var following:bool = false

var lastEnteredRegion

func _ready():
	target = get_node(targetPath)
	
func _physics_process(_delta):
	if following:
		position = target.position

func on_fixed_mode_entered(fixedArea:Position2D):
	lastEnteredRegion = fixedArea
	following = false
	position = fixedArea.position

func on_fixed_mode_exited(fixedArea:Position2D):
	if lastEnteredRegion == fixedArea:
		following = true

func transitionToNextRegion():
	if get_tree() == null:
		return
	get_tree().paused = true
	$AnimationPlayer.play("fadeout")
	yield($AnimationPlayer, "animation_finished")
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	$Timer.start()
	yield($Timer, "timeout")
	$AnimationPlayer.play("fadein")
	yield($AnimationPlayer, "animation_finished")
	get_tree().paused = false
	self.pause_mode = Node.PAUSE_MODE_INHERIT
