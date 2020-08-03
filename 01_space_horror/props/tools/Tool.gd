extends Node2D
class_name Tool

var isActive = false

func dropped():
	pass
	
func pickedUp(toolHolder):
	pass

func _process(delta):
	if isActive:
		if !Input.is_action_pressed("ui_accept") || Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down"):
			isActive = false
			stopActivation()

func stopActivation():
	isActive = false
	
func startActivation():
	isActive = true
