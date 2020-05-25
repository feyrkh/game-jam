extends Camera2D

class_name MixedModeCamera

var target:Node2D
export var targetPath:NodePath
export var following:bool = false

var lastEnteredRegion

func _ready():
	target = get_node(targetPath)
	
func _physics_process(delta):
	if following:
		position = target.position

func on_fixed_mode_entered(fixedArea:Position2D):
	lastEnteredRegion = fixedArea
	following = false
	position = fixedArea.position

func on_fixed_mode_exited(fixedArea:Position2D):
	if lastEnteredRegion == fixedArea:
		following = true
		print_debug("Following the player now")
