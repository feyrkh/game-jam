extends Area2D

enum FocusDirection {Center, Top, Left, Right, Bottom}

export(FocusDirection) var cameraFocus = FocusDirection.Center

onready var camera:Camera2D
onready var shape:RectangleShape2D = $CollisionShape2D.shape


func _ready():
	if camera == null: 
		camera = get_tree().get_root().find_node("*Camera2D", true, false)
	print_debug("Camera: ", camera)
	if cameraFocus == FocusDirection.Center:
		$CameraFocus.position = self.position
	elif cameraFocus == FocusDirection.Top:
		$CameraFocus.position = self.position - Vector2(0, shape.extents.y/2)
	elif cameraFocus == FocusDirection.Bottom:
		$CameraFocus.position = self.position + Vector2(0, shape.extents.y/2)
	elif cameraFocus == FocusDirection.Right:
		$CameraFocus.position = self.position + Vector2(shape.extents.x/2, 0)
	elif cameraFocus == FocusDirection.Left:
		$CameraFocus.position = self.position - Vector2(shape.extents.x/2, 0)

func _on_FixedCameraTrigger_body_entered(_body):
	if camera == null:
		return
	if camera.has_method("on_fixed_mode_entered"):
		camera.on_fixed_mode_entered($CameraFocus)
	if cameraFocus == FocusDirection.Center and camera.has_method("transitionToNextRegion"):
		camera.transitionToNextRegion()

func _on_FixedCameraTrigger_body_exited(_body):
	if camera.has_method("on_fixed_mode_exited"):
		camera.on_fixed_mode_exited($CameraFocus)
	if cameraFocus == FocusDirection.Center and camera.has_method("transitionToNextRegion"):
		camera.transitionToNextRegion()
