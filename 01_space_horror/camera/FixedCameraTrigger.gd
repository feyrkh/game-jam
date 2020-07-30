extends Area2D

enum FocusDirection {Center, Top, Left, Right, Bottom}

export(FocusDirection) var cameraFocus = FocusDirection.Center
export(bool) var overrideFixedX
export(bool) var overrideFixedY

onready var camera:Camera2D
onready var shape:RectangleShape2D = $CollisionShape2D.shape


func _ready():
	if camera == null: 
		camera = get_tree().get_root().find_node("*Camera2D", true, false)
	print_debug("Camera: ", camera)
	if cameraFocus == FocusDirection.Center:
		$CameraFocus.global_position = self.global_position
	elif cameraFocus == FocusDirection.Top:
		$CameraFocus.global_position = self.global_position - Vector2(0, shape.extents.y/2)
	elif cameraFocus == FocusDirection.Bottom:
		$CameraFocus.global_position = self.global_position + Vector2(0, shape.extents.y/2)
	elif cameraFocus == FocusDirection.Right:
		$CameraFocus.global_position = self.global_position + Vector2(shape.extents.x/2, 0)
	elif cameraFocus == FocusDirection.Left:
		print_debug("Adjusting from ", self.global_position, " to ", self.global_position - Vector2(shape.extents.x/2, 0))
		$CameraFocus.global_position = self.global_position - Vector2(shape.extents.x/2, 0)

func _on_FixedCameraTrigger_body_entered(_body):
	print_debug("entered FixedCameraTrigger")
	var fixedX = overrideFixedX
	var fixedY = overrideFixedY
	if camera == null:
		return
		
	if cameraFocus == FocusDirection.Center:
		if fixedX != true: fixedX = false
		if fixedY != true: fixedY = false
		if _body.has_method("enableLeftRight"): _body.enableLeftRight()
		if _body.has_method("enableUpDown"): _body.enableUpDown()
	elif cameraFocus == FocusDirection.Left or cameraFocus == FocusDirection.Right:
		if _body.has_method("enableLeftRight"): _body.enableLeftRight()
		if _body.has_method("disableUpDown"): _body.disableUpDown()
		if fixedX != true: fixedX = false
		if fixedY != true: fixedY = true
	elif cameraFocus == FocusDirection.Up or cameraFocus == FocusDirection.Down:
		if _body.has_method("disableLeftRight"): _body.disableLeftRight()
		if _body.has_method("enableUpDown"): _body.enableUpDown()
		if fixedX != true: fixedX = true
		if fixedY != true: fixedY = false
		
	if camera.has_method("on_fixed_mode_entered"):
		camera.on_fixed_mode_entered($CameraFocus, fixedX, fixedY, cameraFocus == FocusDirection.Center)

func _on_FixedCameraTrigger_body_exited(_body):
	print_debug("exited FixedCameraTrigger")
	if camera.has_method("on_fixed_mode_exited"):
		camera.on_fixed_mode_exited($CameraFocus, cameraFocus == FocusDirection.Center)
