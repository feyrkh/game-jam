extends Interactable

export var equipmentType = "repair"
export var equipmentFriendlyName = "Welding Torch"

func interact(equipmentMgr:EquipmentManager):
	equipmentMgr.addEquipment(equipmentType, 100)
	EventBus.emit_signal("hideControlNote", self)
	
func _on_ActivationArea_area_entered(area):
	print("Entered area")
	var equipmentMgr:EquipmentManager = area.get_parent().get_node_or_null("EquipmentMgr") as EquipmentManager
	if equipmentMgr.canAccept(equipmentType):
		EventBus.emit_signal("showControlNote", equipmentFriendlyName+": Press E to pick up", self)
	else: 
		EventBus.emit_signal("showControlNote", "Hands full, drop your item to get "+equipmentFriendlyName, self)

func _on_ActivationArea_area_exited(area):
	EventBus.emit_signal("hideControlNote", self)

func canInteract(equipmentMgr:EquipmentManager):
	return equipmentMgr.canAccept(equipmentType)
	
