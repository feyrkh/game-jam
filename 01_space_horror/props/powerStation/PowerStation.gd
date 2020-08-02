extends Interactable

onready var EventBus = $"/root/EventBus"

export(int) var powerLevel = 0 setget setPowerLevel
const ControlPanelScene = preload("res://props/powerStation/PowerStationControlPanel.tscn")
var shaking = false
onready var originalPosition = position
var minigameConfig = {}

func _process(_delta):
	if shaking:
		position = originalPosition + Vector2(randi()%3-1, randi()%3-1)

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

func canInteract(equipmentMgr:EquipmentManager):
	return !shaking and powerLevel < getMaxPowerLevel()

func interact(equipmentMgr:EquipmentManager):
	if shaking: return
	.interact(equipmentMgr)
	EventBus.emit_signal("hideControlNote", self)
	disableUserInput()
	var popup:PowerStationControlPanel = ControlPanelScene.instance()
	popup.setPowerLevel(powerLevel)
	minigameConfig = popup.setMinigameConfig(minigameConfig)
	popup.connect("controlPanelClosed", self, "restoreUserInput")
	get_tree().get_nodes_in_group("ui_layer")[0].add_child(popup)
		
func disableUserInput():
	for player in get_tree().get_nodes_in_group("player"):
		if player.has_method("disableInput"): player.disableInput()
	
func restoreUserInput(newPowerLevel):
	setPowerLevel(newPowerLevel)
	for player in get_tree().get_nodes_in_group("player"):
		if player.has_method("enableInput"): player.enableInput()

func damage():
	$AnimatedSprite.play("damaged")
	shaking = true
	var timer = get_tree().create_timer(rand_range(3, 5))
	yield(timer, "timeout")
	setPowerLevel(powerLevel - randi()%3 - 1)
	shaking = false
	position = originalPosition

func _on_ActivationArea_area_entered(area):
	if canInteract(area.get_parent().get_node_or_null("EquipmentMgr")): EventBus.emit_signal("showControlNote", "Shield Console: Press E to repair", self)


func _on_ActivationArea_area_exited(area):
	EventBus.emit_signal("hideControlNote", self)
