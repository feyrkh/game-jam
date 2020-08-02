extends Node2D
class_name ToolHolder

var heldItem:Tool
onready var activeDirectionNode:Node2D = $R

func pickup(item:Tool):
	if heldItem != null:
		dropHeldItem()
	heldItem = item
	activeDirectionNode.add_child(item)
	item.pickedUp(self)

func dropHeldItem():
	var player:Node2D = get_parent()
	var playerEnv:Node2D = get_parent().get_parent()
	playerEnv.add_child(heldItem)
	heldItem.z_index = player.z_index - 1
	heldItem.position.x = player.position.x
	heldItem.position.y = player.position.y

func changeDirection(dirName:String):
	if !heldItem: return
	activeDirectionNode.remove_child(heldItem)
	activeDirectionNode = get_node_or_null(dirName)
	if activeDirectionNode == null: activeDirectionNode = $R
	if activeDirectionNode == $L: heldItem.scale.x = -abs(heldItem.scale.x)
	else: heldItem.scale.x = abs(heldItem.scale.x)
	activeDirectionNode.add_child(heldItem)
	heldItem.position.x = 0
	heldItem.position.y = 0
