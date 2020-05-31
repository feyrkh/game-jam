extends Node2D

class_name PowerStationControlPanel

signal controlPanelOpened
signal controlPanelClosed

export var powerLevel = 0
export var failureShakeSecondsPerPowerLevel = 0.3

var shaking=0.0
var minigameConfig

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
		closeControlPanel()
		get_tree().set_input_as_handled()

func setMinigameConfig(config:Dictionary):
	minigameConfig = config
	if minigameConfig == null:
		minigameConfig = {}
	var selectedMinigame
	if $Minigame.get_child_count() > 0:
		if !minigameConfig.has("minigameName"):
			minigameConfig["minigameName"] = $Minigame.get_child(randi()%$Minigame.get_child_count()).name
		var minigameName = minigameConfig["minigameName"]
		for child in $Minigame.get_children():
			if child.name == minigameName: 
				child.visible = true
				selectedMinigame = child
				print_debug("Selected minigame: ", minigameName)
			else:
				child.visible = false
				child.queue_free()
	else: 
		selectedMinigame = $Minigame.get_child(0)
	selectedMinigame.setMinigameConfig(minigameConfig)
	selectedMinigame.setupGame()
	selectedMinigame.saveMinigameConfig()
	updateMinigameText(selectedMinigame.getPowerText(powerLevel))
	return minigameConfig

func damage():
	closeControlPanel()
	
func closeControlPanel():
	self.queue_free()
	emit_signal("controlPanelClosed", powerLevel)

func setPowerLevel(newPowerLevel):
	powerLevel = newPowerLevel
	updateMinigameText(null)
	
func updateMinigameText(text):
	var powerLabel:Label = find_node("PowerLabel")
	if text == null: text = $Minigame.get_children()[0].getPowerText(powerLevel)
	powerLabel.text = text

func powerUp():
	setPowerLevel(min(3, powerLevel+1))
	
func powerDown():
	shaking = failureShakeSecondsPerPowerLevel * powerLevel + 0.05
	setPowerLevel(0)

