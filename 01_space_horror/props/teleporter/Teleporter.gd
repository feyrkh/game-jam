extends Area2D
class_name Teleporter

var _targetPosition2D

func setExit(exitPoint:Position2D):
	_targetPosition2D = exitPoint

func _ready():
	_targetPosition2D = find_node("Position2D", true, false)
	#if _targetPosition2D == null:
	#	push_error("Teleporter must have Position2D child attached")

func _on_Teleporter_body_entered(body:KinematicBody2D):
	# find teleportable body in scene tree if possible
	print_debug("Teleporting...")
	var curNode = body
	while curNode != null and curNode.get_groups().find("teleportable") == -1:
		curNode = curNode.get_parent()
	if curNode != null:
		body = curNode
	if body.has_method("teleport"):
		body.teleport(_targetPosition2D.global_position)
	else:
		body.global_position = _targetPosition2D.global_position

