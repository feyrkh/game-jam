extends Node2D

class_name PowerStationControlPanel

signal controlPanelOpened
signal controlPanelClosed

export var powerLevel = 0
export var failureShakeSecondsPerPowerLevel = 0.3

var shaking=0.0

func _ready():
	emit_signal("controlPanelOpened")
	set_process_input(true)
	
func _process(delta):
	if shaking<=0: return
	position.x = rand_range(-30, 30)
	position.y = rand_range(-30, 30)
	shaking -= delta
	if shaking <= 0:
		position.x = 0
		position.y = 0
	
func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		self.queue_free()
		emit_signal("controlPanelClosed", powerLevel)
		get_tree().set_input_as_handled()

func setPowerLevel(newPowerLevel):
	powerLevel = newPowerLevel
	var powerLabel:Label = find_node("PowerLabel")
	powerLabel.text = "Power level: "+str(newPowerLevel)

func powerUp():
	setPowerLevel(min(3, powerLevel+1))
	
func powerDown():
	setPowerLevel(max(0, powerLevel-1))
	shaking = failureShakeSecondsPerPowerLevel * powerLevel + 0.05

