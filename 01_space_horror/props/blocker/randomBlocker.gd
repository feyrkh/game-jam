extends Node2D

export var forceVisible = false
var repairEnergyNeeded = 0
var showingRepairPrompt:bool = false

func _ready():
	if randf() > 0.2 && !forceVisible: hideBlocker()
	if randf() >= 0.5: 
		$tilebarrier.queue_free()
		repairEnergyNeeded = 10
	else: 
		$tilehole.queue_free()
		repairEnergyNeeded = 5

func hideBlocker():
	visible = false
	$StaticBody2D/CollisionShape2D.disabled = true
	
func showBlocker():
	if !isTileNearPlayer():
		visible = true
		$StaticBody2D/CollisionShape2D.disabled = false
		

func damage():
	if randf() < 0.1: showBlocker()

func isTileNearPlayer():
	var player = get_tree().get_nodes_in_group("player")[0]
	var tileGlobalX = global_position.x
	var tileGlobalY = global_position.y
	var xDist = abs(player.global_position.x - tileGlobalX)
	var yDist = abs(player.global_position.y - tileGlobalY)
	if xDist <= 100 and yDist <= 100:
		return true

func canInteract(equipmentMgr:EquipmentManager):
	return equipmentMgr.canUseEquipment("repair", 0)

func interact(equipmentMgr:EquipmentManager):
	if equipmentMgr.canUseEquipment("repair", repairEnergyNeeded):
		equipmentMgr.useEquipment("repair", repairEnergyNeeded)

func _on_ActivationArea_area_entered(area):
	var equipmentMgr:EquipmentManager = area.get_parent().get_node_or_null("EquipmentMgr") as EquipmentManager
	if equipmentMgr.canUseEquipment("repair", 0):
		showingRepairPrompt = true
		if equipmentMgr.canUseEquipment("repair", repairEnergyNeeded):
			EventBus.emit_signal("showControlNote", "Press E to repair", self)
		else:
			EventBus.emit_signal("showControlNote", "Battery is dead, get a new repair tool!", self)


func _on_ActivationArea_area_exited(area):
	EventBus.emit_signal("hideControlNote", self)
