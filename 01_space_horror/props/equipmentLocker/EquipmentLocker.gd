extends Interactable

export(String) var equipmentType
export(String) var equipmentFriendlyName

func interact(equipmentMgr:EquipmentManager):
	equipmentMgr.addEquipment(equipmentType)
	
func _on_ActivationArea_area_entered(area):
	print("Entered area")
	if canInteract(area.get_parent().get_node_or_null("EquipmentMgr")): EventBus.emit_signal("showControlNote", equipmentFriendlyName+": Press E to pick up")

func _on_ActivationArea_area_exited(area):
	EventBus.emit_signal("hideControlNote")

func canInteract(equipmentMgr:EquipmentManager):
	return true
