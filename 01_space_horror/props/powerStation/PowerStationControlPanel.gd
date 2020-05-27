extends PopupPanel

signal powerUp
signal controlPanelOpened
signal controlPanelClosed

func _ready():
	emit_signal("controlPanelOpened")
	set_process_input(true)
	popup_centered()
	print_debug("Popup centered at: ", self.rect_global_position)
	print_debug("Popup visible: ", self.visible)
	print_debug("Popup position: ", self.rect_position)


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("powerUp")
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		self.queue_free()
		emit_signal("controlPanelClosed")
		get_tree().set_input_as_handled()
