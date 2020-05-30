extends Interactable

export(int) var powerLevel = 0 setget setPowerLevel
const ControlPanelScene = preload("res://props/powerStation/PowerStationControlPanel.tscn")

func getPowerLevel():
	return powerLevel
	
func getMaxPowerLevel():
	return 3
	
func setPowerLevel(var amt):
	powerLevel = max(0, min(4, amt));
	match powerLevel:
		0: $AnimatedSprite.play("noPower")
		1: $AnimatedSprite.play("lowPower")
		2: $AnimatedSprite.play("medPower")
		3: $AnimatedSprite.play("hiPower")
		_: 
			powerLevel = 0
			$AnimatedSprite.play("noPower")

func interact():
	.interact()
	disableUserInput()
	var popup:PowerStationControlPanel = ControlPanelScene.instance()
	popup.setPowerLevel(powerLevel)
	popup.connect("controlPanelClosed", self, "restoreUserInput")
	get_tree().get_nodes_in_group("ui_layer")[0].add_child(popup)
		
func disableUserInput():
	for player in get_tree().get_nodes_in_group("player"):
		if player.has_method("disableInput"): player.disableInput()
	
func restoreUserInput(newPowerLevel):
	setPowerLevel(newPowerLevel)
	for player in get_tree().get_nodes_in_group("player"):
		if player.has_method("enableInput"): player.enableInput()
	
