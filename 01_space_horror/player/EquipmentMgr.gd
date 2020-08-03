extends Node
class_name EquipmentManager

export(int) var itemEnergy = 0
export(String) var itemHeld = null

func addEquipment(equipmentType:String, itemEnergy:int):
	print("Picked up ", equipmentType)
	self.itemHeld = equipmentType
	self.itemEnergy = itemEnergy
	var toolHolder:ToolHolder = get_parent().get_node("ToolHolder") as ToolHolder
	var newItem:Tool = load("res://props/tools/"+itemHeld+".tscn").instance()
	toolHolder.pickup(newItem)

func dropEquipment():
	itemHeld = null
	itemEnergy = 0
	
func canAccept(equipmentType:String):
	return itemHeld == null

func canUseEquipment(equipmentType:String, energyNeeded:int) -> bool:
	return itemHeld == equipmentType && itemEnergy >= energyNeeded

func useEquipment(equipmentType:String, energyAmt:int) -> bool:
	if itemHeld == equipmentType:
		var toolHolder:ToolHolder = get_parent().get_node("ToolHolder") as ToolHolder
		toolHolder.heldItem.startActivation()
		return true
	return false
