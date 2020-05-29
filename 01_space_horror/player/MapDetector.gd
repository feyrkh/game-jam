extends KinematicBody2D

func disableLeftRight():
	get_parent().leftRightInput = false
	
func enableLeftRight():
	get_parent().leftRightInput = true
	
func disableUpDown():
	get_parent().upDownInput = false

func enableUpDown():
	get_parent().upDownInput = true
